//
//  VerticalListView.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 6/27/24.
//

import SwiftUI


struct TiVerticalListView: View {
    
    @AppStorage("current_user_uid") var currentUserUID: String = "ooo"

    @Binding var ti: TI?
    @Binding var tiChain: [String]
    @Binding var tiChainLink: ChainLink?
    @Binding var tiPost: Post?
    @Binding var selectedChainLinkIndex: Int
    
    //VL Posts
    @State private var verticalListPosts: [Post] = []
    
    var vlVM = VerticalListVM()
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            Divider()
            
            //VL Header
            VerticalListControlBar(ti: $ti, tiChain: $tiChain, tiChainLink: $tiChainLink)
            

            if tiChainLink != nil {

                //For the fetch
                Rectangle()
                    .frame(width: 0, height: 0)
                    .foregroundStyle(.clear)
//                    .onAppear {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                            Task { await  vlVM.getVLPosts(tiID: ti!.id, chainLinkID: tiChainLink!.id) { result in
//                                switch result {
//                                case .success(let vlPosts):
//                                    verticalListPosts = vlPosts
//                                case .failure(_):
//                                    verticalListPosts = []
//                                } } }
//                        } }
//                    .onChange(of: selectedChainLinkIndex) { _, _ in
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                            Task { await  vlVM.getVLPosts(tiID: ti!.id, chainLinkID: tiChainLink!.id) { result in
//                                switch result {
//                                case .success(let vlPosts):
//                                    verticalListPosts = vlPosts
//                                case .failure(_):
//                                    verticalListPosts = []
//                                } } }
//                        } }
                    .onAppear { fetchVerticalListPosts(tiID: ti!.id, chainLinkID: tiChainLink!.id) }
                    .onChange(of: selectedChainLinkIndex) { _, _ in
                        fetchVerticalListPosts(tiID: ti!.id, chainLinkID: tiChainLink!.id)
                    }

                
                //MARK: - Vertical List
                if  !verticalListPosts.isEmpty {

                    ForEach(Array(zip(verticalListPosts.indices, verticalListPosts)), id: \.1.id ) { index, post in
                        
                        VotingPostCard( postID: post.id,
                                        ti: $ti,
                                        tiChain: $tiChain,
                                        chainLink: $tiChainLink,
                                        tiPostID: post.id,
                                        order: index + 1,
                                        isAdmin: true)
                    }
                }

            } else {
                ProgressView()
            }
        }
    }
    
    //MARK: - Functions
//    func fetchSortVerticalList() {
//        guard let ti else { return }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            
//            if let verticalListPostIDs = tiChainLink?.verticalList {
//                verticalListPosts = []
//                for (i, postID) in verticalListPostIDs.enumerated() {
//                    
//                    PostManager.shared.getPost(tiID: ti.id, postID: postID) { result in
//                        switch result {
//                            
//                        case .success(let post):
//                            verticalListPosts.append(post)
//                            
//                            if i == verticalListPostIDs.count - 2 {
//                                verticalListPosts.sort(by: { $0.totalVotes > $1.totalVotes } )
//                            } else if i == verticalListPostIDs.count - 1 {
//                                verticalListPosts.sort(by: { $0.totalVotes > $1.totalVotes } )
//                            }
//                            
//                        case .failure(_):
//                            tiPost = nil
//                        }
//                    }
//                }
//            }
//        }
//    }
    private func fetchVerticalListPosts(tiID: String, chainLinkID: String) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                Task {
                    await vlVM.getVLPosts(tiID: tiID, chainLinkID: chainLinkID) { result in
                        switch result {
                        case .success(let vlPosts):
                            verticalListPosts = vlPosts
                        case .failure:
                            verticalListPosts = []
                        }
                    }
                }
            }
        }
    //DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
    //  Task { 
    //  await  vlVM.getVLPosts(tiID: ti!.id, chainLinkID: tiChainLink!.id) { result in
    //                                switch result {
    //                                case .success(let vlPosts):
    //                                    verticalListPosts = vlPosts
    //                                case .failure(_):
    //                                    verticalListPosts = []
    //                                } } }
    //                        } }
    
    
}

#Preview {
    TiView(ti: nil, showTiView: .constant(true))

//    VerticalListView(ti: .constant(nil), tiChain: .constant([]), tiChainLink: .constant(nil), tiPost: .constant(nil))
}

