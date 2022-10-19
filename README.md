# SentenceUI
<img width="311" alt="Screen Shot 2022-10-18 at 10 05 23 PM" src="https://user-images.githubusercontent.com/1122859/196602163-65edb5c6-14ce-4f25-935a-c3ef2043d32f.png">

SentenceUI is an SwiftUI package for building form interfaces with natural language. 

## Features

The goal for SentenceUI is to make it as easy as possible to implement Sentences in SwiftUI while still allowing for customization and extension. Features include:

- 🔥 Declarative syntax for building Sentences using defined Fragment types and `@State` properties
- 🎨 Fully customizable style using native content modifiers
- 🏛 Built using native UI elements such as Text, TextField, Menu, and Picker
- 🦄 Built-in block to handle special cases that arise when selected word forms need adjusted (Eg. "None" to "no")
- 🧑‍🚀 Automatic spacing and wrapping between sentence fragments (Thanks to our only dependency, [WrappingHStack!](https://github.com/dkk/WrappingHStack))


## Install
Use Swift Package Manager and point to this repo!

## Example
```swift
import SentenceUI

// Content modifiers used here will be applied to all fragments in a Sentence
struct BoldRed: SentenceStyleModifier {
    var fontSize: CGFloat = 50
    func body(content: Content) -> some View {
        content
            .tint(.red)
            .font(.system(size: fontSize, weight: .bold, design: .rounded))
    }
}

struct SentenceView: View {

    // Define state
    @State var size: String = "Large"
    @State var sweetAmt: String = "Light"
    @State var sweetnerType: String = "Sugar"
    @State var instructions: String = ""
    
    
    var body: some View {
        Sentence(
            fragments: [
            // Plain text fragment
            .text("I would like a"), 
            // Multichoice fragment allow users to select from an array of strings 
            .choice(ChoiceConfig(tag: "size", value: $size, options: ["Large", "Medium", "Small"], mask: nil)),
            .text("drink with"),
            .choice(ChoiceConfig(tag: "sweetAmt", value: $sweetAmt, options: ["Sweet", "Light", "None"], mask: nil)),
            .choice(ChoiceConfig(tag: "sweetType", value: $sweetnerType, options: ["Sugar", "Splenda", "Honey"], mask: nil))
        ],
            // Special cases block is where you can adjust word forms
            specialCases: { fragments in
                // Fragments to replace
                var replacements: [Fragment] = []
                
                // Get fragments by tag
                let amt = fragments.with(tag: "sweetAmt")!
                let sweetness = fragments.with(tag: "sweetType")!
                
                // Since fragments are enums you can handle special cases with case statement
                switch (amt, sweetness) {
                case (.choice(let a),.choice(_)):
                    // In this example, we want to prevent the sentence from reading "with None sugar"
                    // so we set the fragment mask to "No" so it displays sensibly
                    if a.value.wrappedValue == "None" {                        
                        replacements.append(.choice(ChoiceConfig(from: a, with: "No")))
                    }
                default:
                    break
                }
                
                // Always call modify with your replacements and return the result
                return fragments.modify(replacements)
        },
        style: BoldRed())
    }
}
```

## About
This type of UI has been used successfully by apps like Beats by Dre (pre Apple Music) and Philz Coffee; both of which served as inspirations for this project. Natural language interfaces enjoy the advantage of feeling instantly familiar to users. If you can read, you already know how to use it. They're fun to develop with, too, because you have to step into the user's story in order to compose the sentences about what they're doing inside of your application.

This is the updated SwiftUI version of my previous [SentenceKit project](https://github.com/rkirkendall/SentenceKit). More thoughts on this [blog post](https://medium.com/@rickykirkendall/philz-app-review-a8efa508fd42).
