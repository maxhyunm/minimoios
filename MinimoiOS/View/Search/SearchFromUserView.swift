//
//  SearchFromUserView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/08.
//

import SwiftUI

struct SearchFromUserView: View {
    @Binding var fetchTrigger: Bool
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SearchFromUserView_Previews: PreviewProvider {
    static var previews: some View {
        SearchFromUserView(fetchTrigger: .constant(false))
    }
}
