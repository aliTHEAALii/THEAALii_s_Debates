//
//  PickProfileImageButton.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 2/14/23.
//

import SwiftUI
import PhotosUI
import UIKit
import FirebaseStorage
import Firebase

struct PickProfileImageButton: View {
    
    @AppStorage("current_user_uid") var currentUserID: String = ""
    @AppStorage("user_Pic") var currentUserProfilePicData: Data?
    
    //    @State var userName = ""
    //    @State var currentUserBio = ""
    //    @State var userProfilePicData: Data?
    
    @Environment(\.dismiss) var dismiss
    @State var showImagePicker = false
    @State var selectedPhoto: PhotosPickerItem?
    
    //MARK: View
    var body: some View {
        
        // - User Profile Pic
        ZStack() {
            
            Button {
                showImagePicker.toggle()
            } label: {
                
                if let currentUserProfilePicData, let image = UIImage(data: currentUserProfilePicData) {
                    
                    ZStack {
                        
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: width * 0.6, height: width * 0.6)
                            .clipShape(Circle())
                        
                        Circle()
                            .stroke()
                            .foregroundColor(.white)
                            .frame(width: width * 0.6, height: width * 0.6)
                    }
                    
                } else { PersonIcon() }
            }
        }//Z
        .foregroundColor(.secondary)
//        .frame(width: width, height: width * 0.75)
        //MARK: Pick Image
        .photosPicker(isPresented: $showImagePicker, selection: $selectedPhoto)
        .onChange(of: selectedPhoto) { newValue , _ in
            //extracting uiImage from photoItem
            if let newValue {
                Task {
                    do {
                        guard let imageData = try await newValue.loadTransferable(type: Data.self) else { return }
//
                        //UI must be updated on the main thread
                        await MainActor.run(body: {
                            currentUserProfilePicData = imageData
                        })
                        print("📸 successfully selected image")
                        
                        let _ = await saveImage(image: UIImage(data: imageData)!)

//                        let storageRef = Storage.storage().reference().child("Profile_Images").child(currentUserUID)
//                        let _ = try await storageRef.putDataAsync(imageData)
//
                          //Downloading Photo URL
//                        let downloadImageURL = try await storageRef.downloadURL()
//                        currentUserProfilePicData = imageData
//
//                        print("Profile Image URL: -----------\(downloadImageURL)")
//                        //TODO: - Update User Info
//                        let _ = try  await Firestore.firestore().collection("Users").document(currentUserUID).updateData(["profileImageURL" : "\(downloadImageURL)"])
                        
                    } catch {
                        print("❌🤬📸Error: selecting image failed\(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    //MARK: - Function [ Save Image ]
    func saveImage(image: UIImage) async -> Bool {
        
        //        guard currentUserUID != nil else {
        //            print("😡📸 current UserID == nil")
        //            return false
        //        }
        
//        let imageName = UUID().uuidString //name of the image document
        
        let storage = Storage.storage()
        let storageReference = storage.reference().child("Profile_Images").child(currentUserID)
        
        guard let resizedImage = image.jpegData(compressionQuality: 0.2) else {
            print("😡📸 couldn't resize Image")
            return false
        }
        
        let metadata = StorageMetadata ()
        metadata.contentType = "image/jpg" // Setting metadata allows you to see console image in the web b: setting will work for png as well as jpeg
        var imageURLString = "" // We'll set this after the image is successfully saved Variable 'imageURLString
        do {
            let _ = try await storageReference.putDataAsync(resizedImage, metadata:metadata)
            print ("📸 a Image Saved!")
            
            do {
                let imageURL = try await storageReference.downloadURL()
                imageURLString = "\(imageURL)" // We'll save this to Cloud Firestore as part of document in collection, below
            } catch {
                print("🤬 ERROR: Could not get imageURL after saving image \(error.localizedDescription)")
                return false
            }
        } catch {
            print ("🤬 ERROR: uploading image to FirebaseStorage")
            return false
        }
        
        
        //Save to the User document
        let db = Firestore.firestore()
        let userReference = db.collection("Users").document(currentUserID)
        
        do {
//            try await userReference.updateData(["profile_image_url" : imageURLString])
            try await userReference.setData(["profile_image_url" : imageURLString], merge: true)

            return true

        } catch {
            print("🤬 ERROR: Could not update profileImageURL String in fireStore")
            return false
        }
        
    }
}

struct PickProfileImageButton_Previews: PreviewProvider {
    static var previews: some View {
        UserTabView()
            .preferredColorScheme(.dark)
        PickProfileImageButton()
    }
}
