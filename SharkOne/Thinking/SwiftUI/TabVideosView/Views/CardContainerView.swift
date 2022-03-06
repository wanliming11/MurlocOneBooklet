//
//  CardContainerView.swift
//  SharkOne (iOS)
//
//  Created by Murloc Wan on 2022/3/6.
//  卡片容器视图，拿一个直播间距离，就是上，中，下 三个卡片

import SwiftUI

struct CardContainerView: View {
    @State var curPage = ""
    let mediaInfos = MediaInfosFactory.build()
    var videoPlayerInfos = CardContainerViewModel().infos

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            TabView(selection: $curPage) {
                ForEach(videoPlayerInfos) { media in
                    VStack {
                        Text(media.info.title)
                        Spacer()
                        PlayerView(playerModel: media)
                    }
                    .frame(width: size.width)
                    .padding()
                    .rotationEffect(.init(degrees: -90))
                }
            }
            // Rotating
            .rotationEffect(.init(degrees: 90))   // 和上面的 -90刚好抵消，这样上面的视图可以正常布局，也可以支持上下滚动
            .frame(width: size.height)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(width: size.width)
        }
    }
}

struct CardContainerView_Previews: PreviewProvider {
    static var previews: some View {
        CardContainerView()
    }
}
