//
//  UserVM.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 4/29/24.
//

import Foundation

//@MainActor
final class UserVM: ObservableObject {
 
    @Published var currentUser: UserModel? = nil
    @Published var user: UserModel? = nil
    
    
    func getUser(userUID: String?) async -> UserModel? {
        guard let userUID else { return nil }
        
//#if DEBUG
//        return TestingModels().userArray.randomElement()
//#else
        do {
            return try await UserManager.shared.getUser(userId: userUID)
        } catch {
            print("🏀🟠🏀 Couln't get User From userUID")
            print(error.localizedDescription)
            return nil
        }
//#endif

    }
    
    
    //MARK: - set VM Users
    func setVMCurrentUser(userUID: String?) {
        guard let userUID else { return }
        
#if DEBUG
        currentUser = TestingModels().userArray.randomElement()
#else
        do {
            currentUser = try await UserManager.shared.getUser(userId: userUID ?? "")
        } catch {
            print("🏀🟠🏀 Couln't get saved user")
            print(error.localizedDescription)
            return nil
        }
#endif

    }
    
    func setVMUser(userUID: String?) {
        guard let userUID else { return }
        
#if DEBUG
        user = TestingModels().userArray.randomElement()
#else
        do {
            user = try await UserManager.shared.getUser(userId: userUID ?? "")
        } catch {
            print("🏀🟠🏀 Couln't get saved user")
            print(error.localizedDescription)
            return nil
        }
#endif

    }
    
    
}
