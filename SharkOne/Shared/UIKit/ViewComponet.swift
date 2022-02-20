//
//  ViewComponet.swift
//  SharkOne
//
//  Created by Murloc Wan on 2022/2/19.
//

import Foundation
import SwiftUI
import MarkdownUI

// MarkdownUI
struct MarkdownView: View {
    var s: String
    var body: some View {
        Markdown(s)
            .markdownStyle(MarkdownStyle(font:.title3))
    }
}


// 跳转到web的button
struct GoToWebButton: View {
    var url: String
    var text: String
    
    var body: some View {
        Button {
            gotoWebBrowser(urlStr: url)
        } label: {
            Text(text)
        }
    }
}
