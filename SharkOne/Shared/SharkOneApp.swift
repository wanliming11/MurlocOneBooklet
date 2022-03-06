//
//  SharkOneApp.swift
//  Shared
//
//  Created by Murloc Wan on 2022/2/9.
//

import SwiftUI

@main
struct SharkOneApp: App {
    var body: some Scene {
        WindowGroup {
            #if os(iOS)
            SharkiOSMainView()
            #else
            MainWindowView()
            #endif
        }
    }
}
