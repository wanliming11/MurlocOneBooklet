//
//  IssueDetailView.swift
//  SharkOne
//
//  Created by Murloc Wan on 2022/2/19.
//

import Foundation
import SwiftUI


struct IssueDetailView: View {
    var title: String
    var number: Int

    var body: some View {
        VStack {
            Spacer()
            Text(title).font(.title)
            SharkWebView(urlStr: ShareOneConfig.githubBaseUrl  + ShareOneConfig.issueRepo + "\(number)")
            Spacer()
        }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
    }
}
