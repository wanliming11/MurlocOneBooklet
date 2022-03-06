import Foundation
import Combine
import PlaygroundSupport
import SwiftUI

/// 1. UIHostingController
/// 2. SwiftLayout 里面的 Geometry Reader， View Preferences， Anchor Preferences
/// 3. UIKit 和 SwiftUI 对应内容：
//SwiftUI    UIKit
//Text 和 Label    UILabel
//TextField    UITextField
//TextEditor    UITextView
//Button 和 Link    UIButton
//Image    UIImageView
//NavigationView    UINavigationController 和 UISplitViewController
//ToolbarItem    UINavigationItem
//ScrollView    UIScrollView
//List    UITableView
//LazyVGrid 和 LazyHGrid    UICollectionView
//HStack 和 LazyHStack    UIStack
//VStack 和 LazyVStack    UIStack
//TabView    UITabBarController 和 UIPageViewController
//Toggle    UISwitch
//Slider    UISlider
//Stepper    UIStepper
//ProgressView    UIProgressView 和 UIActivityIndicatorView
//Picker    UISegmentedControl
//DatePicker    UIDatePicker
//Alert    UIAlertController
//ActionSheet    UIAlertController
//Map    MapKit

/// 4. Text
struct PractiseTextView: View {
    let detailStr = "今天天气很好，要努力工作哦，今天天气很好，要努力工作哦，今天天气很好，要努力工作哦，今天天气很好，要努力工作哦，今天天气很好，要努力工作哦，"
    
    
    var body: some View {
        /// 内容超出屏幕区域后可滚动
        ScrollView {
            Group {
                Text("大标题").font(.largeTitle)
                Text("First:").tracking(30) //字间距
            }
            
            
            
        }
        
        
        
    }
    
    
    
}













//let curView = LiveView()

//PlaygroundPage.current.setLiveView(curView)






