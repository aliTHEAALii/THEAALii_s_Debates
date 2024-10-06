//
//  User.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 2/14/23.
//

import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

enum userLabel {
    case creator, observer
}


//MARK: - User Model
struct UserModel: Codable, Equatable {
    
    @DocumentID var documentID: String?
    let dataJoined: Date
    var userUID: String = ""
    var email  : String = ""

    var displayName: String = ""
    var bio        : String = ""
    var profileImageURLString: String? = nil
    
    var userLabel: String = "Observer"
    
    var followingUIDs:     [String] = []
    var followersUIDs:     [String] = []
    
    var createdTIsIDs : [String] = []
    var participatedTIsIDs : [String] = []
    
    var savedUsersUIDs:     [String] = []
    var observingTIsIDs  :     [String]  = []
    
    //Equatable
    static func ==(lhs: UserModel, rhs: UserModel) -> Bool {
        lhs.userUID == rhs.userUID
    }

    //MARK: -  Coding Keys
    enum CodingKeys: String, CodingKey {
        case dataJoined = "date_joined"
        case userUID = "user_uid"
        case email = "email"
        
        case displayName = "display_name"
        case bio = "bio"
        case profileImageURLString = "profile_image_url"
        
        case userLabel = "user_label"
        
        case followingUIDs = "following_uids"
        case followersUIDs = "followers_uids"
        
        case createdTIsIDs = "created_tis_ids"      //FIXME: Check if it crashes the code!!!!!!!
        case participatedTIsIDs = "participated_tis_ids"
        
        case savedUsersUIDs = "saved_users_uids"
        case observingTIsIDs = "observing_tis_ids"
    }
    
    
    //MARK: init
    init(
        userUID: String  ,
        email:   String? ,
        dateJoined: Date ,
        
        displayName:           String  ,
        bio:                   String  ,
        profileImageURLString: String? ,
        userLabel:             String  ,
        
        createdTIsIDs:      [String] ,
        participatedTIsIDs: [String] ,
        
        followingUIDs:     [String] ,
        followersUIDs:     [String] ,
        
        savedUsersUIDs:    [String] ,
        observingTIs: [String]
    )
    {
        self.userUID = userUID
        self.email = email ?? ""
        self.dataJoined = dateJoined
        
        self.displayName = displayName
        self.bio = bio
        self.profileImageURLString = profileImageURLString
        self.userLabel = userLabel
        
        self.createdTIsIDs = createdTIsIDs
        self.participatedTIsIDs = participatedTIsIDs
        
        self.followingUIDs     = followingUIDs
        self.followersUIDs     = followersUIDs
        
        self.savedUsersUIDs    = savedUsersUIDs
        self.observingTIsIDs = observingTIs
    }
    
    
    //MARK: - Auth init
    init(authUser: AuthDataResultModel) {
        self.dataJoined = {
            guard let user = Auth.auth().currentUser else { return Date.now }
            return user.metadata.creationDate ?? Date.now
        }()
        self.userUID = authUser.uid
        self.email = authUser.email ?? ""
        self.profileImageURLString = authUser.photoUrl
        self.displayName = authUser.displayName ?? "No Name"
        self.bio = ""
        
        self.followingUIDs     = [String]()
        self.followersUIDs     = [String]()
        
        self.savedUsersUIDs    = [String]()
        self.observingTIsIDs = [String]()
    }
}

//MARK: - User Manager -
@MainActor
final class UserManager {
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection: CollectionReference = Firestore.firestore().collection("Users")
    private func userDocument(userUID: String) -> DocumentReference { userCollection.document(userUID) }
    
    //1. - Create
    func createNewUser(user: UserModel) async throws {
        print("✅😎 created User")
        try userDocument(userUID: user.userUID).setData(from: user, merge: false)
    }
    
