//
//  UserFSC.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 4/9/23.
//

import SwiftUI

struct UserFSC: View {
    
    let user: UserModel?
    
    @Binding var showFSC: Bool
    
    @State private var currentUser: UserModel? = nil
    @AppStorage("current_user_uid") var currentUserUID: String = "BXnHfiEaIQZiTcpvWs0bATdAdJo1"

    var body: some View {
        
        ScrollView(showsIndicators: true) {
            
            VStack(spacing: 0) {
                
                //Close Button
                HStack() { Spacer(); CloseButton(showFSC: $showFSC ).padding(.all) }
                
                //MARK: Image
                if user?.profileImageURLString != nil {
                    ZStack {
                        Circle()
                            .stroke()
                            .foregroundColor(.secondary)
                            .frame(width: width * 0.6, height: width * 0.6)
                        
                        AsyncImage(url: URL(string: user!.profileImageURLString!), scale: 1) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: width * 0.6, height: width * 0.6)
                                .clipShape(Circle())
                            
                            
                        } placeholder: {
                            ProgressView()
                        }
                    }
                } else {
                    PersonIcon()
                        .foregroundColor(user != nil ? .primary : .secondary)
                }
                
                if user != nil {
                    VStack(spacing: 15) {
                        
                        Text(user!.displayName != "" ? user!.displayName : "No Name")
                            .foregroundColor(user!.displayName != "" ? .primary : .secondary)
                            .font(.title)
                        
                        
                        ( Text( UserFunctions().userLabel(user: currentUser) + " ") + Text(Image(systemName: UserFunctions().userLabelIcon(user: currentUser)) ) )
                            .foregroundStyle(.gray)
                            .font(.system(size: width * 0.05, weight: .regular))
                            .padding(.trailing, width * 0.01)
                        
                        
                    }.padding(.vertical)
                } else {
                    Text("User doesn't Exist")
                        .foregroundColor(.secondary)
                        .padding(.vertical)
                }
                
                Divider()
                
                //MARK: User Bio & Buttons
                HStack(spacing: 0) {
                    
                    DescriptionSV(descriptionTitle: "User's Bio", text: user?.bio ?? "")
                    
                    VStack(spacing: 0) {
                        
                        if user != nil , currentUser != nil {
                            //Follow
                            FollowUserButton(user: user!)
                                .padding(.bottom)
                            
                            SaveUserButton(user: user!, currentUser: currentUser!)
                            
                            //Expand
                            //FutureFeatureButton()
                            
                        } else { ProgressView() }
                    }
                }
                .frame(width: width, height: width * 0.45)
                .preferredColorScheme(.dark)
                
                //MARK: User Tabs
                UserViewTabsBar()
                
                
                // - Posts Array
                ScrollView(showsIndicators: false) {
                    if currentUser != nil {
                        
                        ForEach(0 ..< currentUser!.createdTIsIDs.count, id: \.self) { i in
                            
                            ZStack(alignment: .topLeading) {
                                Text("\(i + 1)")
                                    .font(.title)
                                
                                TiCard(ti: nil, tiID: currentUser!.createdTIsIDs[i])
                            }
                        }
                    }
                    
                    Rectangle()
                        .frame(height: 50)
                        .foregroundStyle(.clear)
                    
                }
                
                //room for the bottom of sheet
                Rectangle()
                    .fill(.black)
                    .frame(height: width * 0.15)
            }
        }
        .background(Color.black)
        .preferredColorScheme(.dark)
        .onAppear{ Task { try await fetchCurrentUser() } }
    }
    
    //MARK: Fetch
    func fetchCurrentUser() async throws {
//#if DEBUG
//        //        currentUser = TestingModels().user1
//        currentUser = TestingModels().userArray.randomElement()
//        
//#else
        do {
            currentUser = try await UserManager.shared.getUser(userId: currentUserUID)
        } catch {
            print("❌⬇️Error: Couldn't fetch current User \n❌[UserFSC]")
            currentUser = nil
        }
//#endif
    }
}


struct UserFSC_Previews: PreviewProvider {
    static var previews: some View {
        //        SaveUserButton(user: TestingModels().user1, currentUser: TestingModels().user1 )
        
        UserFSC(user: TestingModels().user1, showFSC: .constant(true))
        UserButton(
            userUID: "wow"
            //            imageURL: TestingImagesVideos().imageURLStringDesignnCode
        )
        //        UserFSC(user: <#UserModel?#>)
    }
}

//MARK: - Save User Button
//struct SaveUserButton: View {
//
//    let user: UserModel
//    @State var currentUser: UserModel
//    //    @AppStorage("current_user_uid") var currentUserId: String = ""
//    @State private var showSavedUsersSheet = false
//
//    var body: some View {
//
//        Button {
////            if currentUser.id != nil {
//                Task {
//                    try await updateSavedUsers()
//                }
////            }
//        } label: {
//            ZStack {
//                if userSaved {
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(lineWidth: 1)
//                        .fill(Color.secondary)
//                        .frame(width: width * 0.14, height: width * 0.12)
//
//                    Text("User Saved")
//                        .font(.callout)
//                        .foregroundColor(.secondary)
//
//                } else {
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(lineWidth: 1)
//                        .fill(Color.secondary)
//                        .frame(width: width * 0.14, height: width * 0.14)
//
//                    Text("Save User")
//                        .foregroundColor(.primary)
//                }
//            }
//            .frame(width: width * 0.15, height: width * 0.15)
//        }
//        .sheet(isPresented: $showSavedUsersSheet) {
//            VStack(spacing: 0) {
//                Text("User Saved")
//                    .font(.title)
//                    .frame(width: width)
//
//                Text("You can use saved users When Adding admins to THEAALii Interactions you created")
//                    .padding(.vertical, width * 0.1)
//
//                Spacer()
//            }
//            .background(Color.black)
//            .presentationDetents([.fraction(0.25)])
//            .preferredColorScheme(.dark)
//        }
//        .preferredColorScheme(.dark)
//    }
//
//    //F
//    var userSaved: Bool {
//        return currentUser.savedUsersUIDs.contains(user.userUID)
//    }
//
//    func updateSavedUsers() async throws {
////        if let userId = user.id, let currentUserId = currentUser.id {
//            Task {
//                print("🍌 🫒 saved user enter 🫒 🍌")
//                if userSaved {
//                    try await UserManager.shared.updateSavedUsers(currentUserId: currentUser.userUID ,userIdForArray: user.userUID,addOrRemove: (userSaved ? .remove : .remove))
//                    print("🍌 🫒 saved user remove! 🫒 🍌")
//
//                    currentUser.savedUsersUIDs.remove(object: user.userUID)
//                } else {
//                    try await UserManager.shared.updateSavedUsers(currentUserId: currentUser.userUID ,userIdForArray: user.userUID ,addOrRemove: (userSaved ? .remove : .add))
//                    print("🍌 🫒 saved user add! 🫒 🍌")
//
//                    currentUser.savedUsersUIDs.append(user.userUID)
//                    showSavedUsersSheet.toggle()
//                }
//            }
////        }
//    }
//}

