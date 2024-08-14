//
//  UserButtonSV.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 4/8/23.
//

import SwiftUI

struct UserButton_Previews: PreviewProvider {
    static var previews: some View {
//        UserButton(
//            userUID: "me"
//            //            imageURL: TestingComponents().imageURLStringDesignnCode
//        )
        
        TiCard(ti: TestingModels().testTI0)

//        CreateTI(showFSC: .constant(true), selectedTabIndex: .constant(2))
    }
}


//MARK: - User Button 2
struct UserButton: View {
    
    @State var user: UserModel? = nil
    var userUID: String? = nil
    
    var horizontalName = false
    var scale: CGFloat = 1
    var horizontalWidth: CGFloat = width * 0.4
    
    @State private var showUserSheet = false
    @State private var isLoading = false
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            Button {
                showUserSheet.toggle()
            } label: {
                
                HStack(spacing: 0) {
                    
                    //MARK: - Text & Icon
                    if horizontalName {
                        VStack(alignment: .trailing, spacing: 0) {
                            
                            //User Name
//                            Text(computedUser?.displayName ?? "No User")
                            Text(user?.displayName ?? "No User")
                                .font(.system(size: width * 0.045 * scale, weight: .regular))
                                .foregroundStyle(.white)
                                .padding(.trailing, width * 0.01 * scale)
//                                .frame(width: width * 0.4 * scale, height: width * 0.07 * scale, alignment: .trailing)
                            
                            Divider()
//                                .frame(width: width * 0.2, alignment: .trailing)

                            
                            
                            //User Label
                            (Text(userLabel + " ") + Text(Image(systemName: userLabelIcon)))
                                .foregroundStyle(.gray)
                                .font(.system(size: width * 0.03 * scale, weight: .regular))
                                .padding(.trailing, width * 0.01 * scale)
//                                .frame(width: width * 0.4 * scale, height: width * 0.04 * scale, alignment: .trailing)
                        }
                        .frame(width: horizontalWidth, height: width * 0.12 * scale, alignment: .topTrailing)
//                        .frame(alignment: .topTrailing)
                    }
                    
                    //MARK: - profile Pic Circle
                    ZStack {
                        
                        //Black Background
                        Circle()
//                            .frame(width: width * 0.12 * scale)
                            .foregroundColor(.black)
                        
                        if let user {
                            if let profileImageURLString = user.profileImageURLString {
                                AsyncImage(url: URL(string: profileImageURLString), scale: 0.5 * scale) { image in
                                    image
                                        .resizable()
                                        .clipShape(Circle())
                                        .scaledToFit()
//                                        .frame(width: width * 0.12 * scale)
                                    
                                } placeholder: {
                                    ProgressView()
                                }
                                
                                //User with Nil image
                            } else { }//PersonTITIconSV(scale: 1.3 * scale) }
                            
                            //User Doesn't exist
                        } else {
                            VStack {
                                Text("No")
                                    .font(.system(size: width * 0.03 * scale, weight: .light))
                                Text("User")
                                    .font(.system(size: width * 0.03 * scale, weight: .light))
                            }
                            .background(.black)
                            .foregroundColor(.secondary)
                        }
                        
                        //Border
                        Circle()
                            .strokeBorder(lineWidth: 0.5 * scale)
//                            .frame(width: width * 0.12 * scale)
                            .foregroundColor(.primary)
                        
                    }
                    .frame(width: width * 0.12 * scale)

                }
            }
            .onAppear{ Task { await loadUser() } }
            .preferredColorScheme(.dark)
            .fullScreenCover(isPresented: $showUserSheet) {
                
                UserFSC(user: user, showFSC: $showUserSheet)
            }
        }
    }
    
    //MARK: - Functions
    func loadUser() async {
        if user != nil { return }
        guard let userUID else { return }
        isLoading = true

            /*
             if getting user is [successful]   user = UserModel(...)
             if getting user is [UNsuccessful] user = nil
             */
            Task {
                do {

                    user = try await UserManager.shared.getUser(userId: userUID)
                    isLoading = false
                } catch {
                    print("🆘🔴🟠 Couln't get user 🟧🆘")
                    print(error.localizedDescription)
                    isLoading = false
                }
            }
    }
    
    //MARK: - Computed Properties
    var computedUser: UserModel? {
        if user != nil { return user }
        if userUID == nil { return nil }
//        guard userUID != nil else { return nil }
        
        //3. user    && id          -> XXXX
        //4. user    && no id       -> XXXX
        
        //1. no user && we have UID -> Lookup in database
        //2. no user && no UID      -> return nil
        
        if userUID != nil {
//#if DEBUG
//            return TestingModels().userArray.randomElement()
//
//#else
//            Task {
//                do {
//                    return try await UserManager.shared.getUser(userId: userUID ?? "")
//                } catch {
//                    print("🆘🔴🟠 Couln't get user 🟧🆘")
//                    print(error.localizedDescription)
//                    return nil
//                }
//            }
//#endif
        }
        return nil
    }
    
    //MARK: - Label
    var userLabel: String {
        guard let user else { return "No User" }
        
        if !user.createdTIsIDs.isEmpty {
            return "Creator"
        } else {
            return "Observer"
        }
    }
    var userLabelIcon: String {
        guard let user else {  return "xmark" }
        
        if !user.createdTIsIDs.isEmpty {
            
            return "plus.square.fill"
            
        } else {
            
            return "eye"
        }
    }
}







///         func loadUser() {
////        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
////        if userID != nil {
//        do {
//            self.user = try await UserManager.shared.getUser(userId: userUID)
//        } catch {
//            print("🏀🟠🏀 Couln't get user")
//            print(error.localizedDescription)
////            throw error.localizedDescription
//        }
////        }
///    }
