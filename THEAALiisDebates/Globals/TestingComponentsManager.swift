//
//  TestingComponentsManager.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 4/8/23.
//

import Foundation

final class TestingModels {
    

    
    //MARK: - TITs
    var tiFromDBID1 = "A194AC04-93FB-49D1-8F7A-DE1F9F468F79"
    var tiFromDBID2 = "2A01BA5E-E8E1-4588-857F-DEE0A8A3FB8B"
    var tiFromDBID3 = "2D449F13-A21E-4CCF-BC66-D873BFB41735"
    var tiFromDBID4 = "75C67989-003A-4190-8C6C-996EC89713F1"
    var tiFromDBID5 = "CB62521F-AE75-4D1C-960B-8079DFB81EA7"

    
    func tiFromFB(completion: @escaping (TI?) -> Void) {
        TIManager.shared.getTi(tiID: self.tiFromDBID2) { result in
            switch result {
            case .success(let ti):
                completion( ti )
            case .failure(_):
                completion( nil )//self.testTI0 )
            }
        }
    }
    
    let testingTIModel = TIModel(
//        id: "TIT_tutorial_Interaction_ID",
        id: "10A47E3F-5659-40C9-B14F-A0428390BDFA",
        //10A47E3F-5659-40C9-B14F-A0428390BDFA
        name: "THEAALii's Interaction Technology (TIT)\n Tutorial",
        description: "Welcome to THEAALii Debates.",
        thumbnailURLString: "https://images.ctfassets.net/ooa29xqb8tix/J6KiaOqQyBtSa84hx6fuI/2cd1d475743a2a42c8643b2a69e88547/Advanced_React_Hooks_800x600_cover.png?w=400&q=50",
        creatorUID: "f2i3iO0pSWWn11WlkXrf0gILwyw2",
        administratorsUID: ["person_id", "person_id_2", "person_id_3", "person_id_4", "person_id_5"],
        interactionChain: []//["testingChainLink1", "whatever" ,"THree"]
        )
    
    //MARK: - Chain Link
    let testChainLink = TITChainLinkModel(id: "test chain L ID", postID: "testing bra", verticalList: ["1", "w", "h"])
    let testTIChainL = TITChainLModel(id: "id", videoId: "vi", videoTitle: "video title",
                                      videoThumbnail: "https://images.ctfassets.net/ooa29xqb8tix/J6KiaOqQyBtSa84hx6fuI/2cd1d475743a2a42c8643b2a69e88547/Advanced_React_Hooks_800x600_cover.png?w=400&q=50",
                                      responseList: [])
    
    //MARK: - tit Videos
    let titVideo = TIVideoModel(id: "testing bra",
                                 videoURL: "https://firebasestorage.googleapis.com/v0/b/theaaliidebates.appspot.com/o/Videos%2Fvideo1.mp4?alt=media&token=a0cb419d-5e41-47ef-bcf7-ad2d0ff0647c",
                                 thumbnail: "https://images.ctfassets.net/ooa29xqb8tix/J6KiaOqQyBtSa84hx6fuI/2cd1d475743a2a42c8643b2a69e88547/Advanced_React_Hooks_800x600_cover.png?w=400&q=50",
                                 creatorID: "test creator",
                                 name: "Testing tit video",
                                description: "description for testing tit Video", chainLId: "wow")
    
    let titVideo1 = TIVideoModel(id: "mea2", videoURL: "https://firebasestorage.googleapis.com/v0/b/theaaliidebates.appspot.com/o/Videos%2Fvideo1.mp4?alt=media&token=a0cb419d-5e41-47ef-bcf7-ad2d0ff0647c",
                                  thumbnail: "https://hws.dev/paul.jpg",
                                  creatorID: "creator",
                                  name: "Testing TIT Video 1",
                                 description: "This TIT Video is for testing purposes only", chainLId: "wow2"
                                  )
        
    
//    let user1 = UserModel(userUID: "meaw", email: "meaw@paw", name: "Kat Katerson", bio: "Likes dogs!")
    //MARK: - USER
    let user1 = UserModel(userUID: "meaw", email: "meaw@paw", dateJoined: Date.now,
                      displayName: "Kat Katerson 1", bio: "Hates dogs!",
                      profileImageURLString: TestingImagesVideos().imageURLStringDesignnCode,
                      userLabel: "Observer",
                      createdTIsIDs: [], participatedTIsIDs: [],
                      followingUIDs: [], followersUIDs: [],
                          savedUsersUIDs: ["llll", "kkk", "a", "k", "jj"], observingTIs: [])

    let user2 = UserModel(userUID: "Dog Mc Dogin 02", email: "meaw@paw", dateJoined: Date.now,
                      displayName: "Dog Mc Dogin 02", bio: "Hates Cats!",
                          profileImageURLString: TestingImagesVideos().imageURL,
                      userLabel: "Observer",
                      createdTIsIDs: [], participatedTIsIDs: [],
                      followingUIDs: [], followersUIDs: [],
                          savedUsersUIDs: ["llll", "kkk", "a", "k", "jj"], observingTIs: [])

