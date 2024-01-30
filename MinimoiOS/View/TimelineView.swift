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
    @State private var isProfileVisible: Bool = false
    @State private var isWriting: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 5) {
                TopMenuView(isProfileVisible: $isProfileVisible)
                    .environmentObject(authModel)
                    .sheet(isPresented: $isProfileVisible) {
                        ProfileView(isProfileVisible: $isProfileVisible)
                            .environmentObject(profileViewModel)
                            .onDisappear {
                                minimoViewModel.fetchContents()
                            }
                    }
                MinimoList()
                    .onAppear {
                        minimoViewModel.fetchContents()
                    }
                    .environmentObject(minimoViewModel)
            }
            Button {
                isWriting.toggle()
            } label: {
                Image(systemName: "pencil")
                    .resizable()
            }
            .frame(width: 30, height: 30)
            .padding()
            .background(.cyan)
            .foregroundColor(.white)
            .clipShape(Circle())
            .offset(x: -30, y: -20)
            .sheet(isPresented: $isWriting) {
                WriteView(isWriting: $isWriting)
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
