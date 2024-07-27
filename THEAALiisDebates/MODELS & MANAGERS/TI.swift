////
////  THEAALiiInteractionModel.swift
////  TheAaliiDebates
////
////  Created by Ali Abraham on 5/30/23.
////
//
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

enum TIType   : String, Codable { case post = "post",  d1 = "D-1", d2 = "D-2" }
enum VerticalListAccess: String, Codable { case open = "open", restricted = "restricted", closed = "closed" }
enum LeftOrRight { case left, right }

struct TI: Identifiable, Codable, Hashable {
    
    @DocumentID var documentID: String?
    var id: String
    
    let title: String
    var description: String                 //FIXME: - Remove
    var thumbnailURL: String?
    let dateCreated: Date

    //FIXME: - change order
    var tiType: TIType = .d1
    
    var tiTotalVotes: Int = 0
    var tiAbsoluteVotes: Int = 0
    var tiUpVotes   : Int = 0
    var tiDownVotes : Int = 0
    
    
    let creatorUID: String
    var tiAdminsUIDs: [String]
    
    
    // --- Chain --- \\
    let introPostID: String //same as the TI ID
    var chainLinks: [String: [String]]? = nil

    
    // - Right Side - //
    var rightSideChain: [String] = []

    var rsUserUID        :  String
    var rsLevel1UsersUIDs       : [String]? = nil //Team (Main Debaters) (max 3 + user = 4 )
    
    var rsLevel2UsersUIDs       : [String]? = nil //Support (Secondary )
    var rsLevel3UsersUIDs       : [String]? = nil //Admins  (Tertiary  )

    var rsSponsorsUIDs          : [String: Int]? = nil // [ SponsorUID : $400 ]
    
    var rsVerticalListAccess: VerticalListAccess = .open
    
    // - Left Side - //
    var leftSideChain: [String]? = nil

    var lsUserUID        :  String?
    var lsLevel1UsersUIDs       : [String]? = nil //Team (Main Debaters) (max 3 + user = 4 )
    
    var lsLevel2UsersUIDs       : [String]? = nil //Support (secondary )
    var lsLevel3UsersUIDs       : [String]? = nil //Admins  (Tertiary  )
    
    var lsSponsorsUIDs          : [String: Int]? = nil // [ SponsorUID : $400 ]
    
    var lsVerticalListAccess: VerticalListAccess? = nil
    
    var tiObserversUIDs: [String] = []

    
    
    //MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case id                 = "id"
        case title              = "title"
        case description        = "description"
        case thumbnailURL       = "thumbnail_url"
        case dateCreated        = "date_created"
        
        case tiType             = "ti_type"
        
        case tiTotalVotes    = "ti_total_votes"
        case tiAbsoluteVotes = "ti_absolute_votes"
        case tiUpVotes       = "ti_up_votes"
        case tiDownVotes     = "ti_down_votes"

        case introPostID        = "intro_post_id"
        case chainLinks         = "chain_links"
        case creatorUID         = "creator_uid"
        case tiAdminsUIDs       = "ti_admins_uids"

        // right side Chain
        case rightSideChain       = "right_side_chain"
        case rsUserUID            = "rs_user_uid"
        
        case rsLevel1UsersUIDs    = "rs_level_1_users_uids"
        case rsLevel2UsersUIDs    = "rs_level_2_users_uids"
        case rsLevel3UsersUIDs    = "rs_level_3_users_uids"
        
        case rsSponsorsUIDs       = "rs_sponsors_uids"
        case rsVerticalListAccess = "rs_vertical_list_access"
        
        // left side chain
        case leftSideChain        = "left_side_chain"
        case lsUserUID            = "ls_user_uid"
        
        case lsLevel1UsersUIDs    = "ls_level_1_users_uids"
        case lsLevel2UsersUIDs    = "ls_level_2_users_uids"
        case lsLevel3UsersUIDs    = "ls_level_3_users_uids"
        
        case lsSponsorsUIDs       = "ls_sponsors_uids"
        case lsVerticalListAccess = "ls_vertical_list_access"
        
