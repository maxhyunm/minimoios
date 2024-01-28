//
//  TimelineView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/27.
//

import SwiftUI

struct TimelineList: View {
    @EnvironmentObject var authModel: AuthModel
    @EnvironmentObject var timelineViewModel: TimelineViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    authModel.handleLogout()
                } label: {
                    if let latestOAuthType = UserDefaults.standard.object(forKey: "latestOAuthType") as? String {
                        Text("\(latestOAuthType) LogOut")
                    } else {
                        Text("LogOut")
                    }
                }
            }
            
            Divider()
            
            ScrollView {
                ForEach(timelineViewModel.contents, id: \.self) { content in
                    TimelineRow(name: content.name, date: "\(content.createdAt)", content: content.content)
                }
            }
        }
        .padding()
        Spacer()
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineList()
            .environmentObject(AuthModel())
            .environmentObject(TimelineViewModel(user: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!))
    }
}