    //2. - Read
    //2. - Read
    func getUser(userId: String) async throws -> UserModel? {
        guard !userId.isEmpty else { return nil }
        do {

            let user = try await userDocument(userUID: userId).getDocument(as: UserModel.self)
            print("🟢😀 Got User")
            return user
            
        } catch {
            print("🆘⏬😔 Error Getting User: \(error.localizedDescription)🆘")
            return nil
        }
    }
    func searchUsers(query: String, completion: @escaping ([UserModel]) -> Void) {
        userCollection.whereField("display_name", isGreaterThanOrEqualTo: query)
            .whereField("display_name", isLessThanOrEqualTo: query + "\u{f8ff}")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("🆘🔍Error getting documents: \(error)❌")
                    completion([])
                } else {
                    let tiArray = querySnapshot?.documents.compactMap {
                        try? $0.data(as: UserModel.self)
                    } ?? []
                    completion(tiArray)
                }
            }
    }
//    func searchUsers(query: String, lastDocument: DocumentSnapshot? = nil, pageSize: Int = 5, completion: @escaping ([UserModel], DocumentSnapshot?) -> Void) {
//            var queryRef = Firestore.firestore().collection("users")
//            .whereField(UserModel.CodingKeys.displayName.rawValue, isGreaterThanOrEqualTo: query)
//                .whereField("display_name", isLessThanOrEqualTo: query + "\u{f8ff}")
//                .limit(to: pageSize)
//            
//            // Start after the last document if pagination is in use
//            if let lastDoc = lastDocument {
//                queryRef = queryRef.start(afterDocument: lastDoc)
//            }
//            
//            queryRef.getDocuments { (querySnapshot, error) in
//                if let error = error {
//                    print("🆘🔍Error getting documents: \(error)❌")
//                    completion([], nil)
//                } else {
//                    let userArray = querySnapshot?.documents.compactMap {
//                        try? $0.data(as: UserModel.self)
//                    } ?? []
//                    let lastDoc = querySnapshot?.documents.last
//                    completion(userArray, lastDoc)
//                }
//            }
//        }
    
    
    //MARK: - 3. - Update
    func updateName(userUID: String, name: String) async throws {
        do {
            
            try await userDocument(userUID: userUID).setData([ UserModel.CodingKeys.displayName.rawValue: name ], merge: true)
            
        } catch { print("🆘🛜🔺Error updating user name: \(error)❌") }
    }
    func updateBio(userUID: String, bio: String) async throws {
        do {
            try await userDocument(userUID: userUID).setData([UserModel.CodingKeys.bio.rawValue : bio], merge: true)
            
        } catch { print("🆘🛜🔺Error updating user bio: \(error)❌") }
    }
    func updateProfileImage(userUID: String, imageUrlString: String) async throws {
        do {
            try await userDocument(userUID: userUID).setData([UserModel.CodingKeys.profileImageURLString.rawValue : imageUrlString], merge: true)
        } catch { print("🆘🛜🔺Error updating user profile image: \(error)❌") }
    }
