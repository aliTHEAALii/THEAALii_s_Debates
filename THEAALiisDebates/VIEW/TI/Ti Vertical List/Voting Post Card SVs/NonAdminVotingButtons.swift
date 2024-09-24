//
//  NonAdminVotingButtons.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 9/6/24.
//

import SwiftUI

struct NonAdminVotingButtons: View {
    
    @AppStorage("current_user_uid") private var currentUserUID: String = "BXnHfiEaIQZiTcpvWs0bATdAdJo1"
    
    @Binding var ti: TI?
    @Binding var chainLink: ChainLink?
    @Binding var vlPost: Post?
    @Binding var showVoteNumbersBinding: Bool
    
    
    //Votes
    @State private var upVotes:    Int = 0
    @State private var downVotes:  Int = 0
    @State private var totalVotes: Int = 0
    @State private var upVotersUIDsArray: [String] = []
    @State private var downVotersUIDsArray: [String] = []
    
    
    @State private var loadingUpVote   = false
    @State private var showVoteNumbers = false
    @State private var loadingDownVote = false
    

    var body: some View {
        
        ZStack {
            
                        
            if showVoteNumbers {
                // - Black Background
                SideSheetRectangle(cornerRadius: 12, rectWidth: width * 0.15, rectHeight: width * 0.5625 * 0.85, color: .black, fill: true, stroke: nil)
                
                // - Border
                SideSheetRectangle(cornerRadius: 12, rectWidth: width * 0.15, rectHeight: width * 0.5625 * 0.85, color: .white, fill: false, stroke: 0.2)
            }
            
            VStack(spacing: 0) {
                
                //UP-Vote Button
                VStack() {
                    if loadingUpVote == false {
                        Button {
                            if !loadingUpVote {
                                upVote()
                            }
                        } label: {
                            if vlPost != nil {
                                VStack(spacing: 0) {
                                    Image(systemName: "chevron.up")
                                        .font(.title)
                                        .fontWeight(upVotersUIDsArray.contains(currentUserUID) ? .heavy : .regular)
//                                        .frame(width: width * 0.15, height: width * (showVoteNumbers ? 0.085 : 0.15))
                                    
                                    if showVoteNumbers {
                                        Text("\(upVotes)")
                                            .padding(.top, 8)
                                        
                                    }
                                }
                                .foregroundColor(upVotersUIDsArray.contains(currentUserUID) ? .ADColors.green : .secondary)
                            }
                        }
                    } else {
                        ProgressView()
                    }
                }
                .frame(height: width * 0.15)
                
                //MARK: show options
                Button {
                    withAnimation(.spring()) {
                        showVoteNumbers.toggle()
                        showVoteNumbersBinding.toggle()
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(lineWidth: 0.5)
                            .frame(width: width * 0.13, height: width * 0.1)
                        
                        //Text("4.6K")
                        Text( "\(totalVotes)" )
                            .fontWeight(.light)
                    }
                    .foregroundColor(.primary)
                    .frame(width: width * 0.15, height: width * 0.15)
                }
                
                //DOWN-Vote Button
                VStack(spacing: 0) {
                if loadingDownVote == false {
                    Button {
                        if !loadingDownVote {
                            downVote()
                        }
                    } label: {
                        if vlPost != nil {
                            
                            VStack(spacing: 0) {
                                
                                if showVoteNumbers {
                                    Text("\(downVotes)")
                                        .padding(.bottom, 8)
                                }
                                
                                Image(systemName: "chevron.down")
                                    .font(.title)
                                    .fontWeight(downVotersUIDsArray.contains(currentUserUID) ? .heavy : .regular)
                            }
                            .foregroundColor(downVotersUIDsArray.contains(currentUserUID) ? .red : .secondary)

                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .frame(height: width * 0.15)
                
            }
        }
        .onAppear{ onAppear() }
    }
    
    
    //MARK: - UPVOTE func
    private func upVote() {
        loadingUpVote = true
        
        guard let tiID = ti?.id else { loadingUpVote = false; return }
        guard let chainLink = chainLink else { loadingUpVote = false; return }
        guard vlPost != nil else { loadingUpVote = false; return }
        
        if upVotersUIDsArray.contains(currentUserUID) {
            print("💃")
            
            // Remove userUID from array
            PostManager.shared.updateVerticalListUpVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, userUID: currentUserUID, addOrRemove: .remove) { error in
                if let error { print("❌\(error.localizedDescription) ❌"); return }
                
                Task {
                    do {
                        try await PostManager.shared.changeVLUpVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, increaseOrDecrease: .decrease)
                        
                        upVotersUIDsArray.remove(object: currentUserUID)
                        upVotes -= 1
                        totalVotes -= 1
                        loadingUpVote = false
                        
                    } catch {
                        print("❌🗳️ 1 if upVoted 🗳️❌")
                        self.loadingUpVote = false
                    }
                }
            }
            
        } else {
            // If Down Voted
            if downVotersUIDsArray.contains(currentUserUID) {
                print("💅")
                PostManager.shared.updateVerticalListDownVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, userUID: currentUserUID, addOrRemove: .remove) { error in
                    if error != nil { return }
                    
                    Task {
                        do {
                            try await PostManager.shared.changeVLDownVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, increaseOrDecrease: .decrease)
                            
                            downVotersUIDsArray.remove(object: currentUserUID)
                            downVotes -= 1
                            totalVotes += 1
                            
                        } catch {
                            print("❌🗳️ 2 if upVoted 🗳️❌")
                        }
                    }
                }
            }
            
            // Not Voted
            print("🦁")
            PostManager.shared.updateVerticalListUpVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, userUID: currentUserUID, addOrRemove: .add) { error in
                if let error { print(error.localizedDescription); return }
                
                Task {
                    do {
                        try await PostManager.shared.changeVLUpVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, increaseOrDecrease: .increase)
                        
                        upVotersUIDsArray.append(currentUserUID)
                        upVotes += 1
                        totalVotes += 1
                        loadingUpVote = false
                        
                    } catch {
                        print("❌🗳️ 3 if upVoted 🗳️❌")
                        self.loadingUpVote = false
                    }
                }
            }
        }
    }
    
    //MARK: - DOWNVOTE func
    private func downVote() {
        loadingDownVote = true
        
        guard let tiID = ti?.id else { loadingDownVote = false; return }
        guard let chainLink = chainLink else { loadingDownVote = false; return }
        guard vlPost != nil else { loadingDownVote = false; return }
        
        // If already voted Down
        if downVotersUIDsArray.contains(currentUserUID) {
            print("💃")
            PostManager.shared.updateVerticalListDownVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, userUID: currentUserUID, addOrRemove: .remove) { error in
                if let error { print(error.localizedDescription); return }
                
                Task {
                    do {
                        try await PostManager.shared.changeVLDownVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, increaseOrDecrease: .decrease)
                        
                        downVotersUIDsArray.remove(object: currentUserUID)
                        downVotes -= 1
                        totalVotes += 1
                        loadingDownVote = false
                        
                    } catch {
                        print("❌🗳️ 4 if upVoted 🗳️❌")
                        self.loadingDownVote = false
                    }
                }
            }
            
        } else {
            // If UP-Voted
            if upVotersUIDsArray.contains(currentUserUID) {
                print("💅")
                PostManager.shared.updateVerticalListUpVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, userUID: currentUserUID, addOrRemove: .remove) { error in
                    if error != nil { return }
                    
                    Task {
                        do {
                            try await PostManager.shared.changeVLUpVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, increaseOrDecrease: .decrease)
                            
                            upVotersUIDsArray.remove(object: currentUserUID)
                            upVotes -= 1
                            totalVotes -= 1
                            
                        } catch {
                            print("❌🗳️ 5 if upVoted 🗳️❌")
                        }
                    }
                }
            }
            
            // Not Voted
            print("🦁")
            PostManager.shared.updateVerticalListDownVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, userUID: currentUserUID, addOrRemove: .add) { error in
                if let error { print(error.localizedDescription); return }
                
                Task {
                    do {
                        try await PostManager.shared.changeVLDownVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, increaseOrDecrease: .increase)
                        
                        downVotersUIDsArray.append(currentUserUID)
                        downVotes += 1
                        totalVotes -= 1
                        loadingDownVote = false
                        
                    } catch {
                        print("❌🗳️ 6 if upVoted 🗳️❌")
                        self.loadingDownVote = false
                    }
                }
            }
        }
    }
    
    
    private func onAppear() {
        guard let vlPost else { return }
        
        upVotes             = vlPost.upVotes
        downVotes           = vlPost.downVotes
        totalVotes          = vlPost.downVotes
        upVotersUIDsArray   = vlPost.upVotersUIDsArray
        downVotersUIDsArray = vlPost.downVotersUIDsArray
    }
}

#Preview {
//    NonAdminVotingButtons()
    
    TiView(ti: nil, showTiView: .constant(true))
}
