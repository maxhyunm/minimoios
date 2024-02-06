//
//  TabItemsView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/07.
//

import SwiftUI

struct TabItemsView: View {
    @Binding var tabType: TabType

    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            ForEach(TabType.allCases, id: \.self) { tab in
                Button {
                    tabType = tab
                } label: {
                    Image(systemName: tab.labelName)
                        .tint(tabType == tab ? .cyan : .black)
                }
                Spacer()
            }
        }
    }
}

struct TabItemsView_Previews: PreviewProvider {
    static var previews: some View {
        TabItemsView(tabType: .constant(.home))
    }
}
