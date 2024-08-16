//
//  VotingButtonsSV.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 7/13/24.
//

import SwiftUI

struct VotingButtonsSV: View {
    
    @AppStorage("current_user_uid") private var currentUserUID: String = "BXnHfiEaIQZiTcpvWs0bATdAdJo1"
    
    @Binding var ti: TI?
    @Binding var chainLink: ChainLink?
    @Binding var vlPost: Post?
    @State private var loadingUpVote = false
    @State private var loadingDownVote = false
    
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
                                    .foregroundColor(vlPost!.upVotersUIDsArray.contains(currentUserUID) ? .ADColors.green : .secondary)
                                    .font(.title)
                                    .fontWeight(vlPost!.upVotersUIDsArray.contains(currentUserUID) ? .heavy : .regular)
                                    .frame(width: width * 0.15, height: width * (showVoteNumbers ? 0.085 : 0.15))
                                
                                if showVoteNumbers {
                                    Text("\(vlPost!.upVotes)")
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
                    Text( "\(vlPost?.totalVotes ?? 0)" )
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
                                    Text("\(vlPost!.downVotes)")
                                }
                                
                                Image(systemName: "chevron.down")
                                    .foregroundColor(vlPost!.downVotersUIDsArray.contains(currentUserUID) ? .red : .secondary)
                                    .font(.title)
                                    .fontWeight(vlPost!.downVotersUIDsArray.contains(currentUserUID) ? .heavy : .regular)
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
    }
    
    
    //MARK: - UPVOTE func
