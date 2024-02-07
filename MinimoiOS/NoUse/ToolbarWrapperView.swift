//
//  NavigationWrapperView.swift
//  MinimoiOS
//
//  Created by Min Hyun on 2024/02/06.
//

//import SwiftUI
//
//struct ToolbarWrapperView<Content: View>: View {
//    @EnvironmentObject var userModel: UserModel
//    @State private var isEditProfileVisible: Bool = false
//    @Binding var fetchTrigger: Bool
//    @Binding var logOutTrigger: Bool
//    let tabType: TabType
//    var innerView: Content
//    
//    var body: some View {
//            innerView
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Menu {
//                            Button {
//                                isEditProfileVisible = true
//                            } label: {
//                                Text("정보 수정")
//                                    .font(.body)
//                            }
//                            
//                            Button {
//                                logOutTrigger.toggle()
//                            } label: {
//                                Text("로그아웃")
//                                    .font(.headline)
//                            }
//                            
//                        } label: {
//                            Image(systemName: "person.circle")
//                        }
//                        .foregroundColor(.cyan)
//                    }
//                }
//                .tint(.cyan)
//                .toolbarBackground(tabType.navigationBarBackground, for: .navigationBar)
//            //            .navigationBarHidden(tabType == .profile)
//            //            .navigationBarHidden(!isScrollOnTop)
//            .sheet(isPresented: $isEditProfileVisible) {
//                EditInformationView(name: $userModel.user.name,
//                                    isProfileVisible: $isEditProfileVisible,
//                                    fetchTrigger: $fetchTrigger)
//                .environmentObject(userModel)
//            }
//    }
//}
//
//struct NavigationWrapperView_Previews: PreviewProvider {
//    static var previews: some View {
//        ToolbarWrapperView(fetchTrigger: .constant(false),
//                           logOutTrigger: .constant(false),
//                           tabType: .home,
//                           innerView: SearchView(path: .constant([]))
//        )
//    }
//}
