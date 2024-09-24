//
//  VotingVM.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 9/5/24.
//

import Foundation



//@MainActor
//final class VotingVM {
//    
//    
//    func onAppearAssignValues(vlPost: Post) {
//
//    }
//    
//        //MARK: - UPVOTE func
//    func upVote(ti: TI?, chainLink: ChainLink?, vlPost: inout Post?, currentUserUID: String, loadingUpVote: inout Bool) async -> Bool {
//        
//                    loadingUpVote = true
//        
//        guard let tiID = ti?.id         else { loadingUpVote = false; return false }
//        guard let chainLink = chainLink else { loadingUpVote = false; return false }
//        guard vlPost != nil             else { loadingUpVote = false; return false }
//        
//        if vlPost!.upVotersUIDsArray.contains(currentUserUID) {
//            print("💃")
//            
//            // Remove userUID from array
//            PostManager.shared.updateVerticalListUpVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, userUID: currentUserUID, addOrRemove: .remove) { [self] error in
//                if let error { print("❌\(error.localizedDescription) ❌"); return }
//                
//                Task {
//                    do {
//                        try await PostManager.shared.changeVLUpVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, increaseOrDecrease: .decrease)
//                        
//                        vlPost!.upVotersUIDsArray.remove(object: currentUserUID)
//                        vlPost!.upVotes -= 1
//                        vlPost!.totalVotes -= 1
////                        vlPost.loadingUpVote = false
//                        
//                    } catch {
//                        print("❌🗳️ 1 if upVoted 🗳️❌")
////                        self.loadingUpVote = false
//                    }
//                }
//            }
//            
//        } else {
//            // If Down Voted
//            if vlPost!.downVotersUIDsArray.contains(currentUserUID) {
//                print("💅")
//                PostManager.shared.updateVerticalListDownVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, userUID: currentUserUID, addOrRemove: .remove) { [self] error in
//                    if error != nil { return }
//                    
//                    Task {
//                        do {
//                            try await PostManager.shared.changeVLDownVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, increaseOrDecrease: .decrease)
//                            
//                            vlPost!.downVotersUIDsArray.remove(object: currentUserUID)
//                            vlPost!.downVotes -= 1
//                            vlPost!.totalVotes += 1
//                            
//                        } catch {
//                            print("❌🗳️ 2 if upVoted 🗳️❌")
//                        }
//                    }
//                }
//            }
//            
//            // Not Voted
//            print("🦁")
//            PostManager.shared.updateVerticalListUpVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, userUID: currentUserUID, addOrRemove: .add) { error in
//                if let error { print(error.localizedDescription); return }
//                
//                Task {
//                    do {
//                        try await PostManager.shared.changeVLUpVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, increaseOrDecrease: .increase)
//                        
//                        vlPost!.upVotersUIDsArray.append(currentUserUID)
//                        vlPost!.upVotes += 1
//                        vlPost!.totalVotes += 1
//                        loadingUpVote = false
//                        return true
//                        
//                    } catch {
//                        print("❌🗳️ 3 if upVoted 🗳️❌")
//                        loadingUpVote = false
//                        return false
//                    }
//                }
//            }
//        }
//        
//        return true
//    }
//}


