////
////  RootView.swift
////  THEAALiisDebates
////
////  Created by Ali Kadhum on 4/5/24.
////
//
//import SwiftUI
//
//struct RootView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//#Preview {
//    RootView()
//}
//

//
//  RootView.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 3/2/24.
//

import SwiftUI

struct RootView: View {
    
    @AppStorage("current_user_uid") var currentUserUID: String = "BXnHfiEaIQZiTcpvWs0bATdAdJo1"
    @AppStorage("log_status") var logStatus: Bool = true

    @State var currentUser =  CurrentUser()
    
    @State private var showLoginScreen = false

    
    var body: some View {
        
        ZStack {
            
            if logStatus {
                TabsBar()
                    .environment(currentUser)

            } else {
                LoginScreen()
                    .environment(currentUser)

            }
            
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showLoginScreen = authUser == nil ? true : false
            Task {
//                if authUser != nil {
                    await currentUser.fetchCurrentUser(currentUserUID: authUser?.uid)
//                } else {
//                    await currentUser.fetchCurrentUser(currentUserUID: currentUserUID)
//                }

            }
        }
    }
}

#Preview {
    RootView()
}
