//
//  SharkLocalIssuesVM.swift
//  SharkOne
//
//  Created by Murloc Wan on 2022/2/20.
//  本地从 json 配置拿到 issues 列表的配置表

import Foundation

final class LocalIssuesVM: ObservableObject {
    /// 核心的数据源, g
    @Published private(set) var issues: [LocalJsonIssuesModel]
    
    init() {
        self.issues = [LocalJsonIssuesModel]()
    }
    
    func loadData() {
        // 1. 从本地 json 读 data
        let data = SharkTool.loadBundleData(ShareOneConfig.issueMappingPath)
        
        // 2. 使用 jsondecoder 解码出对象
        do {
            let decode = JSONDecoder()
            self.issues =  try decode.decode([LocalJsonIssuesModel].self, from: data)
        }
        catch {
            fatalError("Couldn't parse")
        }
    }
    
    
    
}
