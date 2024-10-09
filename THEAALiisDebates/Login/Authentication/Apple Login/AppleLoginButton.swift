//
//  ContinueWithAppleButtonSV.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 4/5/23.
//

import SwiftUI

struct AppleLoginButton: View {
    
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
                do {
                    isLoading = true
                    try await vm.signInApple()
//                    showSignInView = false
//                    currentUserUID = vm.currentUserId ?? "no User ID"
//                    logStatus = true
                    
                    //MARK: - Current User O
                    currentUser.setCurrentUser(currentUser: vm.currentUser)
                    
                    currentUserUID = vm.currentUserId ?? "no User ID"
                    currentUserName = vm.currentUser?.displayName ?? "No Name"
                    //image
                    let imageString = vm.currentUser?.profileImageURLString
                    currentUserProfilePicData = await ImageManager.shared.getImage(urlString: imageString)
                    
                    logStatus = true
                    isLoading = false
                    print("😎 Apple 🍏 signed In")
                } catch {
                    print("❌Error: Couldn't Login with Apple")
                    isLoading = false
                }
            }
        } label: {
            SignInWithAppleButtonViewRepresentable(type: .continue, style: .white)
                .allowsHitTesting(false)
        }
        .frame(width: width * 0.85 ,height: 55)
//        .frame(width: width * 0.6 ,height: 55)
        .padding(.bottom, width * 0.04)

    }
    
    
    @MainActor
    private func signInGoogleFunc() async {
        do {
            try await vm.signInGoogle()

            currentUserUID = vm.currentUserId ?? "no User ID"
            currentUserName = vm.currentUser?.displayName ?? "No Name"

            //image
            let imageString = vm.currentUser?.profileImageURLString

            currentUserProfilePicData = await ImageManager.shared.getImage(urlString: imageString)

            
            logStatus = true
            
        } catch {
            print("❌🚪🍏 Error Signing in With Apple ")
        }
    }
}

struct AppleLoginButton_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
        
        AppleLoginButton(isLoading: .constant(false))
    }
}



//MARK: - The old approach

//struct AppleLogin: View {
//
//    @StateObject  var vm = AuthenticationViewModel()
//    @StateObject var loginData = AppleLoginViewModel()
//    @AppStorage("log_status") var logStatus: Bool = false
//
//    var body: some View {
//
//        LogInButton(provider: .apple)
//            .overlay {
//                SignInWithAppleButton { (request) in
//
//                    //requesting params from apple login...
//                    loginData.nonce = randomNonceString()
//                    request.requestedScopes = [.email, .fullName]
//                    request.nonce = sha256(loginData.nonce)
//                } onCompletion: { (result) in
//
//                    //getting error or success
//                    switch result {
//
//                    case .success(let user):
//                        //do login with firebase
//                        guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
//                            print("error with firebase")
//                            return
//                        }
//
//                        //MARK: - Log in success
//                        loginData.authenticate(credential: credential)
//                        logStatus = true
//
//                        print("🍏🪵 Apple Log-In Success")
//
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                    }
//                }
//                .frame(width: width * 0.8, height:  width * 0.2)
//                .clipShape(Capsule())
//                //
//                .blendMode(.overlay)
//            }
//    }
//}
//
//struct AppleLogin_Previews: PreviewProvider {
//    static var previews: some View {
//        AppleLogin()
//    }
//}

