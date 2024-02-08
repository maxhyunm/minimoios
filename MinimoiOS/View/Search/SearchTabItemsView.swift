//
//  SearchTabItemsView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/08.
//

import SwiftUI

struct SearchTabItemsView: View {
    @Binding var tabType: SearchTab
    @ObservedObject var viewModel: SearchViewModel
    @State private var isTabChanged: Bool = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(SearchTab.allCases, id: \.self) { tab in
                let count = tab == .contents ? viewModel.contents.count : viewModel.users.count
                let countString = count > 100 ? "99+" : "\(count)"
                VStack {
                    Button {
                        tabType = tab
                        isTabChanged.toggle()
                    } label: {
                        Text("\(tab.title) (\(countString))")
                            .font(tabType == tab ? .headline : .callout)
                            .tint(tabType == tab ? .cyan : .black)
                            .frame(height: 35)
                            .frame(maxWidth: .infinity)
                    }
                    Rectangle()
                        .frame(height: 4)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(tabType == tab ? .cyan : .clear)
                        .animation(.easeInOut(duration: 0.4), value: isTabChanged)
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 15)
    }
}

struct SearchTabItemsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchTabItemsView(tabType: .constant(.contents), viewModel: PreviewStatics.searchViewModel)
    }
}
