//
//  LoginScreen.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 1/8/23.
//

import SwiftUI

struct LoginScreen: View {
    

    
    @State private var emailSheet = false
    @State private var showLoadingScreen = false
    
    
    @State private var isLoading: Bool = false
    
    var body: some View {
        
        VStack(spacing: 0) {
        
//            if !isLoading {
                Spacer()
                
                //Logo
                Image("TheAAlii Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: width * 0.85)
                
                
                //Apple login Button
                //            AppleLogin()
                AppleLoginButton(isLoading: $isLoading)
                
                //Google login Button
                GoogleLoginButton(isLoading: $isLoading)
                
                //Email login Button
                //            EmailLoginButton(showLoadingScreen: $showLoadingScreen)
                
                //            LogInButton(provider: .anonymous)
                Spacer()
//            } else {
//                LoadingView()
//            }
            
        }
        .preferredColorScheme(.dark)
//        .overlay {
//            LoadingView(show: $showLoadingScreen)
//        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
            .preferredColorScheme(.dark)
    }
}
