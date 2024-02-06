//
//  MinimoMainView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/31.
//

import SwiftUI

struct HomeMainView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @State private var isWriting: Bool = false
    @Binding var fetchTrigger: Bool
    @Binding var tabType: TabType
    
    var body: some View {
        let writeViewModel = WriteViewModel(userId: viewModel.userId, firebaseManager: viewModel.firebaseManager)
        ZStack(alignment: .bottomTrailing) {
            HomeList(fetchTrigger: $fetchTrigger, tabType: tabType)
                .environmentObject(viewModel)
            WriteButton(isWriting: $isWriting, fetchTrigger: $fetchTrigger, writeViewModel: writeViewModel)
        }
        .navigationTitle(tabType.title)
        .navigationBarTitleDisplayMode(.large)
    }
}

struct HomeMainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView(fetchTrigger: .constant(false),
                     tabType: .constant(.home))
            .environmentObject(PreviewStatics.homeViewModel)
    }
}
