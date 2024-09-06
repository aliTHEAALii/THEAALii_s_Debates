//
//  VerticalListView.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 6/27/24.
//

import SwiftUI
import FirebaseFirestore

struct TiVerticalListView: View {
    
    @AppStorage("current_user_uid") var currentUserUID: String = "ooo"

    @Binding var ti: TI?
    @Binding var tiChain: [String]
    @Binding var tiChainLink: ChainLink?
    @Binding var tiPost: Post?
    @Binding var selectedChainLinkIndex: Int
    
    // VL Posts
    @State private var verticalListPosts: [Post] = []
    
    // Pagination Properties
    @State private var lastDocument: DocumentSnapshot? = nil
    @State private var isFetching = false
    
    var vlVM = VerticalListVM()
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Divider()
            
            // VL Header
            VerticalListControlBar(ti: $ti, tiChain: $tiChain, tiChainLink: $tiChainLink)
            
            if let tiChainLink = tiChainLink {

                // For the fetch
                Rectangle()
                    .frame(width: 0, height: 0)
                    .foregroundStyle(.clear)
                    .onAppear {
                        resetPagination()
                        fetchVerticalListPosts(tiID: ti!.id, chainLinkID: tiChainLink.id)
                    }
                    .onChange(of: tiChainLink) { _, _ in
                        resetPagination()
                        fetchVerticalListPosts(tiID: ti!.id, chainLinkID: tiChainLink.id)
                    }

                // MARK: - Vertical List
                if !verticalListPosts.isEmpty {
                    ScrollView {
//                        LazyVStack {
                            ForEach(Array(zip(verticalListPosts.indices, verticalListPosts)), id: \.1.id) { index, post in
                                VotingPostCard(
                                    postID: post.id,
                                    ti: $ti,
                                    tiChain: $tiChain,
                                    chainLink: $tiChainLink,
                                    tiPostID: post.id,
                                    order: index + 1,
                                    isAdmin: TiViewModel().isAdmin(ti: ti, currentUserUID: currentUserUID)
                                )
                                .onAppear {
                                    if post == verticalListPosts.last {
                                        fetchVerticalListPosts(tiID: ti!.id, chainLinkID: tiChainLink.id)
                                    }
                                }
                            }
//                        }
                    }
                }
            } else {
                ProgressView()
            }
        }
    }
    
    // MARK: - Functions
    private func fetchVerticalListPosts(tiID: String, chainLinkID: String) {
        guard !isFetching else { return }
        isFetching = true
        
        vlVM.getVLPosts(tiID: tiID, chainLinkID: chainLinkID, lastDocument: lastDocument, pageSize: 5) { result in
            switch result {
            case .success(let (vlPosts, lastDoc)):
                verticalListPosts.append(contentsOf: vlPosts)
                lastDocument = lastDoc
            case .failure:
                verticalListPosts = []
            }
            isFetching = false
        }
    }
    
    private func resetPagination() {
        verticalListPosts.removeAll()
        lastDocument = nil
        isFetching = false
    }
}


#Preview {
    TiView(ti: nil, showTiView: .constant(true))

//    VerticalListView(ti: .constant(nil), tiChain: .constant([]), tiChainLink: .constant(nil), tiPost: .constant(nil))
}
