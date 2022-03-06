//
// Created by Murloc Wan on 2022/3/6.
//

import Foundation

struct MediaInfo: Identifiable {
    var id: Int
    var title: String
    var videoUrl: String
    var bg: String
}

struct MediaInfosFactory {
    static func build() -> [MediaInfo] {
        let media1 = MediaInfo(id: 1, title: "杨幂1", videoUrl: "mimi1", bg: "")
        let meida2 = MediaInfo(id: 2, title: "杨幂2", videoUrl: "mimi2", bg: "")
        let meida3 = MediaInfo(id: 3, title: "杨幂3", videoUrl: "mimi3", bg: "")
        return [media1, meida2, meida3]
    }
}