//    private func upVote() {
//        loadingUpVote = true
//
//        guard let tiID      = ti?.id    else { loadingUpVote = false; return }
//        guard let chainLink = chainLink else { loadingUpVote = false; return }
//        guard let vlPost    = vlPost    else { loadingUpVote = false; return }
//        
//        
//        if vlPost.upVotersUIDsArray.contains(currentUserUID) {
//            print("💃")
//            
//            //remove userUID from array
//            PostManager.shared.updateVerticalListUpVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, userUID: currentUserUID, addOrRemove: .remove) { error in
//                
//                if let error {print("❌\(error.localizedDescription) ❌"); return }
//
////                PostManager.shared.changeVerticalListUpVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .decrease) { error in
////                    
////                    if let error {
////                        print("💃" + error.localizedDescription + "💃")
////                        return
////                    }
////                    
////                    self.vlPost!.upVotersUIDsArray.remove(object: currentUserUID)
////                    self.vlPost!.upVotes -= 1
////                    self.vlPost!.totalVotes -= 1
////                    
////                    
////                }
//                Task {
//                    do {
//                        try await PostManager.shared.changeVLUpVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .decrease)
//                        
//                        self.vlPost!.upVotersUIDsArray.remove(object: currentUserUID)
//                        self.vlPost!.upVotes -= 1
//                        self.vlPost!.totalVotes -= 1
//                        
//                    } catch {
//                        print("❌🗳️ 1 if upVoted 🗳️❌")
//                    }
//                }
//            }
//            
//        } else {
//            //if Down Voted -----
//            if vlPost.downVotersUIDsArray.contains(currentUserUID) {
//                print("💅")
//                PostManager.shared.updateVerticalListDownVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, userUID: currentUserUID, addOrRemove: .remove) { error in
//                    
//                    if error != nil { return }
//                    
//                    
////                    PostManager.shared.changeVerticalListDownVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .decrease) { error in
////                        
////                        if error != nil { return }
////                        
////                        self.vlPost!.downVotersUIDsArray.remove(object: currentUserUID)
////                        self.vlPost!.downVotes -= 1
////                        self.vlPost!.totalVotes += 1
////                    }
//                    Task {
//                        do {
//                            try await PostManager.shared.changeVLDownVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .decrease)
//                            
//                            self.vlPost!.downVotersUIDsArray.remove(object: currentUserUID)
//                            self.vlPost!.downVotes -= 1
//                            self.vlPost!.totalVotes += 1
//                            
//                        } catch {
//                            print("❌🗳️ 2 if upVoted 🗳️❌")
//                        }
//                    }
//                }
//            }
//            
//            //Not Voted -----
//            print("🦁")
//            PostManager.shared.updateVerticalListUpVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, userUID: currentUserUID, addOrRemove: .add) { error in
//                
//                if let error {print(error.localizedDescription); return }
//
////                PostManager.shared.changeVerticalListUpVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .increase) { error in
////                    
////                    if let error {print(error.localizedDescription); return }
////                    
////                    self.vlPost!.upVotersUIDsArray.append(currentUserUID)
////                    self.vlPost!.upVotes += 1
////                    self.vlPost!.totalVotes += 1
////                }
//                Task {
//                    do {
//                        try await PostManager.shared.changeVLUpVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .increase)
//                        
//                        self.vlPost!.upVotersUIDsArray.append(currentUserUID)
//                        self.vlPost!.upVotes += 1
//                        self.vlPost!.totalVotes += 1
//                        
//                    } catch {
//                        print("❌🗳️ 3 if upVoted 🗳️❌")
//                    }
//                }
//            }
//        }
//        
//        loadingUpVote = false
//    }
//    
//    
//    
//    //MARK: - DOWNVOTE func
//    private func downVote() {
//        loadingDownVote = true
//
//        guard let tiID      = ti?.id    else { loadingDownVote = false; return }
//        guard let chainLink = chainLink else { loadingDownVote = false; return }
//        guard let vlPost    = vlPost    else { loadingDownVote = false; return }
//        
//        loadingDownVote = true
//        
//        //if already voted Down
//        if vlPost.downVotersUIDsArray.contains(currentUserUID) {
//            print("💃")
//            
//            PostManager.shared.updateVerticalListDownVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, userUID: currentUserUID, addOrRemove: .remove) { error in
//                
//                if let error {print(error.localizedDescription); return }
//
////                PostManager.shared.changeVerticalListDownVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .decrease) { error in
////                    
////                    if let error {print(error.localizedDescription); return }
////
////                    
////                    self.vlPost!.downVotersUIDsArray.remove(object: currentUserUID)
////                    self.vlPost!.downVotes -= 1
////                    self.vlPost!.totalVotes += 1
////                    
////                    
////                }
//                Task {
//                    do {
//                        try await PostManager.shared.changeVLDownVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .decrease)
//                        
//                        self.vlPost!.downVotersUIDsArray.remove(object: currentUserUID)
//                        self.vlPost!.downVotes -= 1
//                        self.vlPost!.totalVotes += 1
//                        
//                    } catch {
//                        print("❌🗳️ 4 if upVoted 🗳️❌")
//                    }
//                }
//            }
//            
//        } else {
//            //if UP-Voted -----
//            if vlPost.upVotersUIDsArray.contains(currentUserUID) {
//                print("💅")
//                PostManager.shared.updateVerticalListUpVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, userUID: currentUserUID, addOrRemove: .remove) { error in
//                    
//                    if error != nil { return }
//                    
//                    
////                    PostManager.shared.changeVerticalListUpVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .decrease) { error in
////                        
////                        if error != nil { return }
////                        
////                        self.vlPost!.upVotersUIDsArray.remove(object: currentUserUID)
////                        self.vlPost!.upVotes -= 1
////                        self.vlPost!.totalVotes -= 1
////                    }
//                    Task {
//                        do {
//                            try await PostManager.shared.changeVLUpVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .decrease)
//                            
//                            self.vlPost!.upVotersUIDsArray.remove(object: currentUserUID)
//                            self.vlPost!.upVotes -= 1
//                            self.vlPost!.totalVotes -= 1
//                            
//                        } catch {
//                            print("❌🗳️ 5 if upVoted 🗳️❌")
//                        }
//                    }
//                }
//            }
//            
//            //Not Voted -----
//            print("🦁")
//            PostManager.shared.updateVerticalListDownVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, userUID: currentUserUID, addOrRemove: .add) { error in
//                
//
//                if let error {print(error.localizedDescription); return }
//                
////                PostManager.shared.changeVerticalListDownVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .increase) { error in
////                    
////                    
////                    if let error {print(error.localizedDescription); return }
////
////                    self.vlPost!.downVotersUIDsArray.append(currentUserUID)
////                    self.vlPost!.downVotes += 1
////                    self.vlPost!.totalVotes -= 1
////                }
//                Task {
//                    do {
//                        try await PostManager.shared.changeVLDownVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .increase)
//                        
//                        self.vlPost!.downVotersUIDsArray.append(currentUserUID)
//                        self.vlPost!.downVotes += 1
//                        self.vlPost!.totalVotes -= 1
//                        
//                    } catch { print("❌🗳️ 6 if upVoted 🗳️❌") }
//                }
//            }
//        }
//        
//        loadingDownVote = false
//    }
    //MARK: - UPVOTE func
    private func upVote() {
        loadingUpVote = true

        guard let tiID = ti?.id else { loadingUpVote = false; return }
        guard let chainLink = chainLink else { loadingUpVote = false; return }
        guard let vlPost = vlPost else { loadingUpVote = false; return }

        if vlPost.upVotersUIDsArray.contains(currentUserUID) {
            print("💃")

            // Remove userUID from array
            PostManager.shared.updateVerticalListUpVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, userUID: currentUserUID, addOrRemove: .remove) { error in
                if let error { print("❌\(error.localizedDescription) ❌"); return }

                Task {
                    do {
                        try await PostManager.shared.changeVLUpVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .decrease)

                        DispatchQueue.main.async {
                            self.vlPost!.upVotersUIDsArray.remove(object: currentUserUID)
                            self.vlPost!.upVotes -= 1
                            self.vlPost!.totalVotes -= 1
                            self.loadingUpVote = false
                        }

                    } catch {
                        print("❌🗳️ 1 if upVoted 🗳️❌")
                        self.loadingUpVote = false
                    }
                }
            }

        } else {
            // If Down Voted
            if vlPost.downVotersUIDsArray.contains(currentUserUID) {
                print("💅")
                PostManager.shared.updateVerticalListDownVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, userUID: currentUserUID, addOrRemove: .remove) { error in
                    if error != nil { return }

                    Task {
                        do {
                            try await PostManager.shared.changeVLDownVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .decrease)

                            DispatchQueue.main.async {
                                self.vlPost!.downVotersUIDsArray.remove(object: currentUserUID)
                                self.vlPost!.downVotes -= 1
                                self.vlPost!.totalVotes += 1
                            }

                        } catch {
                            print("❌🗳️ 2 if upVoted 🗳️❌")
                        }
                    }
                }
            }

            // Not Voted
            print("🦁")
            PostManager.shared.updateVerticalListUpVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, userUID: currentUserUID, addOrRemove: .add) { error in
                if let error { print(error.localizedDescription); return }

                Task {
                    do {
                        try await PostManager.shared.changeVLUpVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .increase)

                        DispatchQueue.main.async {
                            self.vlPost!.upVotersUIDsArray.append(currentUserUID)
                            self.vlPost!.upVotes += 1
                            self.vlPost!.totalVotes += 1
                            self.loadingUpVote = false
                        }

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
        guard let vlPost = vlPost else { loadingDownVote = false; return }

        // If already voted Down
        if vlPost.downVotersUIDsArray.contains(currentUserUID) {
            print("💃")
            PostManager.shared.updateVerticalListDownVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, userUID: currentUserUID, addOrRemove: .remove) { error in
                if let error { print(error.localizedDescription); return }

                Task {
                    do {
                        try await PostManager.shared.changeVLDownVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .decrease)

                        DispatchQueue.main.async {
                            self.vlPost!.downVotersUIDsArray.remove(object: currentUserUID)
                            self.vlPost!.downVotes -= 1
                            self.vlPost!.totalVotes += 1
                            self.loadingDownVote = false
                        }

                    } catch {
                        print("❌🗳️ 4 if upVoted 🗳️❌")
                        self.loadingDownVote = false
                    }
                }
            }

        } else {
            // If UP-Voted
            if vlPost.upVotersUIDsArray.contains(currentUserUID) {
                print("💅")
                PostManager.shared.updateVerticalListUpVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, userUID: currentUserUID, addOrRemove: .remove) { error in
                    if error != nil { return }

                    Task {
                        do {
                            try await PostManager.shared.changeVLUpVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .decrease)

                            DispatchQueue.main.async {
                                self.vlPost!.upVotersUIDsArray.remove(object: currentUserUID)
                                self.vlPost!.upVotes -= 1
                                self.vlPost!.totalVotes -= 1
                            }

                        } catch {
                            print("❌🗳️ 5 if upVoted 🗳️❌")
                        }
                    }
                }
            }

            // Not Voted
            print("🦁")
            PostManager.shared.updateVerticalListDownVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, userUID: currentUserUID, addOrRemove: .add) { error in
                if let error { print(error.localizedDescription); return }

                Task {
                    do {
                        try await PostManager.shared.changeVLDownVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost.id, increaseOrDecrease: .increase)

                        DispatchQueue.main.async {
                            self.vlPost!.downVotersUIDsArray.append(currentUserUID)
                            self.vlPost!.downVotes += 1
                            self.vlPost!.totalVotes -= 1
                            self.loadingDownVote = false
                        }

                    } catch {
                        print("❌🗳️ 6 if upVoted 🗳️❌")
                        self.loadingDownVote = false
                    }
                }
            }
        }
    }

}

#Preview {
    TiView(ti: nil, showTiView: .constant(true))

//    VotingButtonsSV()
}
