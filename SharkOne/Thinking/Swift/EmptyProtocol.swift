//
//  EmptyProtocol.swift
//  SharkOne (macOS)
//
//  Created by Murloc Wan on 2022/5/8.
//

import Foundation

/// 通常情况下，为了让一类对象能遵循同样的逻辑，我们会去定义一个基类或者定义一个协议，来满足一致行为。
/// 例如 OC  里面的 NSObject
/// 还有另一种用法，对于协议，如果你想两个类解耦，可以利用空协议，耦合点，只需要遵循这个空协议的处理即可，无需依赖实际的对象


protocol EmptyProtocol {
    
}


/// 示例：
class InstanceA: EmptyProtocol {

}

class InstanceB: EmptyProtocol {
    
}


/// 调用方：
class InstanceDo {
    func doAction(_ s: EmptyProtocol) {
        
    }
}
