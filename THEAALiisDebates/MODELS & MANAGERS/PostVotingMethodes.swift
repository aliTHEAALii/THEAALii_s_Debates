//
//  PostVotingMethodes.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 8/15/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


extension PostManager {
    
    //1 - UP Voters Array
    func updateUpVotersArray(tiID: String, postID: String, userUID: String, addOrRemove: AddOrRemove) async {
        
        if addOrRemove == .add { //add
            do {
                try await PostDocument(tiID: tiID, postID: postID).updateData( [Post.CodingKeys.upVotersUIDsArray.rawValue : FieldValue.arrayUnion( [userUID] )])
                
            } catch { print("🆘🔺⛓️☎️ ERROR adding userUID to upVotersUIDsArray : \(error.localizedDescription) ☎️⛓️🔺🆘") }
            
        } else if addOrRemove == .remove { //remove
            do {
                try await PostDocument(tiID: tiID, postID: postID).updateData( [Post.CodingKeys.upVotersUIDsArray.rawValue : FieldValue.arrayRemove( [userUID] )])
                
            } catch { print("🆘🔺⛓️☎️ ERROR removing userUID from upVotersUIDsArray: \(error.localizedDescription) ☎️⛓️🔺🆘") }
        }
    }
    
    //2 - Down Voters Array
    func updateDownVotersArray(tiID: String, postID: String, userUID: String, addOrRemove: AddOrRemove) async {
        
        if addOrRemove == .add { //add
            do {
                try await PostDocument(tiID: tiID, postID: postID).updateData( [Post.CodingKeys.downVotersUIDsArray.rawValue : FieldValue.arrayUnion( [userUID] )])
                
            } catch { print("🆘🔺⛓️☎️ ERROR adding userUID to downVotersUIDsArray : \(error.localizedDescription) ☎️⛓️🔺🆘") }
            
        } else if addOrRemove == .remove { //remove
            do {
                try await PostDocument(tiID: tiID, postID: postID).updateData( [Post.CodingKeys.downVotersUIDsArray.rawValue : FieldValue.arrayRemove( [userUID] )])
                
            } catch { print("🆘🔺⛓️☎️ ERROR removing userUID from downVotersUIDsArray: \(error.localizedDescription) ☎️⛓️🔺🆘") }
        }
    }
    
    
}
