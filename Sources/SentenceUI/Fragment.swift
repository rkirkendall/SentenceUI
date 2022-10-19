//
//  Fragment.swift
//  SwiftUISentences
//
//  Created by Ricky Kirkendall on 9/25/22.
//

import SwiftUI

// Needed so the Picker in MultiChoice can use an array of strings
extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}

// Convenience functions to allow for easy Fragment identification and modification
// inside the specialCases block
extension Array where Element == Fragment {
    func modify(_ fragments: [Fragment]) -> [Fragment] {
        return map { (f: Fragment) -> Fragment in
            switch(f) {
            case .choice(let a):
                if let matchingReplacement = fragments.with(tag: a.tag) {
                    return matchingReplacement
                } else { return f }
            case .freeform(let a):
                if let matchingReplacement = fragments.with(tag: a.tag) {
                    return matchingReplacement
                } else { return f }
            default:
                return f
            }
        }
    }
    
    func with(tag: String) -> Fragment? {
        return filter {
            switch $0 {
            case .choice(let c):
                return c.tag == tag
            case .freeform(let c):
                return c.tag == tag
            default:
                return false
            }
        }.first
    }
}

public struct ChoiceConfig {
    let tag: String
    let value: Binding<String>
    let options: [String]
    let mask: String?
    
    var display: String {
        get { return mask ?? value.wrappedValue }
    }
}

extension ChoiceConfig {
    init(from config: ChoiceConfig, with mask: String){
        tag = config.tag
        value = config.value
        options = config.options
        self.mask = mask
    }
}

public struct FreeformConfig {
    let tag: String
    let value: Binding<String>
    let prompt: String
}

public enum Fragment: View {
    case text(String) // prompt
    case choice(ChoiceConfig) // choices
    case freeform(FreeformConfig) // prompt
    
    @available(iOS 14.0, *)    
    @ViewBuilder
    public var body: some View {
        switch self {
        case .choice(let config):
            Menu {
                Picker(config.display, selection: config.value) {
                    ForEach(config.options) { option in
                        Text(option)
                            .tag(option)
                    }
                }
            }label: { // make this configurable
                Text(config.display).underline()
            }.transaction { transaction in // Remove SwiftUI's default animation
                transaction.animation = nil
            }
        case .freeform(let config):
            TextField(config.prompt, text: config.value)
        case .text(let s):
            Text(s)
        }
    }
}
