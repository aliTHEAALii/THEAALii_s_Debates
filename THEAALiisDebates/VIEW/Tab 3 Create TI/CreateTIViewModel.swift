//
//  CreateTIViewMedia.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 4/23/24.
//

import Foundation

@MainActor
final class CreateTIVM: ObservableObject {
    
//    @Published var videoID: String = UUID().uuidString
    let TIID: String = UUID().uuidString
    let videoId: String = UUID().uuidString

    @Published var videoURL: String?

    
    func createTIT(
        tiTitle: String,
        tiDescription: String,
        tiThumbnailURL: String?,
        
        firstTitVideoName: String,
        firstTitVideoDescription: String,
        firstVideoThumbnailURL: String?,
        creatorID: String,
//                   firstvideoID: String,
        firstVideoURL: String
    ) async throws {
            
            //create instances
            //TODO: - Thumbnail & tit name
            let tit = TIModel(
                id: TIID,
                name: tiTitle,
                description: tiDescription,
            thumbnailURLString: tiThumbnailURL,
                creatorUID: creatorID,
                administratorsUID: []
            )
            
            //TODO: - Thumbnail & tit name & VideoId
            let titVideo = TIVideoModel(
                id: videoId,
                videoURL: firstVideoURL,
                thumbnail: firstVideoThumbnailURL,
                creatorID: creatorID,
                name: firstTitVideoName,
                description: firstTitVideoDescription,
                chainLId: nil
            )
            
            let titChainLink = TITChainLinkModel(id: UUID().uuidString, postID: titVideo.id, verticalList: [])
            
            Task {
            do {
                try await TITManager.shared.createTIT(TITModel: tit)
                try await TITVideoManager.shared.createTitVideo(titID: tit.id, titVideo: titVideo)
                try await TITChainLinkManager.shared.createTITChainLink(TITid: tit.id, TITChainLink: titChainLink)
                
                try await TITManager.shared.addToChain(titId: tit.id, chainId: titChainLink.id)
                
            } catch {
                print("❌❌❌ Error: Couldn't Create TI ❌❌❌")
            }
        }
    }
    
    //MARK: Delete Video
    func deleteVideo(videoID: String) async throws {
        Task {
            do {
                try await VideoManager.shared.deleteVideo(videoID: videoID)
                print("😈😏 video Deleted 🫥🫥👹")
            } catch {
                print("❌🎥 couldn't delete video 🎥❌ \(error.localizedDescription)")
                throw error
            }
        }
    }
}

















final class CreateTiVM {
    
