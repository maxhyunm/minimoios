//
//  SearchUserRow.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/08.
//

import SwiftUI

struct SearchUserRow: View {
    @Binding var targetUser: UserDTO
    
    var body: some View {
        HStack(alignment: .center) {
            VStack {
                MinimoUserImageView(userImage: $targetUser.image)
            }
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(targetUser.name)
                        .font(.headline)
                        .tint(.black)
                    Spacer()
                }
                
                Text(targetUser.biography)
                    .lineLimit(nil)
                    .font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct SearchUserRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserRow(targetUser: .constant(PreviewStatics.user))
    }
}
