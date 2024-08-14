//
//  UserTabView.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 2/14/23.
//

import SwiftUI

//MARK: - User Tab View
struct UserTabView: View {
    
    @AppStorage("current_user_uid"  ) var currentUserUID: String = "BXnHfiEaIQZiTcpvWs0bATdAdJo1"
    @AppStorage("user_name" ) var currentUserName: String = ""
    @AppStorage("user_Pic"  ) var currentUserProfilePicData: Data?
    @AppStorage("log_status") var logStatus: Bool = false
    
    @State var currentUser: UserModel? = nil
    @State var userName       = ""
    @State var currentUserBio = ""
//    @State var userProfilePicData: Data?
    
//    @Environment(\.dismiss) var dismiss
//    @State var showImagePicker = false
//    @State var photoItem: PhotosPickerItem?
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                
                // - Pick Your Profile Pic
                PickProfileImageButton()
                
                // - Name & Bio
                VStack(spacing: 15) {
                    Text("Your UID:     " + currentUserUID)
                    Text(currentUserName != "" ? currentUserName : "No Name")
                        .foregroundColor(currentUserName != "" ? .primary : .secondary)
                        .font(.title)
                    
                    Text("Future Feature")
                        .foregroundColor(.secondary)
                }

                // -
                UserBioAndButtons(bio: currentUserBio)
                
                Divider()
                
                // - User Tabs
                UserViewTabsBar()
                
                // - Posts Array
                LazyVStack {
                    ScrollView(showsIndicators: false) {
                        if currentUser != nil {
                            ForEach(0 ..< currentUser!.createdTIsIDs.count, id: \.self) { i in
                                
                                //                            DebateCard() //TODO
                                //                            VotingCell()///for Public Questions Tab!
                                ///
//                                UserPostedDebateCard()
                                ZStack(alignment: .topLeading) {
                                    Text("\(i + 1)")
                                        .font(.title)
                                    
                                    TiCard(ti: nil, tiID: currentUser!.createdTIsIDs[i])
                                }
                                
                            }
                        }
                    }
                }
                
                Spacer()
            }
        }
        .task {
            if currentUser == nil {
                do {
                    currentUser = try await UserManager.shared.getUser(userId: currentUserUID)
                } catch { print("❌ Error Couldn't get user for Library Tab❌") }
            }
        }
    }
}

struct UserTabView_Previews: PreviewProvider {
    static var previews: some View {
        UserTabView()
            .preferredColorScheme(.dark)

    }
}
