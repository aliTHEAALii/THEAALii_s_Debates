//
//  CurrentUser.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 10/7/24.
//

import Foundation
import Observation

//@Observable class CurrentUser {
//class CurrentUser: ObservableObject {
//
//    @Published var currentUserUID: String? = ""
//    @Published var displayName: String     = "No Display Name"
//    @Published var bio        : String     = "No Bio"
//    @Published var profileImageURLString: String? = nil
//    @Published var userLabel: String = "Observer"
//    @Published var followingUIDs:     [String] = []
//    @Published var followersUIDs:     [String] = []
//    @Published var createdTIsIDs : [String] = []
//    @Published var participatedTIsIDs : [String] = []
//    @Published var savedUsersUIDs:     [String] = []
//    @Published var observingTIsIDs  :     [String]  = []
//    
//    
//    
////    init() async {
////
////        if currentUserUID != "" {
////
////            do {
////                let currentUser = try await UserManager.shared.getUser(userId: currentUserUID)
////
////            } catch { }
////        }
////    }
//    init(currentUser: UserModel?) {
//        print("❣️ currentUser ❣️")
//        guard let currentUser else { return }
//        print("❣️ currentUser 11 ❣️")
//
//        currentUserUID = currentUser.userUID
//        displayName = currentUser.displayName
//        bio = currentUser.bio
//        profileImageURLString = currentUser.profileImageURLString
//        userLabel = currentUser.userLabel
//        //
//        followingUIDs = currentUser.followingUIDs
//        followersUIDs = currentUser.followersUIDs
//        //
//        createdTIsIDs = currentUser.createdTIsIDs
//        participatedTIsIDs = currentUser.participatedTIsIDs
//        //
//        savedUsersUIDs = currentUser.savedUsersUIDs
//        observingTIsIDs = currentUser.observingTIsIDs
//        print("❣️ currentUser \(currentUserUID ?? "no UID" + displayName)❣️")
//        print("❣️ currentUser \(displayName)❣️")
//        print("❣️ currentUser \(savedUsersUIDs)❣️")
//
//        print("❣️ currentUser 22 ❣️")
//
//    }
//
//    init() {
//        #if DEBUG
//        Task { await fetchCurrentUser(currentUserUID: "BXnHfiEaIQZiTcpvWs0bATdAdJo1") }
//        #endif
//    }
//    
//    
//    func setCurrentUser(currentUser: UserModel?) {
//        print("❣️ currentUser ❣️")
//        guard let currentUser else { return }
//        print("❣️ currentUser 11 ❣️")
//        
//        DispatchQueue.main.async {  // Ensuring UI updates happen on the main thread
//            self.currentUserUID = currentUser.userUID
//            self.displayName = currentUser.displayName
//            self.bio = currentUser.bio
//            self.profileImageURLString = currentUser.profileImageURLString
//            self.userLabel = currentUser.userLabel
//            //
//            self.followingUIDs = currentUser.followingUIDs
//            self.followersUIDs = currentUser.followersUIDs
//            //
//            self.createdTIsIDs = currentUser.createdTIsIDs
//            self.participatedTIsIDs = currentUser.participatedTIsIDs
//            //
//            self.savedUsersUIDs = currentUser.savedUsersUIDs
//            self.observingTIsIDs = currentUser.observingTIsIDs
//            
//            print("❣️ currentUser \(self.currentUserUID ?? "no UID" + self.displayName)❣️")
//            print("❣️ currentUser \(self.displayName)❣️")
//            print("❣️ currentUser \(self.savedUsersUIDs)❣️")
//            
//            print("❣️ currentUser 22 ❣️")
//        }
//    }
//    
//    func fetchCurrentUser(currentUserUID: String?) async  {
//        guard currentUserUID != nil else { return }
//        do {
//            let user = try await UserManager.shared.getUser(userId: currentUserUID!)
//            setCurrentUser(currentUser: user)
//        } catch {
//            
//        }
//    }
//}



//init(currentUserUID: String?) async {
//        if currentUserUID == nil {
//            do {
//                let currentUser = try await UserManager.shared.getUser(userId: currentUserUID!)
//            } catch {
//
//            }
//        }
//        self.currentUserUID = currentUserUID
//
//    }
//}

