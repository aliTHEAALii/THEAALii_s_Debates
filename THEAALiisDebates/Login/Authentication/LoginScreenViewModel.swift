//
//  AuthenticationViewModel.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 4/5/23.
//


//TODO: Bud: user Profile Image doesn't upload immediately probably auth.profilePic & user.profilePic
import Foundation

@MainActor
final class LoginScreenViewModel: ObservableObject {
    
    @Published var currentUser: UserModel? = nil
    @Published var currentUserId: String? = nil
    
    func signInGoogle() async throws {
        do {
            
            
            let helper = SignInWithGoogleHelper()
//            print("⚽️🦠 1")
            
            let tokens = try await helper.signIn()
//            print("⚽️🦠 2")
            
            let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
//            print("⚽️🦠 3")
            
            //        let user = DBUser(auth: authDataResult)
            let user : UserModel? = try await UserManager.shared.getUser(userId: authDataResult.uid)
//            print("⚽️🦠 user")
            
            if user == nil {
//                print("⚽️🦠 nil")
                
                let user = UserModel(authUser: authDataResult)
//                print("⚽️🦠 user2 2")
                
                
                try await UserManager.shared.createNewUser(user: user)
//                print("⚽️🦠 last meaw")
                //MARK: the location of current(user & id) inside and outside [ if ]
                currentUser = user
                currentUserId = authDataResult.uid
                
            }
            
            currentUser = user
            currentUserId = authDataResult.uid
            
        } catch {
            print("Couln't Sign In with Google")
            throw URLError(.badURL)
        }
    }
    
    //MARK: - Sign In Apple
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
        let user : UserModel? = try await UserManager.shared.getUser(userId: authDataResult.uid)
        if user == nil {
            let user = UserModel(authUser: authDataResult)
            try await UserManager.shared.createNewUser(user: user)
            
            currentUser = user
            currentUserId = authDataResult.uid
            
        }
        
        currentUser = user
        currentUserId = user!.userUID   //FIXME: Crashes HERE (can't find user)
        
    }
    
    //Sign In Anonymous
//    func signInAnonymous() async throws {
//        let authDataResult = try await AuthenticationManager.shared.signInAnonymous()
//        //        let user = DBUser(auth: authDataResult)
//        //        try await UserManager.shared.createNewUser(user: user)
//    }
    
}

