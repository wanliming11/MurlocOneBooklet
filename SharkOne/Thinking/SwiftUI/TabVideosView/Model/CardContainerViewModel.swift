//
//  CardContainerViewModel.swift
//  SharkOne (iOS)
//
//  Created by Murloc Wan on 2022/3/6.
//

import Foundation
import SwiftUI
import AVFoundation

struct MediaViewModel: Identifiable {
    var id = UUID()
    var player: AVPlayer?
    var info: MediaInfo
}

struct CardContainerViewModel {
    var infos: [MediaViewModel] = MediaInfosFactory.build().map { item -> MediaViewModel in
        let url = Bundle.main.path(forResource: item.videoUrl, ofType: "mp4")
        if let url = url {
            let player = AVPlayer(url: URL(fileURLWithPath: url))
            return MediaViewModel(player: player, info: item)
        }
        
        return MediaViewModel(player: nil, info: item)
    }
}
