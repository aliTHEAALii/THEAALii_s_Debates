//
//  AdminVotingButtons.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 9/7/24.
//

import SwiftUI

struct AdminVotingButtons: View {
    
    @AppStorage("current_user_uid") private var currentUserUID: String = "BXnHfiEaIQZiTcpvWs0bATdAdJo1"
    
    let isAdmin: Bool = true
    
    @Binding var ti: TI?
    @Binding var tiChain: [String]
    @Binding var tiChainLink: ChainLink?
    @Binding var vlPost: Post?
    
    
    //Votes
    @State private var upVotes:    Int = 0
    @State private var downVotes:  Int = 0
    @State private var totalVotes: Int = 0
    @State private var upVotersUIDsArray: [String] = []
    @State private var downVotersUIDsArray: [String] = []
    
    //Voting
    @State private var loadingUpVote   = false
    @State private var showVoteNumbers = false
    @State private var loadingDownVote = false
    
    //This View
    @State private var canAddToLeft = false
    @State private var canAddToRight = false
    @State private var isLoading: Bool = false
    @State private var isDeleted: Bool = false
    
    var body: some View {
        
        ZStack {
            if showVoteNumbers {
                // - Black Background
                SideSheetRectangle(cornerRadius: 12, rectWidth: width * 0.30, rectHeight: width * 0.5625 * 0.85, color: .black, fill: true, stroke: nil)
                
                // - Border
                SideSheetRectangle(cornerRadius: 12, rectWidth: width * 0.30, rectHeight: width * 0.5625 * 0.85, color: .white, fill: false, stroke: 0.2)
                
            }
            
            
            HStack(spacing: 0) {
                
                if !isLoading {
                    
                    //MARK: - Left Column
                    if showVoteNumbers {
                        VStack(spacing: 0) {
                            
                            // - top (Add Post to RIGHT Chain )
                            Button {
                                if isAdmin && !isDeleted {
                                    if canAddToRight {
                                        vlPostToChain(leftOrRight: .right)
                                    }
                                }
                            } label: {
                                if isAdmin {
                                    
                                    VStack(spacing: 0) {
                                        //                                IconDoubleTiTriangle(
                                        //                                    scale: 1,
                                        //                                    color: canAddToRight == true ? Color.ADColors.green : .secondary)
                                        //                                .rotationEffect(.degrees(90))
                                        Image(systemName: "arrow.up.forward.square")
                                            .foregroundStyle(canAddToRight == true ? Color.ADColors.green : .secondary)
                                        
                                            .font(.system(size: width * 0.085, weight: .thin))
                                            .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.25)
                                        
                                        
                                        Text(canAddToRight == true ? "Add to Right" : "Added Right")
                                            .font(.system(size: width * 0.02, weight: .regular))
                                            .foregroundStyle(canAddToRight == true ? .primary : .secondary)
                                        
                                    }
                                    .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.33)
                                } else {
                                    Image(systemName: "circle")
                                        .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.33)
                                }
                                
                            }//
                            
                            
                            // - Middle (add to LEFT Chain)
                            if ti?.tiType == .d1 {
                                //empty space for
                                Rectangle()
                                    .foregroundStyle(.clear)
                                    .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.33)
                                
                            } else {
                                Button {
                                    if isAdmin {
                                        if isAdmin && !isDeleted {
                                            vlPostToChain(leftOrRight: .left)
                                        }
                                    }
                                } label: {
                                    if ti?.tiType == .d2 {
                                        VStack(spacing: 0) {
                                            //                                    IconDoubleTiTriangle(
                                            //                                        scale: 1,
                                            //                                        color: canAddToLeft == true ? Color.ADColors.green : .secondary)
                                            //                                    .rotationEffect(.degrees(-90))
//                                            Image(systemName: "arrow.up.forward.square")
                                            Image(systemName: "arrow.up.left.square")
                                                .foregroundStyle(canAddToLeft == true ? Color.ADColors.green : .secondary)
                                                .font(.system(size: width * 0.085, weight: .thin))
                                                .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.25)
                                            
                                            
                                            Text(canAddToLeft == true ? "Add to Left" : "Added Left")
                                                .font(.system(size: width * 0.02, weight: .regular))
                                                .foregroundStyle(canAddToLeft == true ? .primary : .secondary)
                                        }
                                        .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.33)
                                    } else {
                                        Image(systemName: "circle")
                                            .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.33)
                                    }
                                }
                            }
                            
                            //MARK: - bottom (Delete)
                            if !isDeleted {
                            Button {
                                if isAdmin {
                                    Task { await deleteVLPost() }
                                }
                            } label: {
                                if isAdmin {
                                    VStack(spacing: 0) {
                                        Image(systemName: "xmark.square")
                                            .foregroundStyle(.red)
                                            .font(.system(size: width * 0.085, weight: .thin))
                                            .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.225)
                                        
                                        Text("Delete Post")
                                            .font(.system(size: width * 0.02, weight: .regular))
                                        
                                    }
                                    .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.33)
                                    
                                } else {
                                    Image(systemName: "circle")
                                        .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.33)
                                }
                            }
                            } else {
                                Text("DELETED \n Refresh")
                                    .font(.system(size: width * 0.033, weight: .thin))
                                    .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.33)
                            }
                            
                        }
                        .frame(width: width * 0.15, height: width * 0.5625 * 0.85)
                        
                    }
                } else { ProgressView().frame(width: width * 0.15) }

                //MARK: - Right Column
                //                VotingButtonsSV(ti: $ti, chainLink: $tiChainLink, vlPost: $vlPost, showVoteNumbers: true, showSideOptions: $showSideSheet)
                //                VotingButtonsSV(ti: $ti, chainLink: $chainLink, vlPost: $vlPost,
                //                                upVotes: $upVotes,
                //                                downVotes: $downVotes,
                //                                totalVotes: $totalVotes,
                //                                upVotersUIDsArray: $upVotersUIDsArray,
                //                                downVotersUIDsArray: $downVotersUIDsArray,
                //                                showVoteNumbers: true,
                //                                showSideOptions: $showSideSheet)
                
                NonAdminVotingButtons(ti: $ti, chainLink: $tiChainLink, vlPost: $vlPost, showVoteNumbersBinding: $showVoteNumbers)
                
            }
            .foregroundColor(.primary)
            .frame(width: width * 0.35, height: width * 0.5625 * 0.85, alignment: .trailing)
            
        }
        .onAppear{ onAppear() }
        
    }
    
    
    private func onAppear() {
        guard let vlPost else { return }
        
        upVotes             = vlPost.upVotes
        downVotes           = vlPost.downVotes
        totalVotes          = vlPost.downVotes
        upVotersUIDsArray   = vlPost.upVotersUIDsArray
        downVotersUIDsArray = vlPost.downVotersUIDsArray
        canAddToLeft        = canAddToLeftFunc()
        canAddToRight       = canAddToRightFunc()
    }
    
    func canAddToLeftFunc() -> Bool {
        guard ti != nil, vlPost != nil else { return false }
        if vlPost!.addedToChain == nil || vlPost!.addedToChain == false {
            return true
        }
        else {
            if ti!.leftSideChain != nil {
                if ti!.leftSideChain!.contains(vlPost!.id) {
                    return false
                }
            }
        }

        return true
    }
    func canAddToRightFunc() -> Bool {
        guard ti != nil, vlPost != nil else { return false }
        if  vlPost!.addedToChain == nil || vlPost!.addedToChain == false {
            return true
        }
        else {
            if ti!.rightSideChain.contains(vlPost!.id) {
                return false
            }
        }
        
        return true
    }
    
    //MARK: - Add Post to Chain
    func vlPostToChain(leftOrRight: LeftOrRight) {
        if isAdmin {
            
            guard ti != nil, let tiChainLink, vlPost != nil else {
                print("❌ VLPost Side Sheet Error ❌"); return
            }

            guard vlPost!.addedToChain == nil || (canAddToLeft || canAddToRight)  else {
                print("❌ VLPost Side Sheet Error 2 ❌"); return
            }
            
            
            isLoading = true
            
            let chainLink = ChainLink(id: vlPost!.id, title: vlPost!.title, thumbnailURL: vlPost!.imageURL, creatorUID: vlPost?.creatorUID, addedFromVerticalListed: true)
            
            Task {
                do {
                    do {
                        try await PostManager.shared.createPost(tiID: ti!.id, post: vlPost!)
                        print("🟢 VL createPost❣️")
                        
                    } catch {
                        print("🆘Error in createPost: \(error)❣️")
                        throw error
                    }
                    
                    do {
                        try await ChainLinkManager.shared.createChainLink(tiID: ti!.id, chainLink: chainLink)
                        print("🟢 VL createChainLink❣️")
                        
                    } catch {
                        print("🆘Error in createChainLink: \(error)❣️")
                        throw error
                    }
                    
                    do {
                        try await TIManager.shared.addToChain(tiID: ti!.id, cLinkID: vlPost!.id, rightOrLeft: leftOrRight)
                        print("🟢 VL addToChain❣️")
                        
                    } catch {
                        print("🆘Error in addToChain: \(error)❣️")
                        throw error
                    }
                    
                    do {
                        try await PostManager.shared.updateAddToChain(tiID: ti!.id, chainLinkID: tiChainLink.id, postID: vlPost!.id)
                        print("🟢 VL updateAddToChain❣️")
                        
                    } catch {
                        print("🆘Error in updateAddToChain: \(error)❣️")
                        throw error
                    }
                    
                    if leftOrRight == .left {
                        ti!.leftSideChain?.append(vlPost!.id)
                        tiChain.insert(vlPost!.id, at: 0)
                    } else {
                        ti!.rightSideChain.append(vlPost!.id)
                        tiChain.append(vlPost!.id)
                    }
                    
                    vlPost!.addedToChain = true
                    if leftOrRight == .left  { canAddToLeft  = false }
                    if leftOrRight == .right { canAddToRight = false }
                    isLoading = false
                    
                } catch {
                    print("🆘⛓️❣️ VL Post Error: Couldn't upload vl Post to Ti Chain ❣️⛓️🆘")
                    isLoading = false // Ensure isLoading is set to false in case of error
                    return
                }
            }
        }
    }
    
    func deleteVLPost() async {
        isLoading = true

        do {
            print("🟣00 deleteVLPost")

            if vlPost!.type == .video, vlPost!.videoURL != nil {
                try await VideoManager.shared.deleteVideo(videoID: vlPost!.id)
                print("🟣11 deleteVLPost")
                
            } else if vlPost!.type == .image, vlPost!.imageURL != nil {
                print("🟣22 deleteVLPost")

                try await ImageManager.shared.deleteImage(imageID: vlPost!.id, thumbnailFor: .post)
                print("🟣33 deleteVLPost")

            }
            await PostManager.shared.deleteVLPost(tiID: ti!.id, chainLinkID: tiChainLink!.id, postID: vlPost!.id)
            
            isLoading = false
            isDeleted = true
            
        } catch {
            print("👹🎥📹❌Error deleting VLPost/video/image : \(error.localizedDescription)❌📹🎥👹")
            isLoading = false
        }
    }
}

#Preview {
    TiView(ti: nil, showTiView: .constant(true))
    
    //    AdminVotingButtons()
}
