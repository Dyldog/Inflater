//
//  JustifiedText.swift
//  Inflater
//
//  Created by Dylan Elliott on 27/6/2024.
//

import SwiftUI
import DylKit

struct JustifiedText: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        HStack {
            ForEach(enumerated: text.components(separatedBy: " ")) { index, word in
                if index > 0 {
                    Spacer()
                }
                
                Text(word)
            }
        }
    }
  }
