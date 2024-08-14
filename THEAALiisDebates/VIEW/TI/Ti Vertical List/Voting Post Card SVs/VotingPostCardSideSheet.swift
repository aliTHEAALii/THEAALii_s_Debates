//
//  VotingPostCardSideSheet.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 7/3/24.
//

import SwiftUI

struct VotingPostCardSideSheet: View {
    
    let isAdmin: Bool
    
    @Binding var ti: TI?
    @Binding var tiChain: [String]
    //    @Binding private var selectedChainLinkIndex: Int
    @Binding var tiChainLink: ChainLink?
    @Binding var vlPost: Post?
    

    @ObservedObject private var cardVM = VotingCardViewModel()
    @Binding var showSideSheet: Bool
    @Binding var isLoading: Bool
    
    var body: some View {
        
        ZStack {
            
            // - Black Background
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.black)
                .frame(width: width * 0.35, height: width * 0.5625 * 0.85)
            
            
            // - Border
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(lineWidth: 0.2)
                .foregroundColor(.primary)
                .frame(width: width * 0.35, height: width * 0.5625 * 0.85)
            
            
            
            HStack(spacing: 0) {
                
                
                //MARK: - Left Column
                VStack(spacing: 0) {
                    
                    // - top (Add Post to RIGHT Chain )
                    Button {
                        if isAdmin {
                            if canAddToRight {
                                vlPostToChain(leftOrRight: .right)
                            }
                        }
                    } label: {
                        if isAdmin {
                            
                            VStack(spacing: 0) {
                                
                                IconDoubleTiTriangle(
                                    scale: 1,
                                    color: canAddToRight == true ? Color.ADColors.green : .secondary)
                                .rotationEffect(.degrees(90))
                                .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.25)

                                
                                
                                Text(canAddToRight == true ? "Add to Right" : "Added Right")
                                    .font(.system(size: width * 0.018, weight: .regular))
                                    .foregroundStyle(canAddToRight == true ? .primary : .secondary)
                                
                            }
                            .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.33)
                        } else {
                            Image(systemName: "circle")
                                .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.33)
                        }
                        
                    }
                    
                    
                    // - Middle (add to LEFT Chain)
                    if ti?.tiType == .d1 {
                        //empty space for 
                        Rectangle()
                            .foregroundStyle(.clear)
                            .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.33)
                        
                    } else {
                        Button {
                            if isAdmin {
                                if canAddToLeft {
                                    vlPostToChain(leftOrRight: .left)
                                }
                            }
                        } label: {
                            if ti?.tiType == .d2 {
                                VStack(spacing: 0) {
                                    
                                    IconDoubleTiTriangle(
                                        scale: 1,
                                        color: canAddToLeft == true ? Color.ADColors.green : .secondary)
                                    .rotationEffect(.degrees(-90))
                                    .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.25)
                                    
                                    
                                    Text(canAddToLeft == true ? "Add to Left" : "Added Left")
                                        .font(.system(size: width * 0.018, weight: .regular))
                                        .foregroundStyle(canAddToLeft == true ? .primary : .secondary)
                                }
                                .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.33)
                            } else {
                                Image(systemName: "circle")
                                    .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.33)
                            }
                        }
                    }
                    
                    // - bottom
                    Button {
                        
                    } label: {
                        if isAdmin {
                            VStack(spacing: 0) {
                                Image(systemName: "xmark.square")
                                    .foregroundStyle(.red)
                                    .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.15)
                                
                                Text("Delete Post")
                                    .font(.system(size: width * 0.02, weight: .regular))
                                
                            }
                            .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.33)
                            
                        } else {
                            Image(systemName: "circle")
                                .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.33)
                        }
                    }
                    
                }
                .frame(width: width * 0.15, height: width * 0.5625 * 0.85)
                
                //MARK: - Right Column
                VotingButtonsSV(ti: $ti, chainLink: $tiChainLink, vlPost: $vlPost, showVoteNumbers: true, showSideOptions: $showSideSheet)
                
            }
            .foregroundColor(.primary)
            .frame(width: width * 0.35, height: width * 0.5625 * 0.85, alignment: .leading)
        }
    }
    
    //MARK: - Add Post to Chain
    func vlPostToChain(leftOrRight: LeftOrRight) {
        if isAdmin {
            
            guard ti != nil, let tiChainLink, vlPost != nil else {
                print("❌ VLPost Side Sheet Error ❌"); return
            }
            guard vlPost!.addedToChain == nil  || vlPost!.addedToChain == false  else {
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
                    isLoading = false // Ensure isLoading is set to false after all operations are complete
                } catch {
                    print("🆘⛓️❣️ VL Post Error: Couldn't upload vl Post to Ti Chain ❣️⛓️🆘")
                    isLoading = false // Ensure isLoading is set to false in case of error
                    return
                }
            }
        }
    }
    
    var canAddToLeft: Bool {
        guard ti != nil, vlPost != nil else { return false }
        if vlPost!.addedToChain == false {
            return true
        } else {
            if ti!.leftSideChain != nil {
                if ti!.leftSideChain!.contains(vlPost!.id) {
                    return false
                }
            }
        }
        return true
    }
    var canAddToRight: Bool {
        guard ti != nil, vlPost != nil else { return false }
        if vlPost!.addedToChain == false {
            return true
        } else {
            if ti!.rightSideChain.contains(vlPost!.id) {
                return false
            }
        }
        return true
    }
}

#Preview {
    TiView(ti: nil, showTiView: .constant(true))
    
    //    VotingPostCardSideSheet(isAdmin: true, showSideSheet: .constant(true))
}
