//
//  TabItemsView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/07.
//

import SwiftUI

struct TabItemsView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var tabType: Tab

    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            ForEach(Tab.TabType.allCases, id: \.self) { tab in
                Button {
                    tabType.current = tab
                } label: {
                    Image(systemName: tab.labelName)
                        .tint(tabType.current == tab ? Colors.highlight(for: colorScheme) : Colors.basic(for: colorScheme))
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
