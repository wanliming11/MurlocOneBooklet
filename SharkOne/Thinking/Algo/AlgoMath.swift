//
//  AlgoMath.swift
//  SharkOne
//
//  Created by Murloc Wan on 2022/4/9.
//  这里主要是常用数学公式的计算

import Foundation


struct AlgoMath {
    
    static func thinking() {
        print(AlgoMath.gcd(13, 12))
        print(AlgoMath.gcd(4, 2))
        print(AlgoMath.lcm(4, 2))
    }
    
    /// 1. 最大公约数的计算
    static func gcd(_ a: Int, _ b: Int) -> Int {
        if b == 0 { return a }
        return gcd(b, a % b)
    }
    
    /// 2. 最小公倍数
    static func lcm(_ a: Int, _ b: Int) -> Int {
        return a / gcd(a, b) * b
    }

}
