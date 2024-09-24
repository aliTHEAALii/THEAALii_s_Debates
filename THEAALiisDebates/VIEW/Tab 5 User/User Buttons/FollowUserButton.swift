//
//  FollowUserButton.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 9/17/24.
//

import SwiftUI

struct FollowUserButton: View {
    
    let user: UserModel
    @State var currentUser: UserModel
    @AppStorage("current_user_uid"  ) var currentUserUID: String = "BXnHfiEaIQZiTcpvWs0bATdAdJo1"
//    @State private var showSavedUsersSheet = false
    @State private var followingUser = false
    @State private var isLoading = false
    
    var body: some View {
        

        VStack {
            if !isLoading {
                Button {
                    Task { try await updateFollowingUsers() }
                } label: {
                    ZStack {
                        if followingUser {
                            Text("Followed")
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .frame(width: width * 0.14, height: width * 0.1)
                            
                        } else {
                            Text("Follow")
                                .foregroundStyle(.gray)
                            
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 1)
                                .fill(Color.secondary)
                                .frame(width: width * 0.14, height: width * 0.1)
                        }
                    }
                }
            } else { ProgressView() }
        }
        .onAppear{ followingUser = currentUser.followingUIDs.contains(user.userUID) }
    }
    
    //MARK: - Functions
    func updateFollowingUsers() async throws {
        print("🍌 🫒 following user enter 🫒 🍌")
        if followingUser {
            print("🍌 🫒 2 🫒 🍌")
            isLoading = true
            try await UserManager.shared.updateFollowingUsers(currentUserUID: currentUser.userUID ,userUIDForArray: user.userUID, addOrRemove: (.remove))
            
            print("🍌 🫒 following user remove! 🫒 🍌")
            
            currentUser.savedUsersUIDs.remove(object: user.userUID)
            followingUser = false
            isLoading = false
            
        } else {
            print("🍌 🫒 3 🫒 🍌")
            isLoading = true
            try await UserManager.shared.updateFollowingUsers(currentUserUID: currentUser.userUID ,userUIDForArray: user.userUID ,addOrRemove: (.add))
            print("🍌 🫒 following user add! 🫒 🍌")
            
            currentUser.savedUsersUIDs.append(user.userUID)
            followingUser = true
            isLoading = false
        }
    }
}

#Preview {
    UserFSC(user: TestingModels().user1, showFSC: .constant(true))
}
