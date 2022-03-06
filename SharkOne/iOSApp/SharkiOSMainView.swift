//
//  SharkiOSMainView.swift
//  SharkOne (iOS)
//
//  Created by Murloc Wan on 2022/3/6.
//

import SwiftUI

struct SharkiOSMainView: View {
    var body: some View {
        CardContainerView().ignoresSafeArea().padding(.zero)
    }
}

struct SharkiOSMainView_Previews: PreviewProvider {
    static var previews: some View {
        SharkiOSMainView()
    }
}
