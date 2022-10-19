//
//  Sentence.swift
//  SwiftUISentences
//
//  Created by Ricky Kirkendall on 9/25/22.
//

import SwiftUI
import WrappingHStack

public protocol SentenceStyleModifier: ViewModifier {
    var fontSize: CGFloat {get}
}

public struct Sentence<T: SentenceStyleModifier>: View {
    private let fragments: [Fragment]
    private let specialCases: ([Fragment]) -> [Fragment]
    private let styleMod: T
    
    private var outputFragments: [Fragment]{
        let o = specialCases(fragments)
        return o
    }
    
    private var padding: CGFloat {
        // Calculate padding between elements to be roughly one space length
        return CGFloat(styleMod.fontSize / 10)
    }
    
    public init(fragments:[Fragment], specialCases:@escaping ([Fragment])->[Fragment], style: T) {
        self.fragments = fragments
        self.specialCases = specialCases
        self.styleMod = style
    }
    
    public var body: some View {
        WrappingHStack(0...outputFragments.count-1, id:\.self) { //TODO: Replace with Grid
            outputFragments[$0]
                .modifier(styleMod)
                .padding(padding)
            // TODO: make this configurable
        }
    }
}
