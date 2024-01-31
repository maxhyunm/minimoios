//
//  MinimoMainView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/31.
//

import SwiftUI

struct MinimoMainView: View {
    @EnvironmentObject var minimoViewModel: MinimoViewModel
    @Binding var isPopUpVisible: Bool
    @Binding var popUpImageURL: URL?
    @State private var isWriting: Bool = false
    var tabType: TabType
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            MinimoList(isPopUpVisible: $isPopUpVisible, popUpImageURL: $popUpImageURL)
                .onAppear {
                    minimoViewModel.fetchContents()
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
                WriteView(isWriting: $isWriting)
                    .onDisappear {
                        minimoViewModel.fetchContents()
                    }
            }
        }
        .navigationTitle(tabType.title)
        .navigationBarTitleDisplayMode(.large)
        
    }
}

struct MinimoMainView_Previews: PreviewProvider {
    static var previews: some View {
        MinimoMainView(isPopUpVisible: .constant(false), popUpImageURL: .constant(nil), tabType: .home)
            .environmentObject(MinimoViewModel(
                userId: UUID(uuidString: "c8ad784e-a52a-4914-9aec-e115a2143b87")!,
                firebaseManager: FirebaseManager()))
    }
}
