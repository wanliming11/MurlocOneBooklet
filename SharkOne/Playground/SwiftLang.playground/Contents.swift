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


