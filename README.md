# SentenceUI

SentenceUI is an SwiftUI package for building form interfaces with natural language. This type of UI has been used successfully by apps like Beats by Dre (pre Apple Music) and Philz Coffee; both of which served as inspirations for this project. Natural language interfaces enjoy the advantage of feeling instantly familiar to users. If you can read, you already know how to use it. NLI's can also help to provide structure to the UX, as sentences are inherently narrative. They're fun to develop with, too, because you have to step into the user's story in order to compose the sentences about what they're doing inside of your application.

The goal for SentenceUI is to make it as easy as possible to implement Sentences in SwiftUI while still allowing for customization and extension. Features include:

- 🔥 Declarative syntax for defining Sentences using defined Fragment types and `@State` properties
- 🎨 Fully customizable style using native content modifiers
- 🦄 Built-in block to handle special cases that arise when selected word forms need adjusted (Eg. "None" to "no")
- 🧑‍🚀 Automatic spacing and wrapping between sentence fragments

## Install
Use Swift Package Manager and point to this repo!

## Example
```swift
import SentenceUI

struct BoldRed: SentenceStyleModifier {
    var fontSize: CGFloat = 50
    func body(content: Content) -> some View {
        content
            .tint(.red)
            .font(.system(size: fontSize, weight: .bold, design: .rounded))
    }
}

struct SentenceView: View {
    @State var size: String = "Large"
    @State var sweetAmt: String = "Light"
    @State var sweetnerType: String = "Sugar"
    @State var instructions: String = ""
    
    
    // TODO: API for styling Fragments and Sentences
    var body: some View {
        Sentence(
            fragments: [
            .text("I would like a"),
            .choice(ChoiceConfig(tag: "size", value: $size, options: ["Large", "Medium", "Small"], mask: nil)),
            .text("drink with"),
            .choice(ChoiceConfig(tag: "sweetAmt", value: $sweetAmt, options: ["Sweet", "Light", "None"], mask: nil)),
            .choice(ChoiceConfig(tag: "sweetType", value: $sweetnerType, options: ["Sugar", "Splenda", "Honey"], mask: nil))
        ],
            specialCases: { fragments in
                var replacements: [Fragment] = []
                
                let amt = fragments.with(tag: "sweetAmt")!
                let sweetness = fragments.with(tag: "sweetType")!
                
                switch (amt, sweetness) {
                case (.choice(let a),.choice(_)):
                    if a.value.wrappedValue == "None" {                        
                        replacements.append(.choice(ChoiceConfig(from: a, with: "No")))
                    }
                default:
                    break
                }
                return fragments.modify(replacements)
        },
        style: BoldRed())
    }
}
```
