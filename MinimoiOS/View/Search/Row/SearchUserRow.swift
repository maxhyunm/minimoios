//
//  SearchUserRow.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/08.
//

import SwiftUI

struct SearchUserRow: View {
    @State private var removeAlertTrigger: Bool = false
    @State private var isPopUpVisible: Bool = false
    @State private var popUpImageURL: URL? = nil
    @Binding var targetUser: UserDTO
    let targetUserModel: UserModel
    
    // TODO: 없애기
    @State private var fetchTrigger: Bool = false
    
    var body: some View {
        HStack {
            VStack {
                MinimoUserImageView(userImage: $targetUser.image)
                Spacer()
            }
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    let profileViewModel = ProfileViewModel(
                        ownerId: targetUser.id,
                        firebaseManager: targetUserModel.firebaseManager
                    )
                    NavigationLink {
                        ProfileMainView(viewModel: profileViewModel,
                                        ownerModel: targetUserModel,
                                        fetchTrigger: $fetchTrigger)
                    } label: {
                        Text(targetUser.name)
                            .font(.headline)
                            .tint(.black)
                    }
                        
                    Spacer()
                }
                
                Text(targetUser.biography)
                    .lineLimit(nil)
                    .font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.trailing)
        }
        .padding()
        .background(Color(white: 0.9))
        .cornerRadius(10)
    }
}

struct SearchUserRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserRow(targetUser: .constant(PreviewStatics.user),
                      targetUserModel: PreviewStatics.userModel)
    }
}
