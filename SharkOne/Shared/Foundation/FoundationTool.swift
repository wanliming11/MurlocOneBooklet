//
//  FoundationTool.swift
//  SharkOne
//
//  Created by Murloc Wan on 2022/2/10.
//

import Foundation
import AppKit
import SwiftUI


final class SharkTool {
    
    /// 从本地文件中读取二进制数据
    static func loadBundleData(_ filename: String) -> Data {
        let data: Data
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
            fatalError("Tools === can't find \(filename)!")
        }
        
        do {
            data = try Data(contentsOf: file)
            return data
        }
        catch {
            fatalError("Tools === convert to data error!")
        }
    }
    
    /// 二进制数据转换为字符串
    static func loadBundleString(_ data: Data) -> String {
        return String(decoding: data, as: UTF8.self)
    }
}

/// 定义出来，增加使用层的简洁
protocol Jsonable: Identifiable, Decodable, Hashable {}


/// 跳转浏览器显示内容
func gotoWebBrowser(urlStr: String) {
    if urlStr.isEmpty {
        print("Error: url is empty!")
    }
    else {
        let isValidUrl = urlStr.hasPrefix("http://") || urlStr.hasPrefix("https://")
        NSWorkspace.shared.open(isValidUrl ? URL(string: urlStr)! : URL(string: "")!)
    }
}


#if os(macOS)
typealias ViewRepresentable = NSViewRepresentable
#else
typealias ViewRepresentable = UIViewRepresentable
#endif
