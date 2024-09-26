//
//  VotingPostCard.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 6/30/24.
//

import SwiftUI


//MARK: - Voting Video Card
struct VotingPostCard: View {
    
    @AppStorage("current_user_uid") private var currentUserUID: String = "BXnHfiEaIQZiTcpvWs0bATdAdJo1"
    
    let postID: String?
    
    @Binding var ti       : TI?
    @Binding var tiChain  : [String]
    @Binding var chainLink: ChainLink?
    
    @State var vlPost : Post? = nil
    let tiPostID      : String
    @State var tiVideo: TIVideoModel? = nil
    let order: Int
    
    let isAdmin: Bool
    
    //Votes
    
    @State private var upVotes:    Int = 0
    @State private var downVotes:  Int = 0
    @State private var totalVotes: Int = 0
    @State private var upVotersUIDsArray: [String] = []
    @State private var downVotersUIDsArray: [String] = []
    
    //    @StateObject private var cardVM = VotingCardViewModel()
    @State private var showSideOptions: Bool = false
    @State private var isLoading: Bool = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            

            ZStack {
                
                //MARK: Content
                ZStack(alignment: .topLeading) {
                    if vlPost != nil {
                        //TIVideoPlayerViewOld(tiVideo: $tiVideo, urlString: "", sf: 0.85)
                        VotingPostCardContent(post: $vlPost, sf: 1)
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                        LoadingView()
                    }
                    
                    
                    //Order Tag
                    Text("\(order)")
                        .foregroundStyle( vlPost?.addedToChain == true ? Color.ADColors.green : .white )
                        .padding(.all, width * 0.02)
                }
                
                
                //MARK: - Voting
                HStack(spacing: 0) {
                
                    Spacer()
                    
                    if ti != nil, vlPost != nil {
                        
                        if isAdmin {
                            
                            AdminVotingButtons(ti: $ti, tiChain: $tiChain, tiChainLink: $chainLink, vlPost: $vlPost)
                            
                        } else if !isAdmin {
                            
                            NonAdminVotingButtons(ti: $ti, chainLink: $chainLink, vlPost: $vlPost, showVoteNumbersBinding: $showSideOptions)
                        }
                    } else {
                        ProgressView()
                            .frame(width: width * 0.15, height: width * 0.45)
                    }
                }
                .frame(width: width, alignment: .leading)

                

            }
            .frame(height: width * 0.5625 * 1)
            
            //MARK: Post title
            if vlPost != nil {
                HStack(spacing: 0) {
                    Text(vlPost?.title ?? "No Title detected for Vertical List Post")
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .padding(.horizontal, width * 0.01)
                        .frame(width: width * 0.67, alignment: .leading)
                    
                    UserButton(userUID: vlPost?.creatorUID, horizontalName: true, scale: 0.6, horizontalWidth: width * 0.21)
                }
                .frame(width: width, height: (vlPost?.creatorUID.count ?? 0) < 25 ? width * 0.13 : width * 0.17)
            }
            
            
            
            Divider()
                .padding(.bottom, width * 0.005)
        }
        .background( vlPost?.addedToChain == true ? Color.ADColors.green.opacity(0.125) : .black )
        .preferredColorScheme(.dark)
        .onAppear{ onAppearFetchPost() }
        .overlay { if isLoading { ProgressView() } }
    }
    
    
    //MARK: - Functions
    
    func onAppearFetchPost() {
        guard let ti else { return }
        guard let chainLink else { return }
        guard let postID else { return }
        
        PostManager.shared.getVerticalListPost(tiID: ti.id, chainLinkID: chainLink.id, postID: postID) { result in
            switch result{
            case .success(let post):
                vlPost = post
                
                upVotes = vlPost?.upVotes ?? 0
                downVotes = vlPost?.downVotes ?? 0
                totalVotes = vlPost?.totalVotes ?? 0
                upVotersUIDsArray = vlPost?.upVotersUIDsArray ?? []
                downVotersUIDsArray = vlPost?.downVotersUIDsArray ?? []
                
            case .failure(_): //error
                vlPost = nil
            }
        }
        

    }
    
