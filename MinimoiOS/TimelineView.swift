//
//  TimelineView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/29.
//

import SwiftUI

struct TimelineView: View {
    @EnvironmentObject var authModel: AuthModel
    @EnvironmentObject var minimoViewModel: MinimoViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @State var isProfileVisible: Bool = false
    
    var body: some View {
        VStack(spacing: 5) {
            TopMenuView(isProfileVisible: $isProfileVisible)
                .environmentObject(authModel)
            ScrollView {
                WriteView()
                MinimoList()
                    .onAppear {
                        minimoViewModel.fetchContents()
                    }
                    .environmentObject(minimoViewModel)
            }
            .sheet(isPresented: $isProfileVisible) {
                ProfileView(isProfileVisible: $isProfileVisible)
                    .environmentObject(profileViewModel)
                    .onDisappear {
                        minimoViewModel.fetchContents()
                    }
            }
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
            .environmentObject(AuthModel(firebaseManager: FirebaseManager()))
            .environmentObject(
                MinimoViewModel(
                    userId: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
                    firebaseManager: FirebaseManager()))
    }
}
