//
//  UserViewModel.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 2/23/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


////MARK: - New for Ti
//final class CurrentUserViewModel {
//    
//    var currentUser: UserModel?
//    
//    func fetchCurrentUser(ID: String) async {
//        Task {
//            currentUser = try await UserManager.shared.getUser(userId: ID)
//        }
//    }
////    func getUser(ID: String) -> User {
////
////    }
//}



////MARK: - OLD
//@MainActor
//final class CurrentUserViewModel2: ObservableObject {
//    
//    @Published private(set) var currentUser: UserModel? = nil
//    
////    init(user: UserModel? = nil) {
////        try await loadCurrentUser(authUser: <#T##AuthDataResultModel#>)
//////        self.user = user
////    }
//    
//    func loadCurrentUser(authUser: AuthDataResultModel) async throws {
////        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
//        self.currentUser = try await UserManager.shared.getUser(userId: authUser.uid)
//    }
////    func saveUser(user: UserModel) async -> Bool {
////
////    }
//}


//@MainActor
//final class UserViewModel: ObservableObject {
//    
//    @Published private(set) var user: UserModel? = nil
//
//    func loadUser(userID: String) async throws {
////        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
////        if userID != nil {
//        do {
//            self.user = try await UserManager.shared.getUser(userId: userID)
//        } catch {
//            print("🏀🟠🏀 Couln't get user")
//            print(error.localizedDescription)
////            throw error.localizedDescription
//        }
////        }
//    }
//}
