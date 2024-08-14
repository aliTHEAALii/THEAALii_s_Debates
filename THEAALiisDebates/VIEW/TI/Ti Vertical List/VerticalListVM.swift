//
//  VerticalListVM.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 6/26/24.
//

import Foundation
import Firebase

final class VerticalListVM {
    
    
    func uploadPostToChainLinkVerticalList(tiID: String, chainLinkID: String, postID: String,
                                           
                                           title: String,
                                           postType: PostType,
                                           description: String,
                                           imageData: Data?,
                                           videoURL: String?,
                                           creatorUID: String,
                                           completion: @escaping (Error?)->Void ) async throws {
        
        
        let thumbnailURLString: String? = await ImageManager.shared.saveImage(imageData: imageData,
                                                                              thumbnailFor: .post,
                                                                              thumbnailForTypeId: postID)
        
//        guard let thumbnailURLString = thumbnailURLString else {
//            print("❌🔥🍒🔼📸 Error Creating D2Ti: Couldn't upload Image 📸🔼🍒🔥❌")
//            return
//        }
        if postType != .text {
            guard thumbnailURLString != nil else {
                print("❌🔥🍒🔼📸 Error Creating D2Ti: Couldn't upload Image 📸🔼🍒🔥❌")
                return
            }
        }
        
        
        let post = Post(id: postID, title: title, type: postType, text: description, imageURL: thumbnailURLString, videoURL: videoURL, creatorUID: creatorUID, dateCreated: Date.now, addedToChain: nil
        )
        
        PostManager.shared.createVerticalListPost(tiID: tiID, chainLinkID: chainLinkID, post: post) { error in
            if let error {
                print("🆘🔺⛓️😶‍🌫️📜 ERROR creating VL post: \(error.localizedDescription) 📜😶‍🌫️⛓️🔺🆘")
                completion(error)
            } else {
                
                ChainLinkManager.shared.addPostToVerticalList(tiID: tiID, chainLinkID: chainLinkID, postID: postID) { error in
                    
                    if let error {
                        print("🆘🔺⛓️🥩 ERROR adding post to vertical list: \(error.localizedDescription) 🥩⛓️🔺🆘")
                        completion(error)
                        
                    } else {
                        print("✅⛓️🦖 Success added POST to VERTICAL LIST  🦖⛓️✅")
                        completion(nil)
                    }
                }
            }
        }
    }

//    func getVLPosts(tiID: String, chainLinkID: String, completion: @escaping (Result<[Post], Error>)->Void) async {
//        
//                do {
//                    let querySnapshot = try await Firestore.firestore()
//                        .collection("THEAALii_Interactions")
//                        .document(tiID)
//                        .collection("Chain_Links")
//                        .document(chainLinkID)
//                        .collection("Vertical_List_Posts")
//                        .order(by: "total_votes", descending: true) // Sort by field
//                        .getDocuments()
//                    
//                    let fetchedInteractions = querySnapshot.documents.compactMap { document in
//                        try? document.data(as: Post.self)
//                    }
//                    completion(.success(fetchedInteractions))
//                    
//                } catch {
//                    print("Error fetching interactions: \(error)")
//                    completion(.failure(error))
//                }
//    }
    func getVLPosts(tiID: String, chainLinkID: String, lastDocument: DocumentSnapshot?, pageSize: Int, completion: @escaping (Result<([Post], DocumentSnapshot?), Error>) -> Void) {
        var query = Firestore.firestore()
            .collection("THEAALii_Interactions")
            .document(tiID)
            .collection("Chain_Links")
            .document(chainLinkID)
            .collection("Vertical_List_Posts")
            .order(by: "total_votes", descending: true) // Sort by field
            .limit(to: pageSize)
        
        // Start after the last document if pagination is in use
        if let lastDoc = lastDocument {
            query = query.start(afterDocument: lastDoc)
        }
        
        query.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching interactions: \(error)")
                completion(.failure(error))
            } else {
                let posts = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Post.self)
                } ?? []
                let lastDoc = querySnapshot?.documents.last
                completion(.success((posts, lastDoc)))
            }
        }
    }
    

}