    //MARK: - Create D1 Ti
    func createD1Ti(
        id: String,
        title: String, description: String, tiThumbnailData: Data?,
        creatorUID: String, tiAdminsUIDs: [String],
        
        rsLevel1UsersUIDs : [String]?,
        rsLevel2UsersUIDs : [String]?,
        rsLevel3UsersUIDs : [String]?,
        
        rsVerticalListAccess: VerticalListAccess,
        
        completion: @escaping (_ success: Bool) -> Void
    ) async -> Bool {
        
        let thumbnailURLString: String? = await ImageManager.shared.saveImage(imageData: tiThumbnailData,
                                                       thumbnailFor: .TI,
                                                                     thumbnailForTypeId: id)
        
        guard let thumbnailURLString = thumbnailURLString else {
            print("❌🔥🍒🔼📸 Error Creating D1Ti: Couldn't upload Image 📸🔼🍒🔥❌")
            completion(false)
            return false
        }
        
        let introChainLink = ChainLink(id: id, title: "INTRO", thumbnailURL: thumbnailURLString, creatorUID: creatorUID, addedFromVerticalListed: false)

        let introPost = Post(id: id, title: "INTRO", type: .text, text: description, imageURL: nil, videoURL: nil, creatorUID: creatorUID, dateCreated: Date.now, addedToChain: nil
        )
        
        let d1Ti = TI(ID: id, title: title, description: description,
                      thumbnailURL: thumbnailURLString, creatorUID: creatorUID, tiAdminsUIDs: tiAdminsUIDs,
                      rsLevel1UsersUIDs: rsLevel1UsersUIDs, rsLevel2UsersUIDs: rsLevel2UsersUIDs, rsLevel3UsersUIDs: rsLevel3UsersUIDs, rsVerticalListAccess: rsVerticalListAccess) //Right Side
        Task {
            do {
                try await TIManager.shared.createTI(ti: d1Ti)
                print("✅🔥🥬🔼 Success: uploaded d1Ti 🔼🥬🔥✅")

                //chain
                ChainLinkManager.shared.createChainLink(tiID: id, chainLink: introChainLink) { error in
                    if error == nil {
                        print("✅🔼⛓️🔥🐍 Success: uploaded d1Ti Chain Link 🐍🔥⛓️🔼✅")
                        completion(true)
                    } else {
                        print("❌🔼⛓️🔥🐍 Error: uploaded d1Ti Chain Link 🐍🔥⛓️🔼❌")
                        completion(false)
                    }
                }
                
                try await PostManager.shared.createPost(tiID: id, post: introPost)
                
                try await UserManager.shared.addTiToCreated(tiID: id, currentUserUID: creatorUID)
                
                print("✅🔥🥬🔼 Success: uploaded [ introPost ] 🔼🥬🔥✅")
                completion(true)
                return true
                
            } catch {
                print("❌🔥🍇🔼 Error: Couldn't upload d1Ti 🔼🍇🔥❌")
                completion(false)
                
                return false
            }
        }
        
        return false
    }
    
    
    //MARK: - Create D2 Ti
    func createD2TiOld(
        id: String,
        title: String, description: String, tiThumbnailData: Data?,
        creatorUID: String, tiAdminsUIDs: [String],
        
        //right
        rsUserUID : String          ,
        rsLevel1UsersUIDs : [String]?,
        rsLevel2UsersUIDs : [String]?,
        rsLevel3UsersUIDs : [String]?,
        
        rsVerticalListAccess: VerticalListAccess,
        
        //left
        lsUserUID : String          ,
        lsLevel1UsersUIDs : [String]?,
        lsLevel2UsersUIDs : [String]?,
        lsLevel3UsersUIDs : [String]?,
        
        lsVerticalListAccess: VerticalListAccess,
        
        completion: @escaping (_ success: Bool) -> Void
    ) async -> Bool {
        
        let thumbnailURLString: String? = await ImageManager.shared.saveImage(imageData: tiThumbnailData,
                                                       thumbnailFor: .TI,
                                                                     thumbnailForTypeId: id)
        
        guard let thumbnailURLString = thumbnailURLString else {
            print("❌🔥🍒🔼📸 Error Creating D2Ti: Couldn't upload Image 📸🔼🍒🔥❌")
            completion(false)
            return false
        }

        let introPost = Post(id: id, title: "INTRO", type: .text, text: description, imageURL: nil, videoURL: nil, creatorUID: creatorUID, dateCreated: Date.now, addedToChain: nil
        )
        
        let introChainLink = ChainLink(id: id, title: "INTRO", thumbnailURL: thumbnailURLString, creatorUID: creatorUID, addedFromVerticalListed: false)
        
        let d2Ti = TI(ID: id, title: title, description: description, thumbnailURL: thumbnailURLString, creatorUID: creatorUID, tiAdminsUIDs: tiAdminsUIDs,
                       rsUserUID: rsUserUID, rsLevel1UsersUIDs: rsLevel1UsersUIDs, rsLevel2UsersUIDs: rsLevel2UsersUIDs, rsLevel3UsersUIDs: rsLevel3UsersUIDs, rsVerticalListAccess: rsVerticalListAccess, //Right Side
                       lsUserUID: lsUserUID, lsLevel1UsersUIDs: lsLevel1UsersUIDs, lsLevel2UsersUIDs: lsLevel2UsersUIDs, lsLevel3UsersUIDs: lsLevel3UsersUIDs, lsVerticalListAccess: lsVerticalListAccess) //Left Side
        Task {
            do {
                try await TIManager.shared.createTI(ti: d2Ti)
                
                //TODO: - add Ti to current user's created Tis
                
                print("✅🔥🥬🔼 Success: uploaded d1Ti 🔼🥬🔥✅")
                
                //chain
                ChainLinkManager.shared.createChainLink(tiID: id, chainLink: introChainLink) { error in
                    if error == nil {
                        print("✅🔼⛓️🔥🐍 Success: uploaded d1Ti Chain Link 🐍🔥⛓️🔼✅")
                        completion(true)
                    } else {
                        print("❌🔼⛓️🔥🐍 Error: uploaded d1Ti Chain Link 🐍🔥⛓️🔼❌")
                        completion(false)
                    }
                }
                
                print("✅🔥🥬🔼 Success: uploaded d1Ti 🔼🥬🔥✅")
                
                //post
                try await PostManager.shared.createPost(tiID: id, post: introPost)
                
                try await UserManager.shared.addTiToCreated(tiID: id, currentUserUID: creatorUID)
                
                print("✅🔥🥬🔼 Success: uploaded [ introPost ] 🔼🥬🔥✅")
                completion(true)
                return true
                
            } catch {
                print("❌🔥🍇🔼 Error: Couldn't upload d1Ti 🔼🍇🔥❌")
                completion(false)
                
                return false
            }
        }
        
        return false
    }
    
