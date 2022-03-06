//import Foundation
//import Combine
//import Darwin
//
//
//// Combine
//// 1. 介绍：Combine - a declarative Swift API for processing values over time.  写代码的思路会不同于之前的命令式的数据处理，有效减少嵌套闭环和比较分散的代码，提高维护性，类似直播间这种强依赖特殊信号后加载业务的场景，特别适合。这里有大量例子：https://heckj.github.io/swiftui-notes/,  官方介绍地址： https://developer.apple.com/documentation/combine
//// 2. 核心思想: 发布者（发出信号），订阅者（订阅信号），操作符（组合信号）
//// Publisher: Just, Future, PassthroughSubject, Empty, CurrentValueSubject,
//// Operations:
//// removeDuplicates, flatmap, append, prepend, merge, zip, combineLatest
//// Scheduler
//// 3. 常用Foundation 里面的 API
//
///// 1.Introduce
//let arr = [1, 2, 3, 4, 5]
//
//// 命令式
//var sum1 = 0
//for a in arr {
//    sum1 += a
//}
//sum1
//
//// 声明式
//arr.reduce(0, +)
//
//// 直接通过 sink 下沉信号订阅
//let pA = Just(0)
//let pB = [2, 10, 13, 15].publisher
//let _ = pA.sink { v in
//    print("\(v)")
//}
//
//let _ = pB.sink { v in
//    print(v)
//}
//
//class AClass {
//    var p: Int = 0 {
//        didSet {
//            print(p)
//        }
//    }
//}
//
//// 通过分派到一定实例对象建力联系，关联的对象就能接收到赋值
//let aClass = AClass()
//let _ = pB.assign(to: \.p, on: aClass)
//
//
//// 2. API
//// 放入到一个 set 里面，任何异步信号流都可以在生命周期结束的时候统一销毁
//var publishers = Set<AnyCancellable>()
//
//// 2.1 Publisher
//// 阶段1： receiver subscription, 阶段2: 发出 request , 阶段3: 收到两个值，阶段4: 收到 finished
//struct S {
//    let p1: String
//    let p2: String
//}
//
//[S(p1: "1", p2: "one"), S(p1: "2", p2: "two")]
//    .publisher
////    .print()
//    .sink {print($0)}
//    .store(in: &publishers)
//
///// 2.1.1 Just - 一次性的
//let justPb = Just(S(p1: "3", p2: "three"))
//justPb
//    .print()
//    .sink{print($0)}
//    .store(in: &publishers)
//
///// 2.1.2 PassthroughSubject  - 持续性的
//enum CError: Error {
//    case aE, bE
//}
//
//let ps1 = PassthroughSubject<S, CError>()
//ps1
////    .print()
//    /// 参数两个， 一个是完成的时候的闭包， 一个是收到的时候的闭包
//    .sink { c in
//        print(c)
//    } receiveValue: { s in
//        print("received: \(s)")
//    }
//    .store(in: &publishers)
//
//ps1.send(S(p1: "4", p2: "four"))
//ps1.send(completion: .failure(CError.aE))  //到这里就终止了
//ps1.send(S(p1: "2", p2: "two"))
//ps1.send(completion: .finished)
//ps1.send(S(p1: "3", p2: "three"))
//
//let ps2 = PassthroughSubject<String, Never>()
//ps2.send("one")
//ps2.send("two")
//
//let sb1 = ps2
////            .print()
//            .sink{ print( "111" + $0) }
//ps2.send("three")
//
//let sb2 = ps2
////    .print()
//    .sink{ print("222" + $0) }
//
//ps2.send("four")
//sb1.store(in: &publishers)
//sb2.store(in: &publishers)
//ps2.send(completion: .finished)
//
//
///// 2.1.3 Empty  - 一次性的
//let ept = Empty<S, Never>()
//ept
//    .print()
//    .sink { c in
//        print(c)
//    } receiveValue: { s in
//        print("received: \(s)")
//    }
//    .store(in: &publishers)
//
//ept.replaceEmpty(with: S(p1: "1", p2: "one"))
//    .sink { c in
//        print(c)
//    } receiveValue: { s in
//        print("received: \(s)")
//    }
//    .store(in: &publishers)
//
//
///// 2.1.4 currentValueSubject  - 一次性的
///// 存储最后一次的值，当有订阅的时候立即发出
//print("=====================================")
//let cv = CurrentValueSubject<String, Never>("one")
//cv.send("two")
//cv.send("three")
//let scv1 = cv
//    .print()
//    .sink{ print($0) }
//cv.send("four")
//cv.send("five")
//
//let scv2 = cv
//    .print()
//    .sink{ print($0) }
//
//cv.send("six")
//
//
///// 2.2 operator
///// 2.2.1 removeDuplicates, 相邻的两个相等被认定为重复
//print("=====================================")
//let op1 = ["one", "two", "three", "three", "four"].publisher
//
//let sb10 = op1
//    .print("sb")
//    .removeDuplicates()
//    .sink{ print($0) }
//
//sb10.store(in: &publishers)
//
///// 2.2.2 flatMap 能打平降维
//print("=====================================")
//struct SS {
//    let p: AnyPublisher<String, Never>
//}
//
//let ss1 = SS(p: Just("one").eraseToAnyPublisher())
//let ss2 = SS(p: Just("two").eraseToAnyPublisher())
//let ss3 = SS(p: Just("three").eraseToAnyPublisher())
//
//let fpb = [ss1, ss2, ss3].publisher
//let sb11 = fpb
//    .print("fpb")
//    .flatMap{ $0.p }
//    .sink{ print($0) }
//sb11.store(in: &publishers)
//
///// 2.2.3 append 追加信号
///// 相当于在任何完成信号之前会追加要增加的部分
//print("=====================================")
//let pb10 = PassthroughSubject<String, Never>()
//let sb12 = pb10
//    .print()
//    .append("five", "six")
//    .sink{ print($0) }
//sb12.store(in: &publishers)
//
//pb10.send("seven")
//pb10.send("eight")
//pb10.send(completion: .finished)
//
//
///// 2.2.4 prepend
//print("=====================================")
///// 预先放到前面，不会受是否有 complete 信号的影响
//let pb11 = PassthroughSubject<String, Never>()
//let pb12 = ["nine", "ten"].publisher
//let sb13 = pb11
//    .print()
//    .prepend(pb12)
//    .prepend(["one", "two"])
//    .sink{ print($0) }
//
//sb13.store(in: &publishers)
//pb11.send("three")
//pb11.send("four")
//
///// 2.2.5 merge
//print("=====================================")
//let pm1 = PassthroughSubject<String, Never>()
//let pm2 = PassthroughSubject<String, Never>()
//
//let kk1 = pm1.merge(with: pm2)
//    .sink{ print($0) }
//pm1.send("one")
//pm1.send("two")
//pm2.send("1")
//pm2.send("2")
//kk1.store(in: &publishers)
//
///// 2.2.6 zip
//print("=====================================")
///// zip 合并数据为元组，只有当多个发布者都发布了数据后才会组合成一个数据给订阅者
//
//let pm4 = PassthroughSubject<String, Never>()
//let pm5 = PassthroughSubject<String, Never>()
//let pm6 = PassthroughSubject<String, Never>()
//
//let kk2 = pm4.zip(pm5, pm6)
//    .print()
//    .sink{ print($0) }
//
//pm4.send("One")
//pm4.send("two")
//
//pm5.send("1")
//pm5.send("2")
//
//pm6.send("-")
//pm6.send("=")
//
//kk2.store(in: &publishers)
//
///// 2.2.6 combineLatest
//print("=====================================")
///// 与上面不同的是会合并每个发布者最后的数据
//let pm7 = PassthroughSubject<String, Never>()
//let pm8 = PassthroughSubject<String, Never>()
//let pm9 = PassthroughSubject<String, Never>()
//
//let kk3 = pm7.combineLatest(pm8, pm9)
//    .print()
//    .sink{ print($0) }
//
//pm7.send("One")
//pm7.send("two")
//
//pm8.send("1")
//pm8.send("2")
//
//pm9.send("-")
//pm9.send("=")
//
//kk3.store(in: &publishers)
//
///// 2.2.6 scheduler
//print("=====================================")
//
//let ccs = ["one", "two", "three"].publisher
//    .print()
//    .subscribe(on: DispatchQueue.global())
//    .handleEvents(receiveOutput: { print($0)} )
//    .receive(on: DispatchQueue.main)
//    .sink{ print($0) }
//
//ccs.store(in: &publishers)
//
//
///// 3. 基础库使用场景
///// 3.1 URLSession
//print("URL =====================================")
//
//let req = URLRequest(url: URL(string: "https://www.baidu.com")!)
//let dpPublisher = URLSession.shared.dataTaskPublisher(for: req)
//dpPublisher.sink { c in
//    print(c)
//} receiveValue: { s in
//    print(s)
//}.store(in: &publishers)
//
//
///// 3.2 KVO
//print("KVO =====================================")
//
//final class KVOObject: NSObject {
//    @objc dynamic var first: Int = 0
//    @objc dynamic var second: Bool = false
//}
//
//let object = KVOObject()
//let op111 = object.publisher(for: \.first)
//    .sink { print($0)}
//
//op111.store(in: &publishers)
//
///// 3.3 Notification
//print("Noti =====================================")
//extension Notification.Name {
//    static let customNoti = Notification.Name("customNoti")
//}
//
//let notiPb = NotificationCenter.default.publisher(for: Notification.Name.customNoti)
//    .sink{ print($0) }
//notiPb.store(in: &publishers)
