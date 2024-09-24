//
//  VotesModel.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 9/6/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct PostVotesModel: Codable, Hashable, Equatable {
    
    var totalVotes: Int = 0
    var upVotes   : Int = 0
    var downVotes : Int = 0
    var upVotersUIDsArray  : [String] = []
    var downVotersUIDsArray: [String] = []
    
    static func ==(lhs: PostVotesModel, rhs: PostVotesModel) -> Bool {
        lhs.totalVotes == rhs.totalVotes && lhs.upVotersUIDsArray == rhs.upVotersUIDsArray && lhs.downVotersUIDsArray == rhs.downVotersUIDsArray
    }
    
    enum CodingKeys: String, CodingKey {
                
        //Voting
        case totalVotes = "total_votes", upVotes = "up_votes", downVotes = "down_votes"
        case upVotersUIDsArray = "up_voters_uid", downVotersUIDsArray = "down_voters_uid"
    }
    
    //MARK: Encoder
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.totalVotes         , forKey: .totalVotes         )
        try container.encode(self.upVotes            , forKey: .upVotes            )
        try container.encode(self.downVotes          , forKey: .downVotes          )
        try container.encode(self.upVotersUIDsArray  , forKey: .upVotersUIDsArray  )
        try container.encode(self.downVotersUIDsArray, forKey: .downVotersUIDsArray)

    }
    
    //MARK: Decode
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        //Votes
        self.totalVotes = try container.decode(Int.self, forKey: .totalVotes)
        self.upVotes    = try container.decode(Int.self, forKey: .upVotes)
        self.downVotes  = try container.decode(Int.self, forKey: .downVotes)
        self.upVotersUIDsArray   = try container.decode([String].self, forKey: .upVotersUIDsArray)
        self.downVotersUIDsArray = try container.decode([String].self, forKey: .downVotersUIDsArray)
    }
    
    init(totalVotes: Int, upVotes: Int, downVotes: Int, upVotersUIDsArray: [String], downVotersUIDsArray: [String]) {
        self.totalVotes = totalVotes
        self.upVotes = upVotes
        self.downVotes = downVotes
        self.upVotersUIDsArray = upVotersUIDsArray
        self.downVotersUIDsArray = downVotersUIDsArray
    }
}







final class PostVotesManager {
    
    static let shared = PostVotesManager()
    private init() { }
    
    // ,Post Document Location
    private let TICollection: CollectionReference = Firestore.firestore().collection("THEAALii_Interactions")
    func TIDocument(tiID: String) -> DocumentReference { TICollection.document(tiID) }
    func PostDocument(tiID: String, postID: String) -> DocumentReference {
        TICollection.document(tiID).collection("Posts").document(postID)
    }
    private func VLPostDocument(tiID: String, chainLinkID: String, postID: String) -> DocumentReference {
        TICollection.document(tiID).collection("Chain_Links").document(chainLinkID).collection("Vertical_List_Posts").document(postID)
    }
    
    
    //Read
    func fetchVotes(tiID: String, chainLinkID: String, postID: String) async throws -> PostVotesModel? {
        try await VLPostDocument(tiID: tiID, chainLinkID: chainLinkID, postID: postID).getDocument(as: PostVotesModel.self)
    }
}
