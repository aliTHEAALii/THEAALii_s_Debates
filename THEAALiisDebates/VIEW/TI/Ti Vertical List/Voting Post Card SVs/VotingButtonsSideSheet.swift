//
//  VotingButtons.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 8/16/24.
//

import SwiftUI

//#Preview {
//    VotingButtons()
//}

//
//  VotingButtonsSV.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 7/13/24.
//

import SwiftUI

struct VotingButtonsSideSheet: View {
    
    @AppStorage("current_user_uid") private var currentUserUID: String = "BXnHfiEaIQZiTcpvWs0bATdAdJo1"
    
    @Binding var ti: TI?
    @Binding var chainLink: ChainLink?
    @Binding var vlPost: Post?
    
    @State private var loadingUpVote = false
    @State private var loadingDownVote = false
    
    //Votes
    @State private var upVotes: Int = 0
    @State private var downVotes: Int = 0
    @State private var totalVotes: Int = 0
    @State private var upVotersUIDsArray: [String] = []
    @State private var downVotersUIDsArray: [String] = []
    
    var showVoteNumbers: Bool = false
    @Binding var showSideOptions: Bool
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            //UP-Vote Button
            if loadingUpVote == false {
                Button {
//                    if !loadingUpVote {
                        upVote()
//                    }
                    
                } label: {
                    if vlPost != nil {
                        if loadingUpVote {
                            ProgressView()
                                .frame(width: width * 0.15, height: width * 0.15)
                        } else {
                            VStack(spacing: 0) {
                                Image(systemName: "chevron.up")
                                    .foregroundColor(upVotersUIDsArray.contains(currentUserUID) ? .ADColors.green : .secondary)
                                    .font(.title)
                                    .fontWeight(upVotersUIDsArray.contains(currentUserUID) ? .heavy : .regular)
                                    .frame(width: width * 0.15, height: width * (showVoteNumbers ? 0.085 : 0.15))
                                
                                if showVoteNumbers {
                                    Text("\(upVotes)")
                                }
                            }
                        }
                        
                    }
                }
            } else {
                ProgressView()
            }
            
            //MARK: show options
            Button {
                withAnimation(.spring()) {
                    showSideOptions.toggle()
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(lineWidth: 0.5)
                        .frame(width: width * 0.13, height: width * 0.1)
                    
                    //Text("4.6K")
                    Text( "\(totalVotes)" )
                    //                    Text( String(totalVotes) )
                    
                    //                    Text( String(vlPost!.upVotes - vlPost!.downVotes) )
                        .fontWeight(.light)
                }
                .foregroundColor(.primary)
                .frame(width: width * 0.15, height: width * 0.15)
            }
            
            //DOWN-Vote Button
            if loadingDownVote == false {
                Button {
                    if !loadingDownVote {
                        downVote()
                    }
                } label: {
                    if vlPost != nil {
                        
                        if loadingDownVote {
                            ProgressView()
                                .frame(width: width * 0.15, height: width * 0.15)
                        } else {
                            VStack(spacing: 0) {
                                
                                if showVoteNumbers {
                                    Text("\(downVotes)")
                                }
                                
                                Image(systemName: "chevron.down")
                                    .foregroundColor(downVotersUIDsArray.contains(currentUserUID) ? .red : .secondary)
                                    .font(.title)
                                    .fontWeight(downVotersUIDsArray.contains(currentUserUID) ? .heavy : .regular)
                                    .frame(width: width * 0.15, height: width * (showVoteNumbers ? 0.085 : 0.15))
                            }
                        }
                    }
                }
            } else {
                ProgressView()
            }
            
        }
        .preferredColorScheme(.dark)
        .onAppear{
            upVotes = vlPost?.upVotes ?? 0
            downVotes = vlPost?.downVotes ?? 0
            totalVotes = vlPost?.totalVotes ?? 0
            upVotersUIDsArray = vlPost?.upVotersUIDsArray ?? []
            downVotersUIDsArray = vlPost?.downVotersUIDsArray ?? []
        }
        .onChange(of: vlPost) { oldValue, newValue in
            upVotes = vlPost?.upVotes ?? 0
            downVotes = vlPost?.downVotes ?? 0
            totalVotes = vlPost?.totalVotes ?? 0
            upVotersUIDsArray = vlPost?.upVotersUIDsArray ?? []
            downVotersUIDsArray = vlPost?.downVotersUIDsArray ?? []
            
        }
    }
    
    
    //MARK: - UPVOTE func
    private func newUpVote() {
        loadingUpVote = true

        upVotersUIDsArray += [currentUserUID]
        upVotes += 1

        
        loadingUpVote = false
    }

    private func upVote() {
        loadingUpVote = true

        guard let tiID      = ti?.id    else { loadingUpVote = false; return }
        guard let chainLink = chainLink else { loadingUpVote = false; return }
        guard let vlPost    = vlPost    else { loadingUpVote = false; return }


        if upVotersUIDsArray.contains(currentUserUID) {
            print("💃")

            //remove userUID from array
            PostManager.shared.updateVerticalListUpVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, userUID: currentUserUID, addOrRemove: .remove) { error in

                if let error {print("❌\(error.localizedDescription) ❌"); return }

//                PostManager.shared.changeVerticalListUpVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .decrease) { error in
//
//                    if let error {
//                        print("💃" + error.localizedDescription + "💃")
//                        return
//                    }
//
//                    self.vlPost!.upVotersUIDsArray.remove(object: currentUserUID)
//                    self.vlPost!.upVotes -= 1
//                    self.vlPost!.totalVotes -= 1
//
//
//                }
                Task {
                    do {
                        try await PostManager.shared.changeVLUpVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .decrease)

                        upVotersUIDsArray.remove(object: currentUserUID)
                        upVotes -= 1
                        totalVotes -= 1

                    } catch {
                        print("❌🗳️ 1 if upVoted 🗳️❌")
                    }
                }
            }

        } else {
            //if Down Voted -----
            if vlPost.downVotersUIDsArray.contains(currentUserUID) {
                print("💅")
                PostManager.shared.updateVerticalListDownVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, userUID: currentUserUID, addOrRemove: .remove) { error in

                    if error != nil { return }


//                    PostManager.shared.changeVerticalListDownVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .decrease) { error in
//
//                        if error != nil { return }
//
//                        self.vlPost!.downVotersUIDsArray.remove(object: currentUserUID)
//                        self.vlPost!.downVotes -= 1
//                        self.vlPost!.totalVotes += 1
//                    }
                    Task {
                        do {
                            try await PostManager.shared.changeVLDownVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .decrease)

                            downVotersUIDsArray.remove(object: currentUserUID)
                            downVotes -= 1
                            totalVotes += 1

                        } catch {
                            print("❌🗳️ 2 if upVoted 🗳️❌")
                        }
                    }
                }
            }

            //Not Voted -----
            print("🦁")
            PostManager.shared.updateVerticalListUpVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, userUID: currentUserUID, addOrRemove: .add) { error in

                if let error {print(error.localizedDescription); return }

//                PostManager.shared.changeVerticalListUpVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .increase) { error in
//
//                    if let error {print(error.localizedDescription); return }
//
//                    self.vlPost!.upVotersUIDsArray.append(currentUserUID)
//                    self.vlPost!.upVotes += 1
//                    self.vlPost!.totalVotes += 1
//                }
                Task {
                    do {
                        try await PostManager.shared.changeVLUpVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .increase)

                        upVotersUIDsArray.append(currentUserUID)
                        upVotes += 1
                        totalVotes += 1

                    } catch {
                        print("❌🗳️ 3 if upVoted 🗳️❌")
                    }
                }
            }
        }

        loadingUpVote = false
    }
