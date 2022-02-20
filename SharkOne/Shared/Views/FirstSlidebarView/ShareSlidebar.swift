//
//  ShareSlidebar.swift
//  SharkOne
//
//  Created by Murloc Wan on 2022/2/9.
//  第一栏，点击进入 second 对应的页面

import SwiftUI

struct ShareSlidebar: View {
    var body: some View {
        List {
            Section("基础指南") {
                NavigationLink(destination: IssuesView(vm: LocalIssuesVM())) {
                    SlideBarLabel(title: "语言", imageName: "Slide1")
                }
                NavigationLink(destination: SharkFoundationView()) {
                    SlideBarLabel(title: "基础库", imageName: "Slide2")
                }
                NavigationLink(destination: SharkSubjectView()) {
                    SlideBarLabel(title: "专题", imageName: "Slide3")
                }
            }
        }
    }
}

struct ShareSlidebar_Previews: PreviewProvider {
    static var previews: some View {
        ShareSlidebar()
    }
}