        case tiObserversUIDs      = "ti_observers_uids"
    }
    
    
    //MARK: Decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.thumbnailURL = try container.decodeIfPresent(String.self, forKey: .thumbnailURL)
        self.introPostID = try container.decode(String.self, forKey: .introPostID)
        
        self.creatorUID = try container.decode(String.self, forKey: .creatorUID)
        self.tiAdminsUIDs = try container.decode([String].self, forKey: .tiAdminsUIDs)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        
        self.tiType = try container.decode(TIType.self, forKey: .tiType)
        self.chainLinks = try container.decodeIfPresent([String: [String]].self, forKey: .chainLinks)

        
        //Votes
        self.tiTotalVotes = try container.decode(Int.self, forKey: .tiTotalVotes)
        self.tiAbsoluteVotes = try container.decode(Int.self, forKey: .tiAbsoluteVotes)
        self.tiUpVotes = try container.decode(Int.self, forKey: .tiUpVotes)
        self.tiDownVotes = try container.decode(Int.self, forKey: .tiDownVotes)
        
        //right side
        self.rightSideChain = try container.decode([String].self, forKey: .rightSideChain)
        self.rsUserUID = try container.decode(String.self, forKey: .rsUserUID)
        self.rsLevel1UsersUIDs = try container.decodeIfPresent([String].self, forKey: .rsLevel1UsersUIDs)
        self.rsLevel2UsersUIDs = try container.decodeIfPresent([String].self, forKey: .rsLevel2UsersUIDs)
        self.rsLevel3UsersUIDs = try container.decodeIfPresent([String].self, forKey: .rsLevel3UsersUIDs)
        
        self.rsSponsorsUIDs = try container.decodeIfPresent([String: Int].self, forKey: .rsSponsorsUIDs)
        self.rsVerticalListAccess = try container.decode(VerticalListAccess.self, forKey: .rsVerticalListAccess)

        
        //left side
        self.leftSideChain = try container.decodeIfPresent([String].self, forKey: .leftSideChain)
        self.lsUserUID = try container.decodeIfPresent(String.self, forKey: .lsUserUID)
        self.lsLevel1UsersUIDs = try container.decodeIfPresent([String].self, forKey: .lsLevel1UsersUIDs)
        self.lsLevel2UsersUIDs = try container.decodeIfPresent([String].self, forKey: .lsLevel2UsersUIDs)
        self.lsLevel3UsersUIDs = try container.decodeIfPresent([String].self, forKey: .lsLevel3UsersUIDs)
        
        self.lsSponsorsUIDs = try container.decodeIfPresent([String: Int].self, forKey: .lsSponsorsUIDs)
        self.lsVerticalListAccess = try container.decodeIfPresent(VerticalListAccess.self, forKey: .lsVerticalListAccess)

        self.tiObserversUIDs = try container.decode([String].self, forKey: .tiObserversUIDs)
    }

    //MARK: Encoder
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.description, forKey: .description)
        try container.encode(self.thumbnailURL, forKey: .thumbnailURL)
        try container.encode(self.introPostID, forKey: .introPostID)
        try container.encode(self.creatorUID, forKey: .creatorUID)
        try container.encode(self.tiAdminsUIDs, forKey: .tiAdminsUIDs)

        try container.encode(self.dateCreated, forKey: .dateCreated)
        try container.encode(self.tiType, forKey: .tiType)
        try container.encodeIfPresent(self.chainLinks, forKey: .chainLinks)

        
        try container.encode(self.tiTotalVotes, forKey: .tiTotalVotes)
        try container.encode(self.tiAbsoluteVotes, forKey: .tiAbsoluteVotes)
        try container.encode(self.tiUpVotes, forKey: .tiUpVotes)
        try container.encode(self.tiDownVotes, forKey: .tiDownVotes)

        
        //right side
        try container.encode(self.rightSideChain, forKey: .rightSideChain)
        try container.encode(self.rsUserUID, forKey: .rsUserUID)
        try container.encodeIfPresent(self.rsLevel1UsersUIDs, forKey: .rsLevel1UsersUIDs)
        try container.encodeIfPresent(self.rsLevel2UsersUIDs, forKey: .rsLevel2UsersUIDs)
        try container.encodeIfPresent(self.rsLevel3UsersUIDs, forKey: .rsLevel3UsersUIDs)

        try container.encodeIfPresent(self.rsSponsorsUIDs, forKey: .rsSponsorsUIDs)
        try container.encode(self.rsVerticalListAccess, forKey: .rsVerticalListAccess)

        //left side
        try container.encodeIfPresent(self.leftSideChain, forKey: .leftSideChain)
        try container.encodeIfPresent(self.lsUserUID, forKey: .lsUserUID)
        try container.encodeIfPresent(self.lsLevel1UsersUIDs, forKey: .lsLevel1UsersUIDs)
        try container.encodeIfPresent(self.lsLevel2UsersUIDs, forKey: .lsLevel2UsersUIDs)
        try container.encodeIfPresent(self.lsLevel3UsersUIDs, forKey: .lsLevel3UsersUIDs)

        try container.encodeIfPresent(self.lsSponsorsUIDs, forKey: .lsSponsorsUIDs)
        try container.encodeIfPresent(self.lsVerticalListAccess, forKey: .lsVerticalListAccess)
        
        try container.encode(self.tiObserversUIDs, forKey: .tiObserversUIDs)
    }
    
    //MARK: - [ inits ] -
    // - create init - //
    // .d1
    /// --- Creates a D-1 TI init ---

    init(ID: String, title: String, description: String, thumbnailURL: String?,
         creatorUID: String, tiAdminsUIDs: [String],
         
         rsLevel1UsersUIDs : [String]?,
         rsLevel2UsersUIDs : [String]?,
         rsLevel3UsersUIDs : [String]?,
         
         rsVerticalListAccess: VerticalListAccess
    ) {
        self.documentID = ID
        self.id = ID
        self.title = title; self.description = description;
        self.thumbnailURL = thumbnailURL;
        self.dateCreated = Date.now  //FIXME: Date()
        
        self.tiType = .d1

        self.introPostID = ID
        self.creatorUID = creatorUID; self.tiAdminsUIDs = tiAdminsUIDs
        //chain
        self.rightSideChain = []
        self.rsUserUID = creatorUID
        self.rsLevel1UsersUIDs = rsLevel1UsersUIDs
        
        self.rsVerticalListAccess = rsVerticalListAccess
        
        self.tiObserversUIDs = [creatorUID]
    }
    
    //.d2
    /// --- Creates a D-2 TI init ---

    init(ID: String, title: String, description: String, thumbnailURL: String?,
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
         
         lsVerticalListAccess: VerticalListAccess
    ) {
        self.documentID = ID
        self.id = ID
        self.title = title; self.description = description;
        self.thumbnailURL = thumbnailURL;
        self.dateCreated = Date.now  //FIXME: Date()
        
        self.tiType = .d2
        
        
        self.introPostID = ID
        self.creatorUID = creatorUID; self.tiAdminsUIDs = tiAdminsUIDs
        
        //right Side
        self.rightSideChain = []
        self.rsUserUID = rsUserUID
        self.rsLevel1UsersUIDs = rsLevel1UsersUIDs
        self.rsLevel2UsersUIDs = rsLevel2UsersUIDs
        self.rsLevel3UsersUIDs = rsLevel3UsersUIDs

        self.rsVerticalListAccess = rsVerticalListAccess
        
        //left side
        self.leftSideChain = []
        self.lsUserUID = lsUserUID
        self.lsLevel1UsersUIDs = lsLevel1UsersUIDs
        self.lsLevel2UsersUIDs = lsLevel2UsersUIDs
        self.lsLevel3UsersUIDs = lsLevel3UsersUIDs

        self.lsVerticalListAccess = lsVerticalListAccess
        
        self.tiObserversUIDs = [creatorUID]
    }
    
    // - Read init - //
    /// --- Reads [  TI ]  ---
    ///
    init(ID: String, title: String, description: String, thumbnailURL: String?, introPostID: String,
         creatorUID: String, tiAdminsUIDs: [String], dateCreated: Date,
         tiType: TIType, 
         chainLinks: [String: [String]]?,
         
         //ti Votes
         tiTotalVotes   : Int,
         tiAbsoluteVotes: Int,
         tiUpVotes      : Int,
         tiDownVotes    : Int,
         
         //right Side
         rightSideChain: [String]     ,
         rsUserUID : String           ,
         rsLevel1UsersUIDs : [String]?,
         rsLevel2UsersUIDs : [String]?,
         rsLevel3UsersUIDs : [String]?,
         
         rsSponsorsUIDs : [String: Int]? ,
         rsVerticalListAccess: VerticalListAccess,
         
         
         leftSideChain: [String],
         lsUserUID : String?          ,
         lsLevel1UsersUIDs : [String]?,
         lsLevel2UsersUIDs : [String]?,
         lsLevel3UsersUIDs : [String]?,
         
         lsSponsorsUIDs: [String: Int]? ,
         lsVerticalListAccess: VerticalListAccess,
         
         tiObserversUIDs: [String]
    ) {
        self.documentID = ID
        self.id = ID
        self.title = title; self.description = description;
        self.thumbnailURL = thumbnailURL; 
        
        self.tiType = tiType
        self.chainLinks = chainLinks
        
        self.tiTotalVotes    = tiTotalVotes
        self.tiAbsoluteVotes = tiAbsoluteVotes
        self.tiUpVotes       = tiUpVotes
        self.tiDownVotes     = tiDownVotes

        self.introPostID = introPostID
        self.creatorUID = creatorUID
        self.tiAdminsUIDs = tiAdminsUIDs
        self.dateCreated = dateCreated
        
        //right Side
        self.rightSideChain = rightSideChain
        self.rsUserUID = rsUserUID
        self.rsLevel1UsersUIDs = rsLevel1UsersUIDs
        self.rsLevel2UsersUIDs = rsLevel2UsersUIDs
        self.rsLevel3UsersUIDs = rsLevel3UsersUIDs

        self.rsSponsorsUIDs = rsSponsorsUIDs
        self.rsVerticalListAccess = rsVerticalListAccess
        
        //left side
        self.leftSideChain = leftSideChain
        self.lsUserUID = lsUserUID
        self.lsLevel1UsersUIDs = lsLevel1UsersUIDs
        self.lsLevel2UsersUIDs = lsLevel2UsersUIDs
        self.lsLevel3UsersUIDs = lsLevel3UsersUIDs

        self.lsSponsorsUIDs = lsSponsorsUIDs
        self.lsVerticalListAccess = lsVerticalListAccess
        
        self.tiObserversUIDs = [creatorUID]
    }
}















