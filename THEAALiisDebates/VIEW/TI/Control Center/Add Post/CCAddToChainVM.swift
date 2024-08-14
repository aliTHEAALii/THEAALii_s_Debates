//
//  CCAddToChainVM.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 6/15/24.
//

import Foundation

final class CCAddToChainVM {
    
    
    func uploadPostToChain(tiID: String, postID: String, leftOrRightChain: LeftOrRight,
        title: String, postType: PostType, description: String, imageData: Data?, videoURL: String?, creatorUID: String) 
    async throws {
        
        let thumbnailURLString: String? = await ImageManager.shared.saveImage(imageData: imageData,
                                                       thumbnailFor: .post,
                                                                     thumbnailForTypeId: postID)
        if postType != .text {
            guard thumbnailURLString != nil else {
                print("❌🔥🍒🔼📸 Error Creating D2Ti: Couldn't upload Image 📸🔼🍒🔥❌")
                return
            }
        }
        
        let post = Post(id: postID, title: title, type: postType, text: description, imageURL: thumbnailURLString, videoURL: videoURL, creatorUID: creatorUID, dateCreated: Date.now, addedToChain: nil
        )
        
        let chainLink = ChainLink(id: postID, title: title, thumbnailURL: thumbnailURLString, creatorUID: creatorUID, addedFromVerticalListed: false)
        
        Task {
            do {
                try await PostManager.shared.createPost(tiID: tiID ,post: post)
                print("✅🔼🔗🔥🐍 Success: uploaded Post From CC 🐍🔥🔗🔼✅")

                ChainLinkManager.shared.createChainLink(tiID: tiID, chainLink: chainLink) { error in
                    if error == nil {
                        print("✅🔼🔗🔥🐍 Success: created Chain Link from CC 🐍🔥🔗🔼✅")
                    } else {
                        print("❌🔼🔗🔥🐍 Error: creating Chain Link From CC 🐍🔥🔗🔼❌")
                    }
                    
                }
                
                try await TIManager.shared.addToChain(tiID: tiID, cLinkID: postID, rightOrLeft: leftOrRightChain)
                print("✅🔼🔗🔥🐍 Success: added Post to \(leftOrRightChain) chain 🐍🔥🔗🔼✅")

            } catch {
                
            }
        }
    }
    
    //close 
    func closeButtonPressed(postID: String, postVideoURL: String?) {

        Task {
            do {
                try await VideoManager.shared.deleteVideo(videoID: postID)
            } catch {
                print("🆘🎥 Error Closed CCAddPost Button but didn't delete created video 🎥🆘")
            }

        }
    }
}
