//
//  NewUserButton.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 4/13/24.
//

import SwiftUI

//struct NewUserButton: View {
//    
//    @StateObject var userVM = UserViewModel()
//    @State var user: UserModel?
//    let userUID: String?
//    var imageURL: String?
//    
//    @State private var showUserFSC = false
//    
//    var body: some View {
//        
//        Button {
//            showUserFSC.toggle()
//        } label: {
//            ZStack {
//                
//                Circle()
//                    .frame(width: width * 0.12)
//                    .foregroundColor(.black)
//                
//                if userVM.user != nil {
//                    if userVM.user?.profileImageURLString != nil {
//                        
//                        AsyncImage(url: URL(string: userVM.user?.profileImageURLString ?? ""), scale: 0.5) { image in
//                            image
//                                .resizable()
//                                .clipShape(Circle())
//                                .scaledToFit()
//                                .frame(width: width * 0.15)
//                            
//                        } placeholder: {
//                            ProgressView()
//                        }
//                    } else { PersonTITIconSV(scale: 1.3) }
//                } else {
//                    VStack {
//                        Text("No")
//                            .font(.system(size: width * 0.03, weight: .light))
//                        Text("User")
//                            .font(.system(size: width * 0.03, weight: .light))
//                    }
//                    .background(.black)
//                    .foregroundColor(.secondary)
//                }
//                
//                
//                Circle()
//                    .strokeBorder(lineWidth: 0.5)
//                    .frame(width: width * 0.12)
//                    .foregroundColor(.secondary)
//                
//            }
//        }
//        .fullScreenCover(isPresented: $showUserFSC) {
//            
//            VStack(spacing: 0) {
//                FSCHeaderSV(showFSC: $showUserFSC, text: "User")
//                
//
//            }
//        }
//    }
//    
//    //MARK: - Functions
////    func loadUser(userUID: String) async throws {
////            user = try await UserManager.shared.getUser(userId: userUID)
////    }
//}

//#Preview {
//    NewUserButton( userUID: "")
//}
