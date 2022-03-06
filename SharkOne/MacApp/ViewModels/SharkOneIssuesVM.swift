//
//  SharkOneIssuesVM.swift
//  SharkOne
//
//  Created by Murloc Wan on 2022/2/19.
//  Issues 获取的 ViewModel

import Foundation
import Combine

// Issue Request, 用来发起单一的请求
struct IssueRequest: APIRequest {
    typealias Res = IssueModel
    
    var repoName: String
    var number: Int
    
    var path: String {
        return "/repos/\(repoName)/issues/\(number)"
    }
    
    var qItems: [URLQueryItem]? {
        return nil
    }
}


/// 用来获取对应的 github 的issues 数据
class SharkOneIssuesVM: APIVM {
    /// 外部可设置的内容
    public let repoName: String
    public let issueNumber: Int = 0
    
    private var cancellables: [AnyCancellable] = []  // Combine 对象，cancell 的 bag
    @Published private(set) var issue: IssueModel  //内部解码出来的对象，所以是私有的
    
    private let apISev: APISev = APISev()  //私有对象
    private let apIIssueSJ = PassthroughSubject<Void, Never>()
    private let errSJ = PassthroughSubject<APISevError, Never>()
    private let resSJ = PassthroughSubject<IssueModel, Never>()
    
    // MARK: APIVM 协议实现
    // 1. 初始化的时候需要请求数据
    // 2. 更新的时候需要请求数据
    enum IssueActionType {
        case inInit, update
    }
    
    typealias ActionType = IssueActionType  // 关联协议
    
    func doAction(_ action: IssueActionType) {
        switch action {
        case .inInit:
            apIIssueSJ.send(())
        case .update:
            apIIssueSJ.send(())
        }
    }
    
    
    init(_ repoName: String = "") {
        self.repoName = repoName
        self.issue = IssueModel()
        
        // Mark: - 对应 issue 的获取
        let reqIssue = IssueRequest(repoName: repoName, number: issueNumber)
        let resIssueSm = apIIssueSJ.flatMap { [apISev] in
                apISev.response(frome: reqIssue)
                    .catch {[weak self] error -> Empty<IssueModel, Never> in
                        self?.errSJ.send(error)
                        return .init()
                    }
            }
            .share()
            .subscribe(resSJ)
        
        
        let repIssueSM = resSJ.assign(to: \.issue, on: self)
        
        cancellables += [resIssueSm, repIssueSM]
        
    }
}
