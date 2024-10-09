//
//  UserTabView.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 2/14/23.
//

import SwiftUI

//MARK: - User Tab View
struct UserTabView: View {
    
    @AppStorage("current_user_uid") var currentUserUID: String = "BXnHfiEaIQZiTcpvWs0bATdAdJo1"
    @AppStorage("user_name" ) var currentUserName: String = ""
    @AppStorage("user_Pic"  ) var currentUserProfilePicData: Data?
    @AppStorage("log_status") var logStatus: Bool = false
    
    @Environment(CurrentUser.self) var currentUserO
    
    @State private var userName: String = ""
    @State var bio: String = ""

    @State var currentUser: UserModel? = nil
    @State private var imageUrlString: String? = nil
    
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                

                // - Your Profile Pic
                ZStack {
                    if currentUserO.profilePicData != nil {
                        Image(uiImage: UIImage(data: currentUserO.profilePicData!)!)
                            .resizable()
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: width * 0.6, height: width * 0.6)
                            .clipShape(Circle())
                        
                    } else if imageUrlString != nil {
                        AsyncImage(url: URL(string: imageUrlString!)) { image in
                            
                            image
                                .resizable()
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: width * 0.6, height: width * 0.6)
                                .clipShape(Circle())
                            
                            
                        } placeholder: { ProgressView() }
                    } else { PersonIcon() }
                    
                    Circle()
                        .stroke(lineWidth: 1)
                        .foregroundColor(.white)
                        .frame(width: width * 0.6, height: width * 0.6)
                }
                .padding()
                
                
                // - Name & Bio
                VStack(spacing: 15) {
                    
//                    Text("Your UID:     " + currentUserUID)
                    
                    //display Name && Label
                    if currentUser != nil {
                        Text(userName)
                            .foregroundColor(userName != "" ? .primary : .secondary)
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
                    UserBioAndButtons(currentUser: $currentUser, userName: $userName, bio: $bio, imageUrlString: $imageUrlString)
                }
                
                Divider()
                
                // - User Tabs
                UserViewTabsBar()
                
                // - Posts Array
                ScrollView(showsIndicators: false) {
                    if currentUser != nil {
                        
                        ForEach(0 ..< currentUser!.createdTIsIDs.count, id: \.self) { i in
                            
                            ZStack(alignment: .topLeading) {
                                
                                TiCard(ti: nil, tiID: currentUser!.createdTIsIDs[i])
                                
                                Text("\(i + 1)")
                                    .font(.title)
                            }
                        }
                    }
                    
                    //Bottom Space for scrollView()
                    Rectangle()
                        .frame(height: 50)
                        .foregroundStyle(.clear)
                    
                }
                
                Spacer()
            }
        }
        .onAppear {
            currentUser = currentUserO.userModel()
            
            userName = currentUser?.displayName ?? "No Name"
            bio = currentUser?.bio ?? "No Bio"
            imageUrlString = currentUserO.profileImageURLString
        }
        .onChange(of: currentUserO.displayName) { oldValue, newValue in
            currentUser = currentUserO.userModel()
            
            userName = currentUser?.displayName ?? "No Name"
            bio = currentUser?.bio ?? "No Bio"
            imageUrlString = currentUserO.profileImageURLString
        }
        .onChange(of: currentUser) { _, _ in
            currentUserO.setCurrentUser(fromUserModel: currentUser)
        }
        .onChange(of: userName) { _, _ in
            currentUserO.displayName = userName
        }
        .onChange(of: bio) { _, _ in
            currentUserO.bio = bio
        }
        .onChange(of: imageUrlString) { _, _ in
            currentUserO.profileImageURLString = imageUrlString
        }
    }
}

struct UserTabView_Previews: PreviewProvider {
    static var previews: some View {
//        UserTabView()
//            .environment(CurrentUser().self)
//            .preferredColorScheme(.dark)
        
        TabsBar(selectedIndex: 4)
            .environment(CurrentUser().self)

    }
}
