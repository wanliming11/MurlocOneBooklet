//
//  SharkLangView.swift
//  SharkOne
//
//  Created by Murloc Wan on 2022/2/9.
//  语言的列表页，列表的内容过从本地的 json 获取

import SwiftUI

struct SharkLangView: View {
    var body: some View {
        Text("基础语言")
    }
}

/// 基础语言的本地视图列表的内容，从本地 json 获取
struct IssuesView: View {
    @StateObject var vm: LocalIssuesVM
    
    var body: some View {
        List {
            ForEach(vm.issues) { ci in
                Section(ci.name) {
                        ForEach(ci.issues) { i in
                            NavigationLink {
                                IssueDetailView(title: i.title, number: i.number)
                            } label: {
                                Text(i.title)
                            }
                        }
                    }
                }
            }
            .onAppear {
                vm.loadData()
            }
    }
}


struct SharkLangView_Previews: PreviewProvider {
    static var previews: some View {
        SharkLangView()
    }
}
