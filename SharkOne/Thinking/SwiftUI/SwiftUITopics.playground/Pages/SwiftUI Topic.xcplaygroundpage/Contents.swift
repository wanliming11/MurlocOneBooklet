//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import SwiftUI

///Topic1: 上下滑动列表的场景
///两个 SwiftUI 的知识点：
///1. 如何布局超出屏幕外的区域  2. Drag 手势如何实现
// 另外一种方式是用 TabView
// 支持按页模式滚动，默认是横向的， rotate之后变成纵向的

struct MyView: View {
    var body: some View {
        VStack() {
            Text("123")
        }
    }
}

/// 最外层去设置容器的高度，内部都根据布局信息来处理
let myView = MyView().frame(width: 320, height: 480)
PlaygroundPage.current.setLiveView(myView)

//: [Next](@next)
