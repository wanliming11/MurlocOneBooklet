//
//  SlideBarLabel.swift
//  SharkOne
//
//  Created by Murloc Wan on 2022/2/9.
//

import SwiftUI

struct SlideBarLabel: View {
    var title: String
    var imageName: String

    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
            Text(title)
        }
    }
}


struct SlideBarLabel_Previews: PreviewProvider {
    static var previews: some View {
        SlideBarLabel(title: "", imageName: "SwiftSlideBar")
    }
}
