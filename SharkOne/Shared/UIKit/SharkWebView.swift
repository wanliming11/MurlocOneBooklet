//
//  SharkWebView.swift
//  SharkOne
//
//  Created by Murloc Wan on 2022/2/20.
//

import Foundation
import WebKit

/// 普通的 UIView 对接到 SwiftUI 的过程
struct SharkWebView: ViewRepresentable {
    let urlStr: String
    
    func makeNSView(context: Context) -> some WKWebView {
        return WKWebView()
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        if let url = URL(string: urlStr) {
            let r = URLRequest(url: url)
            nsView.load(r)
        }
    }
}
