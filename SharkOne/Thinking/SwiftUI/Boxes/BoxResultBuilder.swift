//
//  BoxResultBuilder.swift
//  SharkOne
//
//  Created by Murloc Wan on 2022/3/15.
//

import Foundation
import CoreMIDI
import SwiftUI

// MARK: 基础结构
struct Box {
    var id = UUID()          //唯一标识
    var name: String         //描述
    var opportunity: Int     // 加载时机，越低越先加载
    var content: BoxContent  // 内容可以是单一的 Box 结构，也可以是组的结构
    
    init(name: String, opportunity: Int, content: BoxContent) {
        self.name = name
        self.opportunity = opportunity
        print(name)
        self.content = content
    }
}

extension Box {
    enum BoxContent {
        case value(String)
        case group([Box])
    }
}


// 1. 以上按通常的结构性的语法转变为
//let box = [Box(name: "room", opportunity: 12, content: .value("12")),
//           Box(name: "stream", opportunity: 1, content: .value("1")),
//           Box(name: "activities", opportunity: 100, content: .group([
//                Box(name: "activity1", opportunity: 1000, content: .value("1000")),
//                Box(name: "activity2", opportunity: 1001, content: .value("1001")),
//           ]))
//        ]

// 2. resultBuilder
@resultBuilder
struct BoxBuilder {
    static func buildBlock(_ components: Box...) -> Box {
        return Box(name: "groupBoxes", opportunity: 12, content: .group(components))
    }
    
    // 可选的返回，对应 if 条件
    static func buildOptional(_ component: Box?) -> Box {
        return component ?? Box(name: "Empty", opportunity: 0, content: .value("empty"))
    }
        
}


struct BoxesContainer {
    var name: String
    var box: Box
    
    init(name: String, @BoxBuilder builder: ()-> Box ) {
        self.name = name
        self.box = builder()
    }
}


let currentContainer = BoxesContainer(name:"PlayerRoom")  {
    Box(name: "room", opportunity: 12, content: .value("12"))
    Box(name: "stream", opportunity: 1, content: .value("1"))
    BoxesContainer(name: "activity") {
        Box(name: "activity1", opportunity: 1000, content: .value("1000"))
        Box(name: "activity2", opportunity: 1001, content: .value("1001"))
    }.box
}


