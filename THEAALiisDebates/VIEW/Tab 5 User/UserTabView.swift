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
                    
                    //display Name && Label
                    if currentUser != nil {
                        Text(currentUser?.displayName ?? "No Name")
                            .foregroundColor(currentUser!.displayName != "" ? .primary : .secondary)
                            .font(.title)
                        
                        //label
                        ( Text( UserFunctions().userLabel(user: currentUser) + " ") + Text(Image(systemName: UserFunctions().userLabelIcon(user: currentUser)) ) )
                            .foregroundStyle(.gray)
                            .font(.system(size: width * 0.05, weight: .regular))
                            .padding(.trailing, width * 0.01)
                    }
                    
                    
                }
                
                // -Bio & Buttons
                if currentUser != nil {
                    UserBioAndButtons(currentUser: $currentUser, bio: currentUser!.bio)
                }
                
                Divider()
                
                // - User Tabs
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