    //New
    func createD2Ti(
        id: String,
        title: String, description: String, tiThumbnailData: Data?,
        creatorUID: String, tiAdminsUIDs: [String],
        
        //right
        rsUserUID : String          ,
        rsLevel1UsersUIDs : [String]?,
        rsLevel2UsersUIDs : [String]?,
        rsLevel3UsersUIDs : [String]?,
        
        rsVerticalListAccess: VerticalListAccess,
        
        //left
        lsUserUID : String          ,
        lsLevel1UsersUIDs : [String]?,
        lsLevel2UsersUIDs : [String]?,
        lsLevel3UsersUIDs : [String]?,
        
        lsVerticalListAccess: VerticalListAccess,
        
        completion: @escaping (Error?) -> Void ) async {
        
        let thumbnailURLString: String? = await ImageManager.shared.saveImage(imageData: tiThumbnailData,
                                                       thumbnailFor: .TI,
                                                                     thumbnailForTypeId: id)
        
        guard let thumbnailURLString = thumbnailURLString else {
            print("❌🔥🍒🔼📸 Error Creating D2Ti: Couldn't upload Image 📸🔼🍒🔥❌")
            return
//            completion()
        }

        let introPost = Post(id: id, title: "INTRO", type: .text, text: description, imageURL: nil, videoURL: nil, creatorUID: creatorUID, dateCreated: Date.now, addedToChain: nil
        )
        
            let introChainLink = ChainLink(id: id, title: "INTRO", thumbnailURL: thumbnailURLString, creatorUID: creatorUID, addedFromVerticalListed: false)
        
        let d2Ti = TI(ID: id, title: title, description: description, thumbnailURL: thumbnailURLString, creatorUID: creatorUID, tiAdminsUIDs: tiAdminsUIDs,
                       rsUserUID: rsUserUID, rsLevel1UsersUIDs: rsLevel1UsersUIDs, rsLevel2UsersUIDs: rsLevel2UsersUIDs, rsLevel3UsersUIDs: rsLevel3UsersUIDs, rsVerticalListAccess: rsVerticalListAccess,
                       lsUserUID: lsUserUID, lsLevel1UsersUIDs: lsLevel1UsersUIDs, lsLevel2UsersUIDs: lsLevel2UsersUIDs, lsLevel3UsersUIDs: lsLevel3UsersUIDs, lsVerticalListAccess: lsVerticalListAccess)
        Task {
            do {
                try await TIManager.shared.createTI(ti: d2Ti)
                
                //TODO: - add Ti to current user's created Tis
                
                print("✅🔥🥬🔼 Success: uploaded d1Ti 🔼🥬🔥✅")
                
                //chain
                ChainLinkManager.shared.createChainLink(tiID: id, chainLink: introChainLink) { error in
                    if error == nil {
                        completion(nil)
                    } else {
                        completion(error)
                    }
                }
                
                print("✅🔥🥬🔼 Success: uploaded d1Ti 🔼🥬🔥✅")
                
                //post
                try await PostManager.shared.createPost(tiID: id, post: introPost)
                
                try await UserManager.shared.addTiToCreated(tiID: id, currentUserUID: creatorUID)

                
                print("✅🔥🥬🔼 Success: uploaded [ introPost ] 🔼🥬🔥✅")
                completion(nil)
                return true
                
            } catch {
                print("❌🔥🍇🔼 Error: Couldn't upload d1Ti 🔼🍇🔥❌")
                completion(error)
                return false
            }
        }
    }
}
