import UIKit
import Dispatch
import SwiftUI
import PlaygroundSupport

var greeting = "Hello, playground"

///1. Mirror
/// 可以很方便的访问已有元素，但只能只读访问，是无法进行值写入的

struct OriginalStruct {
    var value = 12
    var name = "abc"
    var values = [12, 14, 17]
}


var original = OriginalStruct()

var mirrorOriginal = Mirror(reflecting: original)
for (k, v) in mirrorOriginal.children {
    if k == "values" {
        let _ = v as? Array<Int>
//        print(v)
    }
}

/// 2. LLVM 泛型 https://www.youtube.com/watch?v=ctS8FzqcRug




/// 3. BoxBuilder
@resultBuilder
struct BoxBuilderV2 {
    static func buildBlock(_ components: BoxV2...) -> [BoxV2] {
        return components
    }
    
    // 可选的返回，对应 if 条件
    static func buildOptional(_ component: BoxV2?) -> BoxV2 {
        return component ?? BoxV2(name: "Empty")
    }
        
}


class BoxV2: BoxLoadLifecycle {
    /// 1. 内部属性加载优先级
    enum Opportunity {
        case Default(Int)
        case Low(Int)
        case High(Int)
    }
    
    /// 2. 加载
    enum LoaderOpportunity {
        case Default  /// 初始化就加载
        case Lazy    /// 当有业务调用的时候加载
    }
    
    
    private var id = UUID()
    var name: String = ""
    var content: BoxContent
    
    var opportunity: Opportunity
    var loadOpportunity: LoaderOpportunity = .Default
    
    /// 普通初始化
    init(name: String) {
        self.name = name
        self.opportunity = .Default(111)
        self.content = .single
    }
    
    /// resultBuilder 的初始化
    init(name: String, @BoxBuilderV2 builder: ()-> [BoxV2]) {
        self.name = name
        self.content = .group(builder())
        self.opportunity = .Default(111)
    }
    
    ///MARK: lifecycle
    func load() {
    }
    
    func focusRefresh() {
    }
    
    func recycle() {
    }
    
    
    /// 内容加载的唯一方法，注意这是一个递归调用，会不断便利子 box 进行循环
    /// TODO: 这里会支持按优先级来进行加载，只在一个作用域内
    func resume() {
        func recursive(_ box: BoxV2) {
            switch box.content {
                case .single:
                    box.load()
                case .group(let v):
                    v.map {
                        recursive($0)
                    }
            }
        }
        
        recursive(self)
    }
}

/// 扩展 BoxV2 的内容，支持single 和 group
extension BoxV2 {
    indirect enum BoxContent {
        case single
        case group([BoxV2])
    }
}

protocol BoxLoadLifecycle {
    /// 加载执行的内容
    func load()
    
    /// 内容强制刷新，注意 box 本身不会重新创建
    func focusRefresh()
    
    /// 释放
    func recycle()
}

/// Box DI 容器，用来解决 DI 容器的注册与邦迪



/// Box 之间的通信模式
internal struct ServiceKey {
    internal let serviceType: Any.Type

    internal init(
        serviceType: Any.Type
    ) {
        self.serviceType = serviceType
    }
}

// MARK: Hashable

extension ServiceKey: Hashable {
    static func == (lhs: ServiceKey, rhs: ServiceKey) -> Bool {
        return lhs.serviceType == rhs.serviceType
    }
    
    public func hash(into hasher: inout Hasher) {
        ObjectIdentifier(serviceType).hash(into: &hasher)
    }
}

class BoxCaller {
    static let single = BoxCaller()
    private var _innerInterServices: [ServiceKey: AnyObject] = [:]
    private var _innerNotifServices: [ServiceKey: [AnyObject]] = [:]
    
    ///1. 接口协议的实现，先绑定后，其他需要使用的使用方会再处理
    ///1.1 绑定接口协议
    func bind<Service>(_ object: AnyObject, _ protocolName: Service.Type) {
        
        let key = ServiceKey(serviceType: protocolName)
        if _innerInterServices[key] == nil {
            _innerInterServices[key] = object
        }
    }
    
    /// 通过绑定的协议获取对象
    /// 1.2 获得对象调用
    func call<Service>(_ protocolName: Service.Type) -> Service? {
        let key = ServiceKey(serviceType: protocolName)
        return _innerInterServices[key] as? Service
    }
    
    /// 2.通知对应的绑定的业务去接收对应的通知内容
    /// 2.1 通知发出，注意这个是同步的调用, 加入第一个参数是为了类型推到后面的调用
    func notif<Service>(_ name: Service.Type, _ f:(Service) -> Void) {
        let key = ServiceKey(serviceType: name)
        if let notifClients = _innerNotifServices[key], notifClients.count > 0 {
            print(notifClients)
            notifClients.map {
                f($0 as! Service)
            }
        }
    }
    
    /// 2.2 注册对象
    func reg<Service>(_ object: AnyObject, _ notifName: Service.Type) {
        let key = ServiceKey(serviceType: notifName)
        _innerNotifServices[key, default: []].append(object)
        print(_innerNotifServices)
    }
    
}


/// 测试
class RoomBox: BoxV2, RoomInterface, StreamNotif {
    /// Interface
    func roominfo() -> Dictionary<String, Any> {
        return ["rid": 123456, "isMatch": true]
    }
    
    /// Notif
    func hasLoad() {
        print("Received the stream notif")
    }

    override func load() {
        BoxCaller.single.bind(self, RoomInterface.self)
        BoxCaller.single.reg(self, StreamNotif.self)
    }
    
    override func focusRefresh() {
    }
    
    override func recycle() {
        
    }
    
}

protocol RoomInterface {
    func roominfo() -> Dictionary<String, Any>
}


class StreamBox: BoxV2, StreamInterface {
    func hasP2P() -> Bool {
        return true
    }

    override func load() {
        BoxCaller.single.bind(self, StreamInterface.self)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
            BoxCaller.single.notif(StreamNotif.self) { $0.hasLoad() }
        }
        
    }
    
    override func focusRefresh() {
    }
    
    override func recycle() {
    }
}

protocol StreamInterface {
    func hasP2P() -> Bool
}

protocol StreamNotif {
    func hasLoad()
}

let roomB = RoomBox(name: "room")
let streamB = StreamBox(name: "stream")

let _ = BoxV2(name:"PlayerRoom")  {
    roomB
    streamB
    BoxV2(name: "activity") {
        BoxV2(name: "activity1")
        BoxV2(name: "activity2")
    }
}.resume()

let v = BoxCaller.single.call(RoomInterface.self)?.roominfo()
let b = BoxCaller.single.call(StreamInterface.self)?.hasP2P()




/// String .start .end

let v1 = (key:1, value: 12)   /// key，value 只是作为元组的描述？
let v2 = v1.0
let v3 = v1.1
//v.1
let v4 = (1, 12)
v4.0
v4.1
