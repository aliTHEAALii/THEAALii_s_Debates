//
//  FeedTabView.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 1/9/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct FeedTabView: View {
    
    // - John Gallaugher
//    @FirestoreQuery(collectionPath: "THEAALii_Interactions") var interactionsFeed: [TI]
    ///FSQ grabs everything in the db.

    @State var interactionsFeed: [TI] = []

    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            // 1 - Intro Video: How to use the app //
//            Rectangle()
//                .fill(.gray)
//                .frame(width: width, height: width * 0.5625)
//            
//            Text("THEAALii's Interaction Technology (TI)\n Tutorial")
//                .font(.title2)
//                .multilineTextAlignment(.center)
            // ------------ //
            
            
            Divider()
            
            
            // 2 - Interactions Feed
            //FIXME: LazyVStack
            ///when LazyVStack updates forEach doesn't get the added stuff
//            LazyVStack {
                ForEach(interactionsFeed, id: \.id) { ti in

                    TiCard(ti: ti)
                }
//            }
            
            // 3 - bottom space for the scroll view
            Rectangle()
                .foregroundStyle(.clear)
                .frame(width: width, height: width * 0.5)
        }
        .preferredColorScheme(.dark)
        .onAppear{ Task { await onAppearFetch() } }
        .refreshable { Task { await onAppearFetch() }  }

    }
    
    //MARK: - function
    func onAppearFetch() async {
        do {
            let querySnapshot = try await Firestore.firestore()
                .collection("THEAALii_Interactions")
                //.whereField("ti_type", isEqualTo: "D-1") // Add condition
                .order(by: "ti_absolute_votes", descending: true) // Sort by field
                .getDocuments()
            
            let fetchedInteractions = querySnapshot.documents.compactMap { document in
                try? document.data(as: TI.self)
            }
            
            interactionsFeed = fetchedInteractions
            
        } catch {
            print("Error fetching interactions: \(error)")
            return
        }
    }
}

struct FeedTabView_Previews: PreviewProvider {
    static var previews: some View {

        RootView(logStatus: true)
        //FeedTabView(showTITView: .constant(false))
        //.environmentObject(DataManagerVM())
    }
}
