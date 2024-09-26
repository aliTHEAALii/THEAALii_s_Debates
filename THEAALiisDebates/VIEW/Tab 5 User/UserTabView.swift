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
    
    @State private var userName: String = ""
    @State var currentUser: UserModel? = nil
    @State private var imageUrlString: String? = nil
    
//    @Environment(\.dismiss) var dismiss
//    @State var showImagePicker = false
//    @State var photoItem: PhotosPickerItem?
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                
                // - Pick Your Profile Pic
//                PickProfileImageButton()
//                .padding()

//                if let currentUserProfilePicData, let image = UIImage(data: currentUserProfilePicData) {
//                    
//                    ImageView()
//                    ZStack {
//                        
//                        Image(uiImage: image)
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: width * 0.6, height: width * 0.6)
//                            .clipShape(Circle())
//                        
//                        Circle()
//                            .stroke()
//                            .foregroundColor(.white)
//                            .frame(width: width * 0.6, height: width * 0.6)
//                    }
//                    
//                } else { PersonIcon() }
                ZStack {
                    if imageUrlString != nil {
                        
                        AsyncImage(url: URL(string: imageUrlString!)) { image in
                            
                            image.resizable()
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
//                .background(Color.gray.opacity(0.15))
//                .frame(width: width * scale, height: width * 0.5625 * scale)
                
                
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
                    UserBioAndButtons(currentUser: $currentUser, userName: $userName, bio: currentUser!.bio, imageUrlString: $imageUrlString)
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
            do {
                currentUser = try await UserManager.shared.getUser(userId: currentUserUID)
                userName = currentUser?.displayName ?? "No Name"
                imageUrlString = currentUser?.profileImageURLString
            } catch {
                print("❌ Error Couldn't get user for Library Tab❌")
                // Handle error gracefully, e.g., show an error message to the user
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