//import Observation
//@Observable final class VotingViewModel {
//    
//    var currentUserUID: String = ""
//    var loadingUpVote: Bool = false
//    var loadingDownVote: Bool = false
//    
//    var upVotes:    Int = 0
//    var downVotes:  Int = 0
//    var totalVotes: Int = 0
//    var upVotersUIDsArray: [String] = []
//    var downVotersUIDsArray: [String] = []
//    
//    func onAppearAssignValues(vlPost: Post, currentUserUID: String) {
//        
//        self.currentUserUID = currentUserUID
//        
//        upVotes = vlPost.upVotes
//        downVotes = vlPost.downVotes
//        totalVotes = vlPost.totalVotes
//        upVotersUIDsArray = vlPost.upVotersUIDsArray
//        downVotersUIDsArray = vlPost.downVotersUIDsArray
//    }
//    
//    //MARK: - UPVOTE func
//    func upVote(ti: TI?, chainLink: ChainLink?, vlPost: Post?) {
//        
//        loadingUpVote = true
//        
//        guard let tiID = ti?.id         else { loadingDownVote = false; return }
//        guard let chainLink = chainLink else { loadingDownVote = false; return }
//        guard vlPost != nil             else { loadingDownVote = false; return }
//        
//        if upVotersUIDsArray.contains(currentUserUID) {
//            print("💃")
//            
//            // Remove userUID from array
//            PostManager.shared.updateVerticalListUpVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, userUID: currentUserUID, addOrRemove: .remove) { [self] error in
//                if let error { print("❌\(error.localizedDescription) ❌"); return }
//                
//                Task {
//                    do {
//                        try await PostManager.shared.changeVLUpVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, increaseOrDecrease: .decrease)
//                        
//                        upVotersUIDsArray.remove(object: currentUserUID)
//                        upVotes -= 1
//                        totalVotes -= 1
//                        loadingUpVote = false
//                        
//                    } catch {
//                        print("❌🗳️ 1 if upVoted 🗳️❌")
//                        self.loadingUpVote = false
//                    }
//                }
//            }
//            
//        } else {
//            // If Down Voted
//            if downVotersUIDsArray.contains(currentUserUID) {
//                print("💅")
//                PostManager.shared.updateVerticalListDownVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, userUID: currentUserUID, addOrRemove: .remove) { [self] error in
//                    if error != nil { return }
//                    
//                    Task {
//                        do {
//                            try await PostManager.shared.changeVLDownVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, increaseOrDecrease: .decrease)
//                            
//                            downVotersUIDsArray.remove(object: currentUserUID)
//                            downVotes -= 1
//                            totalVotes += 1
//                            
//                        } catch {
//                            print("❌🗳️ 2 if upVoted 🗳️❌")
//                        }
//                    }
//                }
//            }
//            
//            // Not Voted
//            print("🦁")
//            PostManager.shared.updateVerticalListUpVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, userUID: currentUserUID, addOrRemove: .add) { [self] error in
//                if let error { print(error.localizedDescription); return }
//                
//                Task {
//                    do {
//                        try await PostManager.shared.changeVLUpVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, increaseOrDecrease: .increase)
//                        
//                        upVotersUIDsArray.append(currentUserUID)
//                        upVotes += 1
//                        totalVotes += 1
//                        loadingUpVote = false
//                        
//                    } catch {
//                        print("❌🗳️ 3 if upVoted 🗳️❌")
//                        self.loadingUpVote = false
//                    }
//                }
//            }
//        }
//    }
//    
//    
//    //MARK: - DOWNVOTE func
//    private func downVote(ti: TI?, chainLink: ChainLink?, vlPost: Post?) {
//        
//        loadingDownVote = true
//        
//        guard let tiID = ti?.id         else { loadingDownVote = false; return }
//        guard let chainLink = chainLink else { loadingDownVote = false; return }
//        guard vlPost != nil             else { loadingDownVote = false; return }
//        
//        // If already voted Down
//        if downVotersUIDsArray.contains(currentUserUID) {
//            print("💃")
//            PostManager.shared.updateVerticalListDownVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, userUID: currentUserUID, addOrRemove: .remove) { [self] error in
//                if let error { print(error.localizedDescription); return }
//                
//                Task {
//                    do {
//                        try await PostManager.shared.changeVLDownVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, increaseOrDecrease: .decrease)
//                        
//                        downVotersUIDsArray.remove(object: currentUserUID)
//                        downVotes -= 1
//                        totalVotes += 1
//                        loadingDownVote = false
//                        
//                    } catch {
//                        print("❌🗳️ 4 if upVoted 🗳️❌")
//                        self.loadingDownVote = false
//                    }
//                }
//            }
//            
//        } else {
//            // If UP-Voted
//            if upVotersUIDsArray.contains(currentUserUID) {
//                print("💅")
//                PostManager.shared.updateVerticalListUpVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, userUID: currentUserUID, addOrRemove: .remove) { [self] error in
//                    if error != nil { return }
//                    
//                    Task {
//                        do {
//                            try await PostManager.shared.changeVLUpVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, increaseOrDecrease: .decrease)
//                            
//                            upVotersUIDsArray.remove(object: currentUserUID)
//                            upVotes -= 1
//                            totalVotes -= 1
//                            
//                        } catch {
//                            print("❌🗳️ 5 if upVoted 🗳️❌")
//                        }
//                    }
//                }
//            }
//            
//            // Not Voted
//            print("🦁")
//            PostManager.shared.updateVerticalListDownVotersArray(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, userUID: currentUserUID, addOrRemove: .add) { [self] error in
//                if let error { print(error.localizedDescription); return }
//                
//                Task {
//                    do {
//                        try await PostManager.shared.changeVLDownVotes(tiID: tiID, chainLinkID: chainLink.id, postID: vlPost!.id, increaseOrDecrease: .increase)
//                        
//                        downVotersUIDsArray.append(currentUserUID)
//                        downVotes += 1
//                        totalVotes -= 1
//                        loadingDownVote = false
//                        
//                    } catch {
//                        print("❌🗳️ 6 if upVoted 🗳️❌")
//                        self.loadingDownVote = false
//                    }
//                }
//            }
//        }
//    }
//}