    let user3 = UserModel(userUID: "Dog Mc Dogin", email: "meaw@paw", dateJoined: Date.now,
                      displayName: "Miki Mousin 003", bio: "Hates Everyone",
                      profileImageURLString: TestingImagesVideos().imageURLStringpaulI,
                      userLabel: "Creator",
                      createdTIsIDs: [], participatedTIsIDs: [],
                      followingUIDs: [], followersUIDs: [],
                      savedUsersUIDs: ["llll", "kkk", "a", "k", "jj"], observingTIs: [])
    
    let user4nil = UserModel(userUID: "Dog Mc Dogin", email: "meaw@paw", dateJoined: Date.now,
                      displayName: "Miki Mousin 003", bio: "Hates Everyone",
                      profileImageURLString: nil,
                      userLabel: "Creator",
                      createdTIsIDs: [], participatedTIsIDs: [],
                      followingUIDs: [], followersUIDs: [],
                      savedUsersUIDs: ["llll", "kkk", "a", "k", "jj"], observingTIs: [])
    
    var userArray : [UserModel] { [user1, user2, user3, user4nil] }
    
    let userMeUID: String = "kJchOu2tJCenXU4ZpXoAxgCYfJN2"
    
    //MARK: - TI
    let testTI0 = TI(ID: "id", title: "testing TI title", description: "testing ti Description", thumbnailURL: "https://images.ctfassets.net/ooa29xqb8tix/J6KiaOqQyBtSa84hx6fuI/2cd1d475743a2a42c8643b2a69e88547/Advanced_React_Hooks_800x600_cover.png?w=400&q=50", creatorUID: "uid", tiAdminsUIDs: ["sdf", "asda"], rsLevel1UsersUIDs: ["asd", "sdfdas"], rsLevel2UsersUIDs: [], rsLevel3UsersUIDs: [], rsVerticalListAccess: .open)
    
    let testTI1nil = TI(ID: "id", title: "testing TI 11 title", description: "testing TI 11 des", thumbnailURL: nil, creatorUID: "uid", tiAdminsUIDs: ["sadf"],
                        rsUserUID: "uid", rsLevel1UsersUIDs: ["asdfa"], rsLevel2UsersUIDs: [], rsLevel3UsersUIDs: [], rsVerticalListAccess: .open,
                        lsUserUID: "uid2", lsLevel1UsersUIDs: ["oooo", "ppp"], lsLevel2UsersUIDs: [], lsLevel3UsersUIDs: [], lsVerticalListAccess: .restricted)
    
    let testTId2 = TI(ID: "id", title: "test TI .d2", description: ".d2 description", thumbnailURL: nil, creatorUID: "BXnHfiEaIQZiTcpvWs0bATdAdJo1", tiAdminsUIDs: ["V7PM9BXAcwetP8ZeoV70619zpcF2"], rsUserUID: "rs uid", rsLevel1UsersUIDs: nil, rsLevel2UsersUIDs: nil, rsLevel3UsersUIDs: nil, rsVerticalListAccess: .open, lsUserUID: "ls uid", lsLevel1UsersUIDs: nil, lsLevel2UsersUIDs: nil, lsLevel3UsersUIDs: nil, lsVerticalListAccess: .restricted)
    
}

final class TestingImagesVideos {
    
    //MARK: - Texts
    let text2 = " Intro to the app what the f is going on here man, woman, other creatures. what is going on here? you must answer"
    let text3 = " Intro to the app what the f is"
    let text = " Intro to the app what the f is going on here man, woman, other creatures."
    
    
    //MARK: - Images
    let imageURLStringpaulI = "https://hws.dev/paul.jpg"
    let imageURLStringDesignnCode = "https://images.ctfassets.net/ooa29xqb8tix/J6KiaOqQyBtSa84hx6fuI/2cd1d475743a2a42c8643b2a69e88547/Advanced_React_Hooks_800x600_cover.png?w=400&q=50"
    let imageURL = "https://firebasestorage.googleapis.com/v0/b/theaaliidebates.appspot.com/o/Profile_Images%2FuqxQtBAOl0Yj2msXUX1WNzgcBii1?alt=media&token=c182a322-7496-4d45-b788-d50e46c062bd"
    
    //MARK: - VIDEO
    let videoLink1 = "https://firebasestorage.googleapis.com/v0/b/theaaliidebates.appspot.com/o/Videos%2Fvideo1.mp4?alt=media&token=a0cb419d-5e41-47ef-bcf7-ad2d0ff0647c"
    let videoLink2 = "https://firebasestorage.googleapis.com/v0/b/theaaliidebates.appspot.com/o/Videos%2F4FA33DBB-17BF-407F-BC5D-1953FA2261FD?alt=media&token=1cc635f7-a095-4cff-a14f-bd2613c405a0"
}