//    private func getVotingProperties() {
//        upVotes = vlPost?.upVotes ?? 0
//        downVotes = vlPost?.downVotes ?? 0
//        totalVotes = vlPost?.totalVotes ?? 0
//        upVotersUIDsArray = vlPost?.upVotersUIDsArray ?? []
//        downVotersUIDsArray = vlPost?.downVotersUIDsArray ?? []
//    }
    
}
#Preview {
    TiView(ti: nil, showTiView: .constant(true))
    
    //    VotingPostCard()
}






//            ZStack {
//                HStack(spacing: 0) {
//
//                    //MARK: Content
//                    ZStack(alignment: .topLeading) {
//                        if vlPost != nil {
//                            //                            TIVideoPlayerViewOld(tiVideo: $tiVideo, urlString: "", sf: 0.85)
//                            VotingPostCardContent(post: $vlPost, sf: 0.85)
//                        } else {
//                            Rectangle()
//                                .fill(Color.gray.opacity(0.2))
//                            LoadingView()
//                        }
//
//
//                        //Order Tag
//                        Text("\(order)")
//                            .foregroundStyle( vlPost?.addedToChain == true ? Color.ADColors.green : .white )
//                            .padding(.all, width * 0.02)
//                    }
//
//
//
//
//                    //MARK: - Voting
//                    if ti != nil, vlPost != nil {
//                        VotingButtonsSV(ti: $ti, chainLink: $chainLink, vlPost: $vlPost, showSideOptions: $showSideOptions)
//                    } else {
//                        ProgressView()
//                            .frame(width: width * 0.15, height: width * 0.45)
//                    }
//                }
//                .frame(width: width, alignment: .leading)
//
//
//                //MARK: Side Options                SideOptionsSheet(showSideSheet: $showSideOptions)
//                //                if isAdmin && tiVideo != nil, ti != nil, chainLink != nil {
//                //                    AdminResponseSideSheet(tiId: ti!.id, tiChainLId: chainLink!.id, tiVideo: tiVideo!,
//                //                                           isAdmin: isAdmin,
//                //                                           showSideSheet: $showSideOptions)
//                //                    .offset(x: showSideOptions ? width * 0.275 : width * 0.777)
//
//                if isAdmin , ti != nil, chainLink != nil, vlPost != nil {
//
//                    VotingPostCardSideSheet(isAdmin: isAdmin, ti: $ti, tiChain: $tiChain, tiChainLink: $chainLink, vlPost: $vlPost, showSideSheet: $showSideOptions, isLoading: $isLoading)
//                        .offset(x: showSideOptions ? width * 0.375 : width * 0.68)
//
//                } else {
//                    SideSheetForVotingCellOld(isAdmin: isAdmin, showSideSheet: $showSideOptions)
//                        .offset(x: showSideOptions ? width * 0.375 : width * 0.68)
//                    //                    VotingPostCardSideSheet(isAdmin: isAdmin, ti: $ti,
//                    //                                            tiChain: ,
//                    //                                            selectedChainLinkIndex: ,
//                    //                                            tiChainLink: $chainLink, tiPost: $tiPost, showSideSheet: $showSideOptions)
//                }
//            }
//            .frame(height: width * 0.5625 * 0.85)




//MARK: Side Options
//                if isAdmin , ti != nil, chainLink != nil, vlPost != nil {
//                    //Admin Side Sheet
////                    VotingPostCardSideSheet(isAdmin: isAdmin, ti: $ti, tiChain: $tiChain,
////                                            tiChainLink: $chainLink, vlPost: $vlPost,
////                                            //votes
////                                            upVotes: $upVotes, downVotes: $downVotes, totalVotes: $totalVotes,
////                                            upVotersUIDsArray: $upVotersUIDsArray,
////                                            downVotersUIDsArray: $downVotersUIDsArray,
////                                            //view
////                                            showSideSheet: $showSideOptions, isLoading: $isLoading)
////                        .offset(x: showSideOptions ? width * 0.375 : width * 0.68)
//
//
//                } else if !isAdmin , ti != nil, chainLink != nil, vlPost != nil {
//                    //Non-Admin Side Sheet
//                    VotingButtonsSideSheet(ti: $ti, chainLink: $chainLink, vlPost: $vlPost, showVoteNumbers: true, showSideOptions: $showSideOptions)
//                        .offset(x: showSideOptions ? width * 0.42 : width * 0.68)
//
//                }
