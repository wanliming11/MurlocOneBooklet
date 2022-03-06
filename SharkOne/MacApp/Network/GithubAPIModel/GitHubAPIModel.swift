//
//  GitHubAPIModel.swift
//  SharkOne
//
//  Created by Murloc Wan on 2022/2/19.
//

import Foundation

// MARK: issue
// 数据来源可参考： https://api.github.com/repos/wanliming11/SwiftBook/issues/1
struct IssueModel: Jsonable {
    var id: Int64 = 0
    var number: Int = 0  //issue 的 number 对应
    var title: String = ""
    var body: String?   //实际的内容
    var htmlUrl: String = ""   //html 内容，github 的原始返回时 html_url，使用decode 策略转换为驼峰
    var updatedAt: String = "" //更新时间
    var comments: Int = 0 //评论数
}

/// 本地的 json 文件对应的结构
struct LocalJsonIssuesModel: Jsonable {
    var id: Int64
    var name: String
    var issues: [LocalJsonIssueModel]
}

/// 本地的 json 文件对应的 issue 的单一结构
struct LocalJsonIssueModel: Jsonable {
    var id: Int64
    var title: String
    var number: Int
}
