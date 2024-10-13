////
////  FeedTabView.swift
////  TheAaliiDebates
////
////  Created by Ali Abraham on 1/9/23.
////
//
//import SwiftUI
//import Firebase
//import FirebaseFirestoreSwift
//
//struct FeedTabView: View {
//    
//    // - John Gallaugher
////    @FirestoreQuery(collectionPath: "THEAALii_Interactions") var interactionsFeed: [TI]
//    ///FSQ grabs everything in the db.
//
//    @State var interactionsFeed: [TI] = []
//
//    var body: some View {
//        
//        ScrollView(showsIndicators: false) {
//            
//            // 1 - Intro Video: How to use the app //
////            Rectangle()
////                .fill(.gray)
////                .frame(width: width, height: width * 0.5625)
////            
////            Text("THEAALii's Interaction Technology (TI)\n Tutorial")
////                .font(.title2)
////                .multilineTextAlignment(.center)
//            // ------------ //
//            
//            
//            Divider()
//            
//            
//            // 2 - Interactions Feed
//            //FIXME: LazyVStack
//            ///when LazyVStack updates forEach doesn't get the added stuff
////            LazyVStack {
//                ForEach(interactionsFeed, id: \.id) { ti in
//
//                    TiCard(ti: ti)
//                }
////            }
//            
//            // 3 - bottom space for the scroll view
//            Rectangle()
//                .foregroundStyle(.clear)
//                .frame(width: width, height: width * 0.5)
//        }
//        .preferredColorScheme(.dark)
//        .onAppear{ Task { await onAppearFetch() } }
//        .refreshable { Task { await onAppearFetch() }  }
//
//    }
//    
//    //MARK: - function
//    func onAppearFetch() async {
//        do {
//            let querySnapshot = try await Firestore.firestore()
//                .collection("THEAALii_Interactions")
//                //.whereField("ti_type", isEqualTo: "D-1") // Add condition
//                .order(by: "ti_absolute_votes", descending: true) // Sort by field
//                .getDocuments()
//            
//            let fetchedInteractions = querySnapshot.documents.compactMap { document in
//                try? document.data(as: TI.self)
//            }
//            
//            interactionsFeed = fetchedInteractions
//            
//        } catch {
//            print("Error fetching interactions: \(error)")
//            return
//        }
//    }
//}
//
//struct FeedTabView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        RootView(logStatus: true)
//        //FeedTabView(showTITView: .constant(false))
//        //.environmentObject(DataManagerVM())
//    }
//}


import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct FeedTabView: View {
    
    @State var interactionsFeed: [TI] = []
    @Bindable var feedVM: FeedViewModel
    
    @Environment(CurrentUser.self) var currentUser
    
    //Pagination Properties
    @State private var lastDocument: DocumentSnapshot? = nil
    @State private var isFetching = false
    let pageSize = 5 // Number of documents per page

    var body: some View {
        ScrollView(showsIndicators: false) {
            
            
//            Text("\(currentUser.displayName) -" + (currentUser.bio))
//            Text(currentUser.UID)
            
            Divider()
            
            // Interactions Feed
//            ForEach(interactionsFeed, id: \.id) { ti in
            LazyVStack {
                ForEach(feedVM.feed, id: \.id) { ti in
                    
                    TiCard(ti: ti)
                    //                    .onAppear {
                    //                        if ti == interactionsFeed.last {
                    //                            Task {
                    //                                await onAppearFetch()
                    //                            }
                    //                        }
                    //                    }
                        .onAppear {
                            if ti == feedVM.feed.last {
                                Task {
                                    await feedVM.onAppearFetch()
                                }
                            }
                        }
                }
            }
            
            // Bottom space for the scroll view
            Rectangle()
                .foregroundStyle(.clear)
                .frame(width: width, height: width * 0.5)
        }
        .preferredColorScheme(.dark)
//        .onAppear{ Task { await onAppearFetch() } }
        .refreshable {
//            resetPagination()
//            interactionsFeed.removeAll()
//            Task { await onAppearFetch() }
            //
            feedVM.resetPagination()
            feedVM.feed.removeAll()
            Task { await feedVM.onAppearFetch() }
        }
        .overlay { if isFetching { LoadingView() } }
    }
    
    //MARK: - Function
//    func onAppearFetch() async {
//        print("✅🟧🚪Entered Fetch: \(String(describing: lastDocument))🚪🟧✅")
//        guard !isFetching else { return }
//        isFetching = true
//        
//        do {
//            var query = Firestore.firestore()
//                .collection("THEAALii_Interactions")
//                .order(by: "ti_absolute_votes", descending: true)
//                .limit(to: pageSize)
//            
//            // If there is a last document, start the next fetch after that document
//            if let lastDoc = lastDocument {
//                query = query.start(afterDocument: lastDoc)
//            }
//            
//            let querySnapshot = try await query.getDocuments()
//            
//            let fetchedInteractions = querySnapshot.documents.compactMap { document in
//                try? document.data(as: TI.self)
//            }
//            
//            // Append new data to the existing feed
//            interactionsFeed.append(contentsOf: fetchedInteractions)
//            
//            isFetching = false
//            
//            // Update the lastDocument to the last fetched document
//            if let lastFetchedDocument = querySnapshot.documents.last {
//                lastDocument = lastFetchedDocument
//            }
//            
//            isFetching = false
//            
//        } catch {
//            print("Error fetching interactions: \(error)")
//            isFetching = false
//        }
//        
//        isFetching = false
//    }
    
//    func resetPagination() {
//        lastDocument = nil
//        interactionsFeed.removeAll()
//    }
}

struct FeedTabView_Previews: PreviewProvider {
    static var previews: some View {
//        RootView(logStatus: true)
        
        TabsBar()
            .environment(CurrentUser().self)

    }
}