//    func updateSavedUsers(currentUserId: String, userIdForArray: String, addOrRemove: AddOrRemove) async throws {
//        if addOrRemove == .add {
//            try await userDocument(userUID: currentUserId).updateData([UserModel.CodingKeys.savedUsersUIDs.rawValue : FieldValue.arrayUnion( [userIdForArray] )] )
//        } else {
//            try await userDocument(userUID: currentUserId).updateData([UserModel.CodingKeys.savedUsersUIDs.rawValue : FieldValue.arrayRemove([userIdForArray])])
//
//        }
//    }
    func updateSavedUsers(currentUserUID: String, userIdForArray: String, addOrRemove: AddOrRemove) async throws {
        do {
            // Ensure document exists or create it if needed
            let userDoc = userDocument(userUID: currentUserUID)
            
            // Choose the operation based on addOrRemove
            if addOrRemove == .add {
                // Add the userIdForArray to the savedUsersUIDs array
                try await userDoc.setData([UserModel.CodingKeys.savedUsersUIDs.rawValue : FieldValue.arrayUnion([userIdForArray])], merge: true)
            } else {
                // Remove the userIdForArray from the savedUsersUIDs array
                try await userDoc.setData([UserModel.CodingKeys.savedUsersUIDs.rawValue : FieldValue.arrayRemove([userIdForArray])], merge: true)
            }
        } catch {
            // Handle any errors that occur during the update
            print("Error updating saved users: \(error.localizedDescription)")
            throw error // Re-throw to handle elsewhere if necessary
        }
    }
    
    func updateFollowingUsers(currentUserUID: String, userUIDForArray: String, addOrRemove: AddOrRemove) async throws {
        do {
            // Ensure document exists or create it if needed
            let currentUserDoc = userDocument(userUID: currentUserUID)
            let userDoc = userDocument(userUID: userUIDForArray)

            
            // Choose the operation based on addOrRemove
            if addOrRemove == .add {
                // Add the userIdForArray to the savedUsersUIDs array
                try await currentUserDoc.setData([UserModel.CodingKeys.followingUIDs.rawValue : FieldValue.arrayUnion([userUIDForArray])], merge: true)
                try await userDoc.setData([UserModel.CodingKeys.followersUIDs.rawValue : FieldValue.arrayUnion([currentUserUID])], merge: true)

            } else {
                // Remove the userIdForArray from the savedUsersUIDs array
                try await currentUserDoc.setData([UserModel.CodingKeys.followingUIDs.rawValue : FieldValue.arrayRemove([userUIDForArray])], merge: true)
                try await userDoc.setData([UserModel.CodingKeys.followersUIDs.rawValue : FieldValue.arrayRemove([currentUserUID])], merge: true)

            }
        } catch {
            // Handle any errors that occur during the update
            print("Error updating saved users: \(error.localizedDescription)")
            throw error // Re-throw to handle elsewhere if necessary
        }
    }

    @MainActor // Ensures it's running on the main thread for UI updates or isolated properly
    func updateObservingTIs(tiUID: String, currentUserUID: String, addOrRemove: AddOrRemove) async throws {
        do {
            if addOrRemove == .add {
//                                try await userDocument(userUID: currentUserUID).updateData([UserModel.CodingKeys.observingTIsIDs.rawValue : FieldValue.arrayUnion([tiUID])])
                try await userDocument(userUID: currentUserUID).setData([UserModel.CodingKeys.observingTIsIDs.rawValue : FieldValue.arrayUnion([tiUID])], merge: true)
            } else {
//                try await userDocument(userUID: currentUserUID).updateData([UserModel.CodingKeys.observingTIsIDs.rawValue : FieldValue.arrayRemove([tiUID])])
                try await userDocument(userUID: currentUserUID).setData([UserModel.CodingKeys.observingTIsIDs.rawValue : FieldValue.arrayRemove([tiUID])], merge: true)

            }
        } catch {
            print("🆘 Error updating observing TIs \(error.localizedDescription) ❌")
        }
    }
    
    func addTiToCreated(tiID: String, currentUserUID: String) async throws {
        Task {
            do {
//                try await userDocument(userUID: currentUserUID).updateData([UserModel.CodingKeys.createdTIsIDs.rawValue : FieldValue.arrayUnion([tiID])])
                try await userDocument(userUID: currentUserUID).setData([UserModel.CodingKeys.createdTIsIDs.rawValue : FieldValue.arrayUnion([tiID])], merge: true)

                print("🟢 Ti added to user's created Tis IDs")

            } catch {
                print("🆘 Error ti not added to user's created Tis IDs \(error.localizedDescription) ❌")
                throw error
            }
        }

    }
    
    //4. - Delete
    func deleteUser(userUID: String) async throws {
        try await userDocument(userUID: userUID).delete()
    }
}

//MARK: - AuthUser
//struct AuthUser {
//    let uid: String
//    let displayName: String?
//    let email: String?
//    let photoUrl: String?
//    let isAnonymous: Bool
//
//    init(user: User) {  ///this User is from  [ import FirebaseAuth ].
//        self.uid = user.uid
//        self.displayName = user.displayName
//        self.email = user.email
//        self.photoUrl = user.photoURL?.absoluteString
//        self.isAnonymous = user.isAnonymous
//    }
//}

