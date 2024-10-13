//
//  TiViewModel.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 6/19/24.
//

import Foundation

final class TiViewModel: ObservableObject {
    
    @Published var ti: TI? = nil
    @Published var post: Post? = nil
    
    init() {
//        fetchTestTi { ti in
//            if ti != nil {
//                self.ti = ti!
//            }
//        }
        Task {
            try await getTestTi()
        }
    }
    
    
    func fetchTestTi(completion: @escaping (TI?) -> Void) {
        TIManager.shared.getTi(tiID: "7C3CF55B-7119-40BD-9709-E8D6EAB02353") { result in
            switch result {
            case .success(let ti):
                completion(ti)
            case .failure(_):
                completion(nil)
            }
        }
    }
    
    func getTestTi() async throws -> TI? {
        do {
            return try await TIManager.shared.fetchTI(tiID: "7C3CF55B-7119-40BD-9709-E8D6EAB02353")
        } catch {
            return nil
        }
    }
    
    func introPostIndex(ti: TI?) -> Int {
        if ti?.tiType == .d2 {
            return ti?.leftSideChain?.count ?? 0
        }
        return 0
    }
    
    //MARK: - Is Admin
    func isAdmin(ti: TI?, currentUserUID: String) -> Bool {
        guard let ti = ti else { return false }
        
        if ti.creatorUID == currentUserUID          { return true }
        if ti.tiAdminsUIDs.contains(currentUserUID) { return true }
        
        if ti.tiType == .d2 {
            if ( (ti.lsLevel1UsersUIDs?.contains(currentUserUID)) != nil) { return true }
            if ( (ti.rsLevel1UsersUIDs?.contains(currentUserUID)) != nil) { return true }
            
        } else if ti.tiType == .d1 {
            if ((ti.rsLevel1UsersUIDs?.contains(currentUserUID)) != nil) { return true }
        }
        
        return false
    }
    func hasAdminAccess(ti: TI?, currentUserUID: String) -> Bool {
        guard let ti = ti else { return false }
        
        if ti.creatorUID == currentUserUID          { return true }
        if ti.tiAdminsUIDs.contains(currentUserUID) { return true }
        
        return false
    }
    
    func introPostHasVideo(ti: TI?) async -> Bool {
        guard let ti else { return true }
        
        Task {
            do {
                let introPost = try await PostManager.shared.fetchPost(tiID: ti.id, postID: ti.id)
                
                if introPost!.type == .video { 
                    return true
                } else {
                    return false
                }
            } catch {
                print("❌ Error: introPostHasVideo  \(error) ❌")
                return false
            }
        }
        
        return true
    }
}
