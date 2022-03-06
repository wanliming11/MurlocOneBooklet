//
// Created by Murloc Wan on 2022/3/6.
//

import Foundation
import AVKit
import SwiftUI

/// 播放器视图
struct PlayerView: View {
    var playerModel: MediaViewModel
    
    var body: some View {
        ZStack {
            if let player = playerModel.player {
                CustomVideoPlayer(player: player)
                GeometryReader { proxy -> Color in
                    let minY = proxy.frame(in: .global).minY
                    let size = proxy.size
                    
                    DispatchQueue.main.async {
                        if -minY < (size.height / 2) && minY < (size.height / 2) {
                            player.play()
                        }
                        else {
                            player.pause()
                        }
                    }
                    return Color.clear
                }
                
            }
            else {
                EmptyView()
            }
        }.onDisappear {
            playerModel.player?.pause()
        }
    }
}

/// View contains player, AVPlayerViewController 里面集成了基本的控制逻辑
struct CustomVideoPlayer: UIViewControllerRepresentable {
    var player: AVPlayer

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill

        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}



