//
//  FeedViewModel.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 4/17/23.
//

import Foundation
import Observation
import FirebaseFirestore
import FirebaseFirestoreSwift

@Observable
final class FeedViewModel {
    
    var feed: [TI] = []
    
    //Pagination Properties
    var lastDocument: DocumentSnapshot? = nil
    var isFetching = false
    let pageSize = 3 // Number of documents per page
    
    
    
    func onAppearFetch() async {
        print("✅🌞1🚪Entered Feed Fetch . Last Document: \(String(describing: lastDocument))🚪1🌞✅")
        print("🌞 FEED COUNT: -[ \(feed.count) ]-, Last Ti TITLE: \(feed.last?.title ?? "NIL Title") 🌞")
        guard !isFetching else { return }
        isFetching = true
        print("✅🌞2🔽Fetching Feed . Last Document: \(String(describing: lastDocument))🔽2🌞✅")
        
        do {
            var query = Firestore.firestore()
                .collection("THEAALii_Interactions")
                .order(by: "ti_absolute_votes", descending: true)
                .limit(to: pageSize)
            
            // If there is a last document, start the next fetch after that document
            if let lastDoc = lastDocument {
                query = query.start(afterDocument: lastDoc)
            }
            
            let querySnapshot = try await query.getDocuments()
            
            let fetchedTHEAALii_sInteractions = querySnapshot.documents.compactMap { document in
                try? document.data(as: TI.self)
            }
            
            // Append new data to the existing feed
            feed.append( contentsOf: fetchedTHEAALii_sInteractions )
            
            isFetching = false
            
            // Update the lastDocument to the last fetched document
            if let lastFetchedDocument = querySnapshot.documents.last {
                lastDocument = lastFetchedDocument
            }
            
            isFetching = false
            
        } catch {
            print("Error fetching interactions: \(error)")
            isFetching = false
        }
        
        isFetching = false
    }
    
    func resetPagination() {
        lastDocument = nil
        feed.removeAll()
    }
    
    
//    init() { Task { try await fetchTITs() } }
    
    
//    func fetchTITs() async throws {
//        
//        interactionsFeed.removeAll()
//        loading = true
//        
//        let TITsRef: CollectionReference = Firestore.firestore().collection("Interactions")
//        
//        let snapshot = try await TITsRef.getDocuments()
//        
//        for document in snapshot.documents {
//            let ti = try document.data(as: TI.self)
//            interactionsFeed.append(ti)
//        }
//        
//        loading = false
//    }
    
//    func fetchTIs(completion: @escaping (_ tiFeed: [TI] ) -> Void ) async throws {
//        
//        var tiArray: [TI] = []
//        
//        let tiRef: CollectionReference = Firestore.firestore().collection("THEAALii_Interactions")
//        
//        do {
//            let snapshot = try await tiRef.getDocuments()
//            print("snapshot count = \(snapshot.count)" + " ✅✅🚪🔥🐤🦁")
////            print(snapshot)
//            
//            for document in snapshot.documents {
//                print("snapshot count = \(111)" + " ✅✅🚪🔥🐤🦁")
//                
////                print(document)
////                let tipartial = try document.data(as: TIPartial.self)
////                print(tipartial)
//                print("snapshot count = \(222)" + " ✅✅🚪🔥🐤🦁")
//
//                let ti = try document.data(as: TI.self)
//
////                print("snapshot count = \(222)" + " ✅✅🚪🔥🐤🦁")
//                
//                tiArray.append(ti)
//                print("snapshot count = \(333)" + " ✅✅🚪🔥🐤🦁")
//                
//            }
//        } catch {
//            completion(tiArray)
//            print(error)
//        }
//        
//        completion(tiArray)
//        
//    }
}

//
//struct TIPartial: Codable {
//    
//    let title: String
//    var thumbnail_url: String? //
//    let dateCreated: Date? //
//    
//    var tiType: TIType? //
//    var introPostID: String? //same as the TI ID
//    
//    let creatorUID: String?
//    var tiAdminsUIDs: [String]?
//    
//    
//    var rightSideChain: [String: [String]]? = [:]
//
//    var rsUserUID        :  String?
//    var rsLevel1UsersUIDs       : [String]? = [] //Team (Main Debaters) (max 3 + user = 4 )
//    
//    var rsLevel2UsersUIDs       : [String]? = [] //Support (Secondary )
//    var rsLevel3UsersUIDs       : [String]? = [] //Admins  (Tertiary  )
//
//    var rsSponsorsUIDs          : [String: Int]? = [:] // [ SponsorUID : $400 ]
//    
//    var rsVerticalListAccess: VerticalListAccess? = .open
//    
//    // - Left Side - //
//    var leftSideChain: [String: [String]]? = [:]
//
//    var ls_user_uid        :  String?
//    var lsLevel1UsersUIDs       : [String]? = [] //Team (Main Debaters) (max 3 + user = 4 )
//    
//    var lsLevel2UsersUIDs       : [String]? = [] //Support (secondary )
//    var lsLevel3UsersUIDs       : [String]? = [] //Admins  (Tertiary  )
//    
//    var lsSponsorsUIDs          : [String: Int]? = [:] // [ SponsorUID : $400 ]
//    
//    var lsVerticalListAccess: VerticalListAccess? = .open
//    
//    var tiObserversUIDs: [String]? = []
//}