//
//
//
//    //MARK: - DOWNVOTE func
    private func downVote() {
        loadingDownVote = true

        guard let tiID      = ti?.id    else { loadingDownVote = false; return }
        guard let chainLink = chainLink else { loadingDownVote = false; return }
        guard let vlPost    = vlPost    else { loadingDownVote = false; return }

        loadingDownVote = true

        //if already voted Down
        if vlPost.downVotersUIDsArray.contains(currentUserUID) {
            print("💃")

            PostManager.shared.updateVerticalListDownVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, userUID: currentUserUID, addOrRemove: .remove) { error in

                if let error {print(error.localizedDescription); return }

//                PostManager.shared.changeVerticalListDownVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .decrease) { error in
//
//                    if let error {print(error.localizedDescription); return }
//
//
//                    self.vlPost!.downVotersUIDsArray.remove(object: currentUserUID)
//                    self.vlPost!.downVotes -= 1
//                    self.vlPost!.totalVotes += 1
//
//
//                }
                Task {
                    do {
                        try await PostManager.shared.changeVLDownVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .decrease)

                        downVotersUIDsArray.remove(object: currentUserUID)
                        downVotes -= 1
                        totalVotes += 1

                    } catch {
                        print("❌🗳️ 4 if upVoted 🗳️❌")
                    }
                }
            }

        } else {
            //if UP-Voted -----
            if vlPost.upVotersUIDsArray.contains(currentUserUID) {
                print("💅")
                PostManager.shared.updateVerticalListUpVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, userUID: currentUserUID, addOrRemove: .remove) { error in

                    if error != nil { return }


//                    PostManager.shared.changeVerticalListUpVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .decrease) { error in
//
//                        if error != nil { return }
//
//                        self.vlPost!.upVotersUIDsArray.remove(object: currentUserUID)
//                        self.vlPost!.upVotes -= 1
//                        self.vlPost!.totalVotes -= 1
//                    }
                    Task {
                        do {
                            try await PostManager.shared.changeVLUpVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .decrease)

//                            self.vlPost!.upVotersUIDsArray.remove(object: currentUserUID)
//                            self.vlPost!.upVotes -= 1
//                            self.vlPost!.totalVotes -= 1
                            upVotersUIDsArray.remove(object: currentUserUID)
                            upVotes -= 1
                            totalVotes -= 1

                        } catch {
                            print("❌🗳️ 5 if upVoted 🗳️❌")
                        }
                    }
                }
            }

            //Not Voted -----
            print("🦁")
            PostManager.shared.updateVerticalListDownVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, userUID: currentUserUID, addOrRemove: .add) { error in


                if let error {print(error.localizedDescription); return }

//                PostManager.shared.changeVerticalListDownVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .increase) { error in
//
//
//                    if let error {print(error.localizedDescription); return }
//
//                    self.vlPost!.downVotersUIDsArray.append(currentUserUID)
//                    self.vlPost!.downVotes += 1
//                    self.vlPost!.totalVotes -= 1
//                }
                Task {
                    do {
                        try await PostManager.shared.changeVLDownVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .increase)

//                        self.vlPost!.downVotersUIDsArray.append(currentUserUID)
//                        self.vlPost!.downVotes += 1
//                        self.vlPost!.totalVotes -= 1
                        downVotersUIDsArray.append(currentUserUID)
                        downVotes += 1
                        totalVotes -= 1

                    } catch { print("❌🗳️ 6 if upVoted 🗳️❌") }
                }
            }
        }

        loadingDownVote = false
    }
}

#Preview {
    TiView(ti: nil, showTiView: .constant(true))

//    VotingButtonsSV()
}
