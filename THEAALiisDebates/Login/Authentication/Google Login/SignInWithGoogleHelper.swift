//
//  SignInGoogleHelper.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 4/5/23.
//

//import Foundation
//import GoogleSignIn
//import GoogleSignInSwift
//
//struct GoogleSignInResultModel {
//    let idToken: String
//    let accessToken: String
//    let name: String?
//    let email: String?
//}
//
//final class SignInGoogleHelper {
//
//    @MainActor
//    func signIn() async throws -> GoogleSignInResultModel {
//        guard let topVC = Utilities.shared.topViewController() else {
//            throw URLError(.cannotFindHost)
//        }
//
//        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
//
//        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
//            throw URLError(.badServerResponse)
//        }
//
//        let accessToken = gidSignInResult.user.accessToken.tokenString
//        let name = gidSignInResult.user.profile?.name
//        let email = gidSignInResult.user.profile?.email
//
//        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken, name: name, email: email)
//        return tokens
//    }
//
//}


//The Full Downloaded
//https://gist.github.com/SwiftfulThinking/3c2003a586a1ef50a7d7a5b7ea92de77
import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInResultModel {
   let idToken: String
   let accessToken: String
   let name: String? = nil
   let email: String? = nil
}

final class SignInWithGoogleHelper {
       
   @MainActor
   func signIn(viewController: UIViewController? = nil) async throws -> GoogleSignInResultModel {
       guard let topViewController = viewController ?? topViewController() else {
           throw URLError(.notConnectedToInternet)
       }
       
       let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topViewController)
       
       guard let idToken = gidSignInResult.user.idToken?.tokenString else {
           throw URLError(.badServerResponse)
       }
       
       let accessToken = gidSignInResult.user.accessToken.tokenString
       let _ = gidSignInResult.user.profile?.name //  let name
       let _ = gidSignInResult.user.profile?.email // let email
       return GoogleSignInResultModel(idToken: idToken, accessToken: accessToken)
   }
   
   //MARK: - Utilities
//   @MainActor
//   func topViewController(controller: UIViewController? = nil) -> UIViewController? {
//       let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController //Depreciated
//       
//       if let navigationController = controller as? UINavigationController {
//           return topViewController(controller: navigationController.visibleViewController)
//       }
//       if let tabController = controller as? UITabBarController {
//           if let selected = tabController.selectedViewController {
//               return topViewController(controller: selected)
//           }
//       }
//       if let presented = controller?.presentedViewController {
//           return topViewController(controller: presented)
//       }
//       return controller
//   }
    @MainActor              //From ChatGPT
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        let controller = controller ?? UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }

   
}

