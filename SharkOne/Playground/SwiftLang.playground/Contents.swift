import UIKit

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
        let v = v as? Array<Int>
        print(v)
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


class BoxV2 {
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
    private var name: String = ""
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
    
    
    /// 内容加载的唯一方法，注意这是一个递归调用，会不断便利子 box 进行循环
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

extension BoxV2: BoxLoadLifecycle {
    func load() {
        print("Load box \(self.name)")
    }
    
    func focusRefresh() {
        print("FocusRefresh box \(self.name)")
    }
    
    func recycle() {
        print("Recycle box \(self.name)")
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


let _ = BoxV2(name:"PlayerRoom")  {
    BoxV2(name: "room")
    BoxV2(name: "stream")
    BoxV2(name: "activity") {
        BoxV2(name: "activity1")
        BoxV2(name: "activity2")
    }
}.resume()




