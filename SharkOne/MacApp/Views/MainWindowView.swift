//
//  MainWIndowView.swift
//  SharkOne
//
//  Created by Murloc Wan on 2022/2/9.
//

import SwiftUI
import MarkdownUI

struct MainWindowView: View {
    var body: some View {
        /// 这里是让一些学习的思考点有执行的机会
        MMOAlgoBoundaryAndSlice.thinking()
        AlgoMath.thinking()
        
        let _ = currentContainer

        return NavigationView {
            ShareSlidebar()
            Text("分类")
            Text("详情")
            ScrollView {
                let s = SharkTool.loadBundleString(SharkTool.loadBundleData("update.md"))
                Markdown(s).markdownStyle(MarkdownStyle(font: .title3))
            }
        }
        .navigationTitle("移动知识库")
    }
}



struct MainWindowView_Previews: PreviewProvider {
    static var previews: some View {
        MainWindowView()
    }
}