@Observable class CurrentUser {
    
    var UID: String = "NO Current User UID"
    var email      : String     = "No Email"
    var dateJoined: Date      = Date()
    var displayName: String     = "No Display Name"
    var bio        : String     = "No Bio"
    var profileImageURLString: String? = nil

    var userLabel: String = "Observer"
    var followingUIDs:     [String] = []
    var followersUIDs:     [String] = []
    var createdTIsIDs : [String] = []
    var participatedTIsIDs : [String] = []
    var savedUsersUIDs:     [String] = []
    var observingTIsIDs  :     [String]  = []
    
    //fetched
    
    var createdTIs: [TI] = []
    
    var savedUsers: [UserModel] = []
    var observingTIs: [TI] = []
    
    init(currentUser: UserModel?) {
        setCurrentUser(fromUserModel: currentUser)
    }

    init() {
        #if DEBUG
        
        Task {
//            await fetchCurrentUser(currentUserUID: TestingModels().userArray.randomElement()!.userUID)
            
//            await fetchCurrentUser(currentUserUID: TestingModels().userAppleUID)
            await fetchCurrentUser(currentUserUID: TestingModels().usersUIDsArray.randomElement())

        }

        #endif
    }
    
    func fetchCurrentUser(currentUserUID: String?) async  {
        guard let currentUserUID else { return }
        Task {
            do {
                let user = try await UserManager.shared.getUser(userId: currentUserUID)
                setCurrentUser(fromUserModel: user)
//                await updateProfilePicData(imageData: nil, urlString: user?.profileImageURLString)
                await setProfilePicData()
            } catch {
                
            }
        }
    }
    
    
    
    func setCurrentUser(fromUserModel currentUser: UserModel?) {
        print("❣️ currentUser ❣️")
        guard let currentUser else { return }
        print("❣️ currentUser 11 ❣️")
        
        DispatchQueue.main.async {  // Ensuring UI updates happen on the main thread
            self.UID = currentUser.userUID
            self.email = currentUser.email
            self.dateJoined = currentUser.dataJoined
            self.displayName = currentUser.displayName
            self.bio = currentUser.bio
            self.profileImageURLString = currentUser.profileImageURLString
            self.userLabel = currentUser.userLabel
            //
            self.followingUIDs = currentUser.followingUIDs
            self.followersUIDs = currentUser.followersUIDs
            //
            self.createdTIsIDs = currentUser.createdTIsIDs
            self.participatedTIsIDs = currentUser.participatedTIsIDs
            //
            self.savedUsersUIDs = currentUser.savedUsersUIDs
            self.observingTIsIDs = currentUser.observingTIsIDs
            
            
            print("❣️ currentUser \(self.UID + self.displayName)❣️")
            print("❣️ currentUser \(self.displayName)❣️")
            print("❣️ currentUser \(self.savedUsersUIDs)❣️")
            
            print("❣️ currentUser 22 ❣️")
        }
    }
    

//    func updateProfilePicData(imageData: Data?, urlString: String?) async {
//        
//        if let imageData {
//            profilePicData = imageData
//
//            
//        } else if let urlString {
//            
//            if urlString != self.profileImageURLString {
//                profilePicData = await ImageManager.shared.getImage(urlString: urlString)
//            }
//        }
//
//    }
    
    func setProfilePicData() async {
        
        guard let profileImageURLString else { return }
        profilePicData = await ImageManager.shared.getImage(urlString: profileImageURLString)
    }
    
    func userModel() -> UserModel {
        return UserModel(userUID: UID,
                         email: email, dateJoined: dateJoined,
                         displayName: displayName, bio: bio, profileImageURLString: profileImageURLString, userLabel: userLabel,
                         createdTIsIDs: createdTIsIDs, participatedTIsIDs: participatedTIsIDs,
                         followingUIDs: followingUIDs, followersUIDs: followersUIDs,
                         savedUsersUIDs: savedUsersUIDs, observingTIs: observingTIsIDs)
    }
    
    
    var profilePicData: Data? = nil
//    var profilePicData: Data? {
//        
//        return await ImageManager.shared.getImage(urlString: profileImageURLString)
//        
//        
//    }
    
}
