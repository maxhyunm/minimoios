//
//  SearchFromUserView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/07.
//

import SwiftUI

struct SearchFromUserView: View {
    @Binding var fetchTrigger: Bool
    
    var body: some View {
        NavigationStack {
        Text("Search User's Minimo")
        }
    }
}

struct SearchFromUserView_Previews: PreviewProvider {
    static var previews: some View {
        SearchFromUserView(fetchTrigger: .constant(false))
    }
}
