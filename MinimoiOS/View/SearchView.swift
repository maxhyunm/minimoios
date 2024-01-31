//
//  SearchView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/01/31.
//

import SwiftUI

struct SearchView: View {
    var tabType: TabType
    
    var body: some View {
        Text("Empty")
            .navigationTitle(tabType.title)
            .navigationBarTitleDisplayMode(.large)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(tabType: .search)
    }
}
