//
//  LibraryContentProvider.swift
//  SharkOne (iOS)
//
//  Created by Murloc Wan on 2022/3/7.
//

import SwiftUI

struct LibraryContentProviderView: View {
    var body: some View {
        Color.blue
    }
}

struct LibraryContentProvider_Previews: PreviewProvider {
    static var previews: some View {
        LibraryContentProviderView()
    }
}



struct MiMiXcodeViewLibrary: LibraryContentProvider {
    
    var views: [LibraryItem] {
        [LibraryItem(LibraryContentProviderView(), visible: true, title: "Mimi view", category: .control, matchingSignature: "Mimi view")]
    }
    
}