//MARK: - [ MANAGER ] ----------- -
final class TIManager {
    
    static let shared = TIManager()
    private init() { }
    
    //TI Document Location
    private let TICollection: CollectionReference = Firestore.firestore().collection("THEAALii_Interactions") //TIs
    private func TIDocument(tiID: String) -> DocumentReference { TICollection.document(tiID) }
    
    // - 1. Create
    func createTI(ti: TI) async throws {
        try TIDocument(tiID: ti.id).setData(from: ti, merge: false)
    }
    
    // - 2. Read
    func fetchTI(tiID: String) async throws -> TI? {
        try await TIDocument(tiID: tiID).getDocument(as: TI.self)
    }
    func getTi(tiID: String, completion: @escaping (Result<TI, Error>) -> Void) {
        TIDocument(tiID: tiID).getDocument(as: TI.self) { result in
            switch result {
                
            case .success(let ti):
                print("✅⬇️🫖💎⚛️ Success getting Ti🫖💎 ⚛️💎🫖⬇️✅")
                completion(.success(ti))
                
            case .failure(let error):
                print("❌⬇️🫖💎⚛️ Error getting Ti🫖💎: \(error.localizedDescription) ⚛️💎🫖⬇️❌")
                completion(.failure(error))
                
            }
        }
    }
    