//MARK: - DBUser
//struct DBUser: Codable {
//    let userId: String
//    let isAnonymous: Bool?
//    let email: String?
//    let photoUrl: String?
//    let dateCreated: Date?
//    let isPremium: Bool?
//    let preferences: [String]?
//    let favoriteMovie: Movie?
//    let profileImagePath: String?
//    let profileImagePathUrl: String?
//
//    init(auth: AuthDataResultModel) {
//        self.userId = auth.uid
//        self.isAnonymous = auth.isAnonymous
//        self.email = auth.email
//        self.photoUrl = auth.photoUrl
//        self.dateCreated = Date()
//        self.isPremium = false
//        self.preferences = nil
//        self.favoriteMovie = nil
//        self.profileImagePath = nil
//        self.profileImagePathUrl = nil
//    }
//
//    init(
//        userId: String,
//        isAnonymous: Bool? = nil,
//        email: String? = nil,
//        photoUrl: String? = nil,
//        dateCreated: Date? = nil,
//        isPremium: Bool? = nil,
//        preferences: [String]? = nil,
//        favoriteMovie: Movie? = nil,
//        profileImagePath: String? = nil,
//        profileImagePathUrl: String? = nil
//    ) {
//        self.userId = userId
//        self.isAnonymous = isAnonymous
//        self.email = email
//        self.photoUrl = photoUrl
//        self.dateCreated = dateCreated
//        self.isPremium = isPremium
//        self.preferences = preferences
//        self.favoriteMovie = favoriteMovie
//        self.profileImagePath = profileImagePath
//        self.profileImagePathUrl = profileImagePathUrl
//    }
//
////    func togglePremiumStatus() -> DBUser {
////        let currentValue = isPremium ?? false
////        return DBUser(
////            userId: userId,
////            isAnonymous: isAnonymous,
////            email: email,
////            photoUrl: photoUrl,
////            dateCreated: dateCreated,
////            isPremium: !currentValue)
////    }
//
////    mutating func togglePremiumStatus() {
////        let currentValue = isPremium ?? false
////        isPremium = !currentValue
////    }
//
//    enum CodingKeys: String, CodingKey {
//        case userId = "user_id"
//        case isAnonymous = "is_anonymous"
//        case email = "email"
//        case photoUrl = "photo_url"
//        case dateCreated = "date_created"
//        case isPremium = "user_isPremium"
//        case preferences = "preferences"
//        case favoriteMovie = "favorite_movie"
//        case profileImagePath = "profile_image_path"
//        case profileImagePathUrl = "profile_image_path_url"
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.userId = try container.decode(String.self, forKey: .userId)
//        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
//        self.email = try container.decodeIfPresent(String.self, forKey: .email)
//        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
//        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
//        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
//        self.preferences = try container.decodeIfPresent([String].self, forKey: .preferences)
//        self.favoriteMovie = try container.decodeIfPresent(Movie.self, forKey: .favoriteMovie)
//        self.profileImagePath = try container.decodeIfPresent(String.self, forKey: .profileImagePath)
//        self.profileImagePathUrl = try container.decodeIfPresent(String.self, forKey: .profileImagePathUrl)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.userId, forKey: .userId)
//        try container.encodeIfPresent(self.isAnonymous, forKey: .isAnonymous)
//        try container.encodeIfPresent(self.email, forKey: .email)
//        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
//        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
//        try container.encodeIfPresent(self.isPremium, forKey: .isPremium)
//        try container.encodeIfPresent(self.preferences, forKey: .preferences)
//        try container.encodeIfPresent(self.favoriteMovie, forKey: .favoriteMovie)
//        try container.encodeIfPresent(self.profileImagePath, forKey: .profileImagePath)
//        try container.encodeIfPresent(self.profileImagePathUrl, forKey: .profileImagePathUrl)
//    }
//
//}



//MARK: init email
//    init(
//        userUID: String,
//        email: String?
//        )
//    {
//        self.userUID = userUID
//        self.email = email ?? ""
//        self.profileImageURLString = nil
//        self.displayName = ""
//        self.bio = ""
//        self.followingUIDs     = []
//        self.followersUIDs     = []
//        self.savedUsersUIDs    = []
//        self.observingTIs = []
//    }
