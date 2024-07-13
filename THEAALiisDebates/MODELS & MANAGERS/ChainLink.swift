//
//  ChainLink.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 5/31/24.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


struct ChainLink: Identifiable, Codable {
    
    @DocumentID var documentID: String?
    var id: String                         //same as the post
    var title    :  String
    var thumbnailURL :  String?
    //Vertical list info
    var verticalList : [String] = []
    var listAccess   :  String?
    var listTitle    :  String?
    
    ///Create ChainLink
    init(id: String, title: String, thumbnailURL: String?) {
        self.id = id
        self.title = title
        self.thumbnailURL = thumbnailURL
    }
    ///Read ChainLink
    init(id: String, title: String, thumbnailURL: String?, verticalList: [String], listAccess: String?, listTitle: String?) {
        self.id           = id
        self.title        = title
        self.thumbnailURL = thumbnailURL
        self.verticalList = verticalList
        self.listAccess   = listAccess
        self.listTitle    = listTitle
    }
    
    //MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case id                 = "id"
        case title              = "title"
        case thumbnailURL       = "thumbnail_url"
        
        case verticalList       = "vertical_list"
        case listAccess         = "list_access"
        case ListTitle          = "list_title"

    }
    
    //MARK: Encoder
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.id          , forKey: .id          )
        try container.encode(self.title, forKey: .title)
        try container.encode(self.thumbnailURL, forKey: .thumbnailURL)
        //Vertical List
        try container.encode(self.verticalList       , forKey: .verticalList)
        try container.encodeIfPresent(self.listAccess, forKey: .listAccess  )
        try container.encodeIfPresent(self.listTitle , forKey: .ListTitle   )
    }
    
    //MARK: Decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)

        self.title = try container.decode(String.self, forKey: .title)
        self.thumbnailURL = try container.decode(String.self, forKey: .thumbnailURL)
        //Vertical List
        self.verticalList = try container.decode([String].self,        forKey: .verticalList)
        self.listAccess   = try container.decodeIfPresent(String.self, forKey: .listAccess  )
        self.listTitle    = try container.decodeIfPresent(String.self, forKey: .ListTitle   )
    }
}






















//MARK: - TIT Chain Manager -------

final class ChainLinkManager {
    
    static let shared = ChainLinkManager()
    private init() { }
    
    private let tiCollection: CollectionReference = Firestore.firestore().collection("THEAALii_Interactions")
    private func chainDocument(tiID: String, chainID: String) -> DocumentReference {
        tiCollection.document(tiID).collection("Chain_Links").document(chainID)
    }
    
    //MARK: - 1. Create
    func createChainLink(tiID: String, chainLink: ChainLink) async throws {
        try chainDocument(tiID: tiID, chainID: chainLink.id).setData(from: chainLink, merge: false)
    }
    func createChainLink(tiID: String, chainLink: ChainLink, completion: @escaping (Error?) -> Void) {
        do {
            try chainDocument(tiID: tiID, chainID: chainLink.id).setData(from: chainLink, merge: false) { error in
                
                if let error = error {
                    // Handle the error within the closure
                    print("❌🔼⛓️🍅 Error Creating Chain Link: \(error.localizedDescription) 🍅⛓️🔼❌")
                    completion(error)
                } else {
                    print("✅🔼🔗☘️ Created Chain Link ☘️🔗🔼✅")
                    completion(nil)
                }
            }
        } catch {
            // Handle the initial error
            print("❌🔼🔗🍅 Error Creating Chain Link: \(error.localizedDescription) 🍅🔗🔼❌")
            completion(error)
        }
        
    }
    
    
    //MARK: - 2. Read
//    func getChainLink(tiID: String, chainID: String) async throws -> TITChainLinkModel {
//        let snapShot = try await ChainDocument(tiID: tiID, chainID: chainID).getDocument()
//
//        guard let data = snapShot.data() else {
//            print("❌🤬🔗 Error: Couldn't getTITChainLink()🔗 data from snapshot 🔗🤬❌")
//            throw URLError(.badServerResponse)
//        }
//        //NON-Optional
//        guard
//            let id = data["id"] as? String,
//            let videoID = data["video_id"] as? String
//        else {
//            print("❌🤬🔗 Error: Couldn't read getTITChainLink()🔗 data components 🔗🤬❌")
//            throw URLError(.badServerResponse)
//        }
//        //Optional
//        let responseList = data["response_list"] as? [String] ?? []
//
//        return TITChainLinkModel(id: id, postID: videoID, verticalList: responseList)
//    }
    //Coding Keys
    func getChainLink(tiID: String, chainID: String, completion: @escaping (Result<ChainLink, Error>) -> Void) {
        chainDocument(tiID: tiID, chainID: chainID).getDocument(as: ChainLink.self) { result in
            switch result {
            case .success(let chainLink):
                completion(.success(chainLink))
            case .failure(let error):
                print("🆘⬇️🔗💥 Error getting chain link: \(error.localizedDescription) 💥⛓️‍💥⬇️❌")
                completion(.failure(error))
            }
        }
    }
    
    //3. Update
    func appendPostToVerticalList(tiID: String, chainLinkID: String, postID: String) {
        
    }
    func addPostToVerticalList(tiID: String, chainLinkID: String, postID: String, completion: @escaping (Error?)->Void) {
        
        chainDocument(tiID: tiID, chainID: chainLinkID).updateData([ChainLink.CodingKeys.verticalList.rawValue : FieldValue.arrayUnion([postID] )]) { error in
            
            if let error {
                print("🆘🔺⛓️☎️ ERROR adding post to vertical list: \(error.localizedDescription) ☎️⛓️🔺🆘")
                completion(error)
            } else {
                print("✅⛓️🥒 Success added POST to VERTICAL LIST  🥒⛓️✅")
                completion(nil)
            }
        }
    }
    
    //4. Delete
}
