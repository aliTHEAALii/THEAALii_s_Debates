//
//  SaveUserButton.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 9/17/24.
//

import SwiftUI

//MARK: - Save User Button
struct SaveUserButton: View {
    
    let user: UserModel
//    @State var currentUser: UserModel
    @Environment(CurrentUser.self) var currentUser
    @AppStorage("current_user_uid"  ) var currentUserUID: String = "BXnHfiEaIQZiTcpvWs0bATdAdJo1"
    @State private var showSavedUsersSheet = false
    @State private var userSaved = false
    @State private var isLoading = false
    
    var body: some View {
        
        VStack {
            if !isLoading {
                Button {
                    Task { try await updateSavedUsers() }
                    
                } label: {
                    ZStack {
                        if userSaved {
                            
                            Text("Saved")
                                .font(.callout)
                                .foregroundColor(.secondary)
                            
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(lineWidth: 1)
                                .fill(Color.secondary)
                                .frame(width: width * 0.14, height: width * 0.14)
                            
                            Text("Save User")
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(width: width * 0.15, height: width * 0.15)
                }
                .sheet(isPresented: $showSavedUsersSheet) {
                    VStack(spacing: 0) {
                        Text("User Saved")
                            .font(.title)
                            .frame(width: width)
                            .padding(.top)
                        
                        Text("You can use saved users When Editing admins & Teams in THEAALii Interactions")
                            .padding(.vertical, width * 0.1)
                            .foregroundStyle(.white)
                        
                        Spacer()
                    }
                    .background(Color.black.opacity(0.4))
                    .presentationDetents([.fraction(0.25), .medium])
                    .preferredColorScheme(.dark)
                }
            } else { ProgressView().frame(width: width * 0.15, height: width * 0.15)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear{ userSaved = currentUser.savedUsersUIDs.contains(user.userUID) }
    }
    
    //MARK: - Function
    
    func updateSavedUsers() async throws {
        print("🍌 🫒 saved user enter 🫒 🍌")
        if userSaved {
            print("🍌 🫒 2 🫒 🍌")
            isLoading = true
            try await UserManager.shared.updateSavedUsers(currentUserUID: currentUser.UID ,userIdForArray: user.userUID, addOrRemove: (.remove))
            
            print("🍌 🫒 saved user remove! 🫒 🍌")
            
            currentUser.savedUsersUIDs.remove(object: user.userUID)
            userSaved = false
            isLoading = false
            
        } else {
            print("🍌 🫒 3 🫒 🍌")
            isLoading = true
            try await UserManager.shared.updateSavedUsers(currentUserUID: currentUser.UID ,userIdForArray: user.userUID ,addOrRemove: (!userSaved ? .add : .remove))
            print("🍌 🫒 saved user add! 🫒 🍌")
            
            currentUser.savedUsersUIDs.append(user.userUID)
            showSavedUsersSheet.toggle()
            userSaved = true
            isLoading = false
        }
    }
}

//#Preview {
//    SaveUserButton()
//}
struct SaveUserButton_Previews: PreviewProvider {
    static var previews: some View {
        //        SaveUserButton(user: TestingModels().user1, currentUser: TestingModels().user1 )
        
        UserFSC(user: TestingModels().user1, showFSC: .constant(true))
        UserButton(
            userUID: "wow"
            //            imageURL: TestingImagesVideos().imageURLStringDesignnCode
        )
        .environment(CurrentUser().self)
        //        UserFSC(user: <#UserModel?#>)
    }
}