    // - 3. Update
    
    //MARK: add post to chain
    func addToChain(tiID: String, cLinkID: String, rightOrLeft: LeftOrRight) async throws {
//        var chainData = [String: Any]()
//        
//        if rightOrLeft == .right {
//            chainData = [ TI.CodingKeys.rightSideChain.rawValue : FieldValue.arrayUnion([cLinkID]) ]
//        } else if rightOrLeft == .left {
//            chainData = [ TI.CodingKeys.leftSideChain.rawValue : FieldValue.arrayUnion([cLinkID]) ]
//        }
//        
//        try await TIDocument(tiID: tiID).updateData(chainData)
        
        if rightOrLeft == .right {
            
            try await TIDocument(tiID: tiID).updateData([ TI.CodingKeys.rightSideChain.rawValue : FieldValue.arrayUnion([cLinkID]) ])
        } else if rightOrLeft == .left {
            
            try await TIDocument(tiID: tiID).updateData([TI.CodingKeys.leftSideChain.rawValue : FieldValue.arrayUnion([cLinkID])])

        }
    }
    //TODO: - 
    func addLinkToChain(tiID: String, chainLinkID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }
    
    //FIXME: - This is all wrong (Edit Admins) Obsolete
    //MARK: Edit Admins
    func editAdmins(tiID: String, userUID: String, chainDirection: LeftOrRight , addOrRemove: AddOrRemove) async throws {
        
        var adminsData = [String: Any]()
        
        //FIXME: Removing Admins ??????? (remove
        if chainDirection == .right {
            
            if addOrRemove == .add {
                adminsData = [ TI.CodingKeys.rsLevel1UsersUIDs.rawValue : FieldValue.arrayUnion([userUID])  ]
            } else if addOrRemove == .remove {
                adminsData = [ TI.CodingKeys.rsLevel1UsersUIDs.rawValue : FieldValue.arrayRemove([userUID]) ]
            }
            
        } else if chainDirection == .left {
            
            if addOrRemove == .add {
                adminsData = [ TI.CodingKeys.lsLevel1UsersUIDs.rawValue : FieldValue.arrayUnion([userUID])  ]
            } else if addOrRemove == .remove {
                adminsData = [ TI.CodingKeys.lsLevel1UsersUIDs.rawValue : FieldValue.arrayRemove([userUID]) ]
            }
        }
        
        try await TIDocument(tiID: tiID).updateData(adminsData)
    }
    
    func updateObserversUIDs(tiUID: String, currentUserUID: String, addOrRemove: AddOrRemove) async throws {
        if addOrRemove == .add {
            try await TIDocument(tiID: tiUID).updateData([TI.CodingKeys.tiObserversUIDs.rawValue : FieldValue.arrayUnion([currentUserUID])])
        } else {
            try await TIDocument(tiID: tiUID).updateData([TI.CodingKeys.tiObserversUIDs.rawValue : FieldValue.arrayRemove([currentUserUID])])
        }
    }
    
}
