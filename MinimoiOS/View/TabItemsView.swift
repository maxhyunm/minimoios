//
//  TabItemsView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/07.
//

import SwiftUI

struct TabItemsView: View {
    @EnvironmentObject var tabType: Tab

    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            ForEach(Tab.TabType.allCases, id: \.self) { tab in
                Button {
                    tabType.current = tab
                } label: {
                    Image(systemName: tab.labelName)
                        .tint(tabType.current == tab ? .cyan : .black)
                }
                Spacer()
            }
        }
    }
}

struct TabItemsView_Previews: PreviewProvider {
    static var previews: some View {
        TabItemsView()
    }
}
