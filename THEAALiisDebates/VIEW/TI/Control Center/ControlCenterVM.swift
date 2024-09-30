//
//  TIContolCenterViewModel.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 5/18/23.
//

import Foundation

final class ControlCenterViewModel {
    
    func tiChain(ti: TI?) -> [String] {
        guard let ti = ti else { return [] }
        
        var tiChain: [String] = []
        
        if ti.tiType == .d1 {
            tiChain = [ti.introPostID] + ti.rightSideChain
            
        } else if ti.tiType == .d2 {
            tiChain = ( ti.leftSideChain?.reversed() ?? [] ) + [ti.introPostID] + ti.rightSideChain
        }
        
        return tiChain
    }
    
    
    //CCMap for post order tag
    func order(ti: TI, index: Int) -> Int {
        if ti.tiType == .d1 {
            return index
        } else if ti.tiType == .d2 {
            
            
            if index < ti.leftSideChain?.count ?? 0 {
                return (ti.leftSideChain?.count ?? 0) - index
            }
            return index - (ti.leftSideChain?.count ?? 0)
        } else {
            return 0
        }
    }
    

    func introPostIndex(ti: TI?) -> Int {
        if ti?.tiType == .d2 {
            return ti?.leftSideChain?.count ?? 0
        }
        return 0
    }
    
    
    func isAdmin(ti: TI?, currentUserUID: String) -> Bool {
        guard let ti = ti else { return false }
        if ti.tiAdminsUIDs.contains(currentUserUID) { return true }
        if ti.creatorUID == currentUserUID { return true }
        return false
    }
    
    func notFollowingTiFunc(currentUserUID: String, ti: TI?, currentUser: UserModel?) -> Bool {
        guard ti != nil, currentUser != nil else { return false }
        
        if ti!.tiObserversUIDs.contains(currentUserUID) || currentUser!.observingTIsIDs.contains(ti!.id) { return false }
        
        return true
    }
}
