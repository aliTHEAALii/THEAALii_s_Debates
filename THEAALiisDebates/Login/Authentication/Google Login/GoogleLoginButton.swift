//
//  GoogleLogin.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 1/9/23.
//


//TODO: Bud: user Profile Image doesn't upload immediately probably auth.profilePic & user.profilePic

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import Firebase

struct GoogleLoginButton: View {
    
    @StateObject var vm = LoginScreenViewModel()
    
    @Environment(CurrentUser.self) var currentUser

    @AppStorage("current_user_uid"  ) var currentUserUID: String = ""
    @AppStorage("user_name" ) var currentUserName: String = ""
    @AppStorage("user_Pic"  ) var currentUserProfilePicData: Data?
    @AppStorage("log_status") var logStatus: Bool = false
    
    @Binding var isLoading: Bool

        
    var body: some View {
        
        
        Button {
            
            Task {
                isLoading = true
                await signInGoogleFunc()
                isLoading = false
            }
        } label: {
            LogInButton(provider: .google)
        }
        
    }
    
    @MainActor
    private func signInGoogleFunc() async {
        do {
            try await vm.signInGoogle()
//            print("⚽️🦠 signed In")

            //MARK: - Current User O
            currentUser.setCurrentUser(fromUserModel: vm.currentUser)
            
            currentUserUID = vm.currentUserId ?? "no User ID"
            currentUserName = vm.currentUser?.displayName ?? "No Name"
//            print("⚽️🦠 Id : " + currentUserUID)

            //image
            let imageString = vm.currentUser?.profileImageURLString
//            print("⚽️🦠 image String:" + (imageString ?? "nil"))

            currentUserProfilePicData = await ImageManager.shared.getImage(urlString: imageString)
//            print("⚽️🦠 image data \(String(describing: currentUserProfilePicData))")

            
            logStatus = true
//            print("⚽️🦠 true")
            
        } catch {
            print("❌🚪⚽️ Error Signing in With Google")
        }
    }
    //MARK: - LogIn With Google Function
    ///Swift Full thinking
//    @MainActor
//    func signInGoogle() async throws {
//
//        guard let topViewController = Utilities.shared.topViewController() else {
//            throw URLError(.cannotFindHost)
//        }
//
//        let gIDSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topViewController)
//
//        guard let idToken = gIDSignInResult.user.idToken?.tokenString else {
//            throw URLError(.badServerResponse)
//        }
//        let accessToken = gIDSignInResult.user.accessToken.tokenString
//
//        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
//
//        //Sign In
//        try await Auth.auth().signIn(with: credential)
//
//        //MARK: - Set User Defaults
//        let user = Auth.auth().currentUser
//        currentUserUID  = user!.uid
//    }
    
}

struct GoogleLoginButton_Previews: PreviewProvider {
    static var previews: some View {
        GoogleLoginButton(isLoading: .constant(false))
    }
}



//                do {
//                    try await vm.signInGoogle()
//                    print("⚽️🦠 signedIn")
//
//                    currentUserUID = vm.currentUserId ?? "no User ID"
//                    currentUserName = vm.currentUser?.name ?? "No Name"
//                    print("⚽️🦠 Id & image")
//
//                    //image
//                    let imageString = vm.currentUser?.profileImageURLString
//                    print("⚽️🦠 image String")
//
//                    currentUserProfilePicData = await ImageManager.shared.getImage(urlString: imageString)
//                    print("⚽️🦠 image data")
//
//
//                    logStatus = true
//                    print("⚽️🦠 true")
//
//                } catch {}


