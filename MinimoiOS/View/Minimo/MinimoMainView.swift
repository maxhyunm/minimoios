//
//  MinimoMainView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/31.
//

import SwiftUI

struct MinimoMainView: View {
    @EnvironmentObject var minimoViewModel: MinimoViewModel
    @State private var isWriting: Bool = false
    @State private var isFetchNeeded: Bool = true
    @Binding var tabType: TabType
    
    var body: some View {
        let writeViewModel = WriteViewModel(user: minimoViewModel.user, firebaseManager: minimoViewModel.firebaseManager)
        ZStack(alignment: .bottomTrailing) {
            MinimoList(isFetchNeeded: $isFetchNeeded, tabType: tabType)
                .onAppear {
                    minimoViewModel.fetchContents(for: tabType)
                }
                .environmentObject(minimoViewModel)
            
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
                WriteView(isWriting: $isWriting,
                          isFetchNeeded: $isFetchNeeded,
                          writeViewModel: writeViewModel)
            }
        }
        .navigationTitle(tabType.title)
        .navigationBarTitleDisplayMode(.large)
        
    }
}

struct MinimoMainView_Previews: PreviewProvider {
    static var previews: some View {
        MinimoMainView(tabType: .constant(.home))
            .environmentObject(MinimoViewModel(
                    user: UserDTO(
                        id: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
                        name: "테스트"
                    ),
                    firebaseManager: FirebaseManager()))
    }
}
