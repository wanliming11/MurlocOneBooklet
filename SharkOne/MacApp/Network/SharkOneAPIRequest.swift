//
//  ShareOneAPIRequest.swift
//  SharkOne
//
//  Created by Murloc Wan on 2022/2/19.
//

import Foundation
import Combine
import CoreData

/// 抽象协议，请求，响应，错误，业务行为

// MARK: - 抽象协议
/// 请求协议，一定会传请求的路径 + 最终要解码的对象
protocol APIRequest {
    associatedtype Res: Decodable
    var path: String { get }
    var qItems: [URLQueryItem]? { get }
}

/// 响应协议, 范型协议，一定会与请求对象关联起来，最终返回 资源 + 是否有状态错误
/// 外部的网络请求处理逻辑需要实现该协议
private protocol APIResponse {
    func response<Request>(frome req: Request) -> AnyPublisher<Request.Res, APISevError> where Request: APIRequest
}

/// 服务错误，这里简单定义了两种错误的状态形象返回，一类是网络本身出错，一类是拿到数据后展示的内容出错
enum APISevError: Error {
    case resError
    case parseError
    
    var msg: String {
        switch self {
            case .resError:
                return "网络无法访问"
            case .parseError:
                return "内容出错"
        }
    }
}

/// 公共的事件处理行为，正常情况下上面三种就是一个基本网络请求的协议范本，但为了简化各种状态的响应逻辑，统一拿到数据的 Action 行为
/// 并且通过异步消息框架可监听会更有意义
protocol APIVM: ObservableObject {
    associatedtype ActionType
    func doAction(_ action: ActionType)
}


// MARK: 唯一的网络请求类
struct APISev: APIResponse {
    private let rootUrl: URL = URL(string: "https://api.github.com")!
    
    func response<Request>(frome req: Request) -> AnyPublisher<Request.Res, APISevError> where Request : APIRequest {
        // 1. 构建 URLRequest 对象
        let path = URL(string: req.path, relativeTo: rootUrl)!   // 这里有一个 rootUrl 的相对行为
        // URLComponents 存在的意义是可以把内容分为 scheme，host，path，queryItems
        var comp = URLComponents(url: path, resolvingAgainstBaseURL: true)!
        comp.queryItems = req.qItems
        var req = URLRequest(url: comp.url!)
        
        // 增加 github 的 token
        req.addValue("token \(ShareOneConfig.gitHubAccessToken)", forHTTPHeaderField: "Authorization")

        // 2. 添加 decoder
        // 返回类型是 json
        let de = JSONDecoder()
        de.keyDecodingStrategy = .convertFromSnakeCase
        
        // 3. 构建线程 queue
        let deQueue = DispatchQueue(label: "GitHub API Queue", qos: .default, attributes: .concurrent)
        
        // 4. 发起网络请求，输出 combine 的异步信号
        return URLSession.shared.dataTaskPublisher(for: req)
            .retry(2)
            .subscribe(on: deQueue)
            .receive(on: deQueue)  /// 接收数据在指定的队列
            .map { data, _  in
                return data
            }
            .mapError { _ in
                APISevError.resError
            } /// 以上都是拿数据
            .decode(type: Request.Res.self, decoder: de)
            .mapError { _ in
                APISevError.parseError
            } /// 拿到数据后进行解码
            .receive(on: RunLoop.main) /// 切换到主线程返回
            .eraseToAnyPublisher()    /// 最后变成一个 publisher
    }
}











