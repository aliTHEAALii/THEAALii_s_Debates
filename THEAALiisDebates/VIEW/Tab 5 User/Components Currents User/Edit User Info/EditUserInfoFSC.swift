//
//  EditUserInfoSheet.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 2/19/23.
//

import SwiftUI
import Firebase
import FirebaseStorage


//MARK: - Edit User Info Button
struct EditUserInfoButton: View {
    
    @Binding var currentUser: UserModel?
    @Binding var bio: String
    @State private var showEditingFSC = false
    
    var body: some View {
        
        Button {
            showEditingFSC.toggle()
        } label: {
            Image(systemName: "gearshape")
                .font(.system(size: width * 0.1, weight: .thin))
                .frame(width: width * 0.15, height: width * 0.15)
                .foregroundColor(.primary)
            
        }
        .fullScreenCover(isPresented: $showEditingFSC) {
            ZStack(alignment: .topTrailing) {
                if currentUser != nil {
                    EditUserInfoFSC(currentUser: currentUser!, bio: $bio, showEditingFSC: $showEditingFSC)
                }

                
                
                
                
            }
        }
    }
}


struct EditUserInfoFSC: View {
    
    @ObservedObject var vmEdit = EditUserInfoViewModel()
    
    @AppStorage("current_user_uid") var currentUserId: String = ""
    @AppStorage("user_name") var currentUserName: String = ""
    @AppStorage("user_Pic") var currentUserProfilePicData: Data?
    @AppStorage("log_status") var logStatus: Bool = false
    
    @State var currentUser: UserModel
    @Binding var bio: String
    @State private var originalBio: String = ""
    @Environment(\.dismiss) var dismiss
    @Binding var showEditingFSC : Bool
    
    //Error
    @State private var errorMessage = ""
    @State private var showError = false
    
    //Keyboard Focus State
    enum Field { case userName, userBio }
    @FocusState private var focusField: Field?
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 10) {
                
                //Close Button
                HStack {
                    Spacer()
                    
                    Button {
                        bio = originalBio
                        showEditingFSC = false
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: width * 0.1, height: width * 0.1)
                                .foregroundColor(.black)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(lineWidth: 0.7)
                                .frame(width: width * 0.1, height: width * 0.1)
                                .foregroundColor(.white)
                            
                            Image(systemName: "xmark")
                                .font(.system(size: width * 0.075, weight: .thin))
                                .foregroundColor(.primary)
                        }
                        .padding(.trailing)
                        
                    }
                }//-Close Button -//
                
                
                PickProfileImageButton()
                
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(lineWidth: 0.5)
                        .frame(width: width * 0.9, height: width * 0.13)
                    
                    if currentUser.displayName == "" {
                        Text("Enter Name")
                            .foregroundColor(.secondary)
                    }
                    
                    //                    TextEditor(text: $currentUserName)
                    TextField(currentUser.displayName, text: $currentUser.displayName)
                        .multilineTextAlignment(.center)
                        .scrollContentBackground(.hidden)
                        .frame(width: width * 0.8, height: width * 0.1, alignment: .center)
                        .submitLabel(.next)
                        .focused($focusField, equals: .userName)
                        .onSubmit { focusField = .userBio }
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(lineWidth: 0.5)
                        .frame(width: width * 0.9, height: width * 0.25)
                    
                    //FIXME: - BIO from database
                    if currentUser.bio == "" {
                        Text("Enter Bio")
                            .foregroundColor(.secondary)
                    }
                      TextEditor(text: $bio)
                        .multilineTextAlignment(.leading)
                        .scrollContentBackground(.hidden)
                        .frame(width: width * 0.85, height: width * 0.22, alignment: .top)
                        .submitLabel(.return)
                        .focused($focusField, equals: .userBio)

                    // Remove .submitLabel(.return) as it's not valid for TextEditor
                }
                .frame(width: width * 0.8, height: width * 0.25, alignment: .top)
                
                
                //MARK: - Save Info Button
                Button {
                    dismiss()
                    saveInfo()
//                    showEditingFSC.toggle()
                } label: {
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(lineWidth: 0.5)
                            .frame(width: width * 0.9, height: width * 0.15)
                        
                        Text("Save Info")
                            .font(.title)
                    }
                    .foregroundColor(.ADColors.green)
                    .padding(.top, 30)
                }
                
                Spacer()
                
                //MARK: - Sign Out
                Button {
                    try? vmEdit.signOut()
                    //user defaults
                    currentUserId = ""
                    currentUserName = ""
                    currentUserProfilePicData = nil
                    logStatus = false
                } label: {
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(lineWidth: 0.5)
                            .frame(width: width * 0.9, height: width * 0.13)
                        
                        Text("Sign Out")
                    }
                    .foregroundColor(.secondary)
                    .padding(.bottom)
                    .padding(.top, width * 0.3)
                }
                
                Rectangle()
                    .foregroundStyle(.clear)
                    .frame(height: width * 0.1)
                
                //MARK: - Delete Account
                Button {
                    deleteAccount()
                    //user defaults
                    currentUserId = ""
                    currentUserName = ""
                    currentUserProfilePicData = nil
                    logStatus = false
                } label: {
                    Text("Delete Account")
                        .foregroundColor(.secondary)
                        .padding(.bottom)
                }
                
            }
            .onAppear { originalBio = bio }
            .background(Color.black)
            .preferredColorScheme(.dark)
            .onTapGesture { focusField = nil }
            .alert(errorMessage, isPresented: $showError) {
                
            }
        }
        
    }
    
    //MARK: - Functions
    
    func saveInfo() {
        Task {
//            do {
                try await UserManager.shared.updateName(userUID: currentUser.userUID, name: currentUser.displayName)
                try await UserManager.shared.updateBio(userUID: currentUser.userUID, bio: bio)
                
                currentUser.bio = bio
                showEditingFSC = false
//            } catch {
//                
//            }
        }
    }
    
    func deleteAccount() {
        Task {
            do {
                guard let userID = Auth.auth().currentUser?.uid else { return }
                //1. delete Profile Image from Storage
                let reference = Storage.storage().reference().child("Profile_Images").child(userID)
                try await reference.delete()
                //2. Deleting FireStore user document
                try await Firestore.firestore().collection("Users").document(userID).delete()
                //3. Finally: Deleting Auth Account & setting log status to false
                try await Auth.auth().currentUser?.delete()
                logStatus = false
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
    
    func setError() async {
        
    }
}

struct EditUserInfoFSC_Previews: PreviewProvider {
    static var previews: some View {
        EditUserInfoFSC(currentUser: TestingModels().user1, bio: .constant("Green & Blue"), showEditingFSC: .constant(true))
        
        EditUserInfoButton(currentUser: .constant(TestingModels().user1), bio: .constant("Green & Blue"))
            .preferredColorScheme(.dark)
    }
}

