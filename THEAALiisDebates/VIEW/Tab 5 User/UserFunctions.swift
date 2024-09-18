//
//  UserViewModel.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 9/17/24.
//

import Foundation

class UserFunctions {
    
    func userLabel(user: UserModel?) -> String {
        
        guard let user else { return "No User" }
        
        if !user.createdTIsIDs.isEmpty {
            return "Creator"
        } else {
            return "Observer"
        }
    }
    
    func userLabelIcon(user: UserModel?) -> String {
        guard let user else {  return "xmark" }
        
        if !user.createdTIsIDs.isEmpty {
            
            return "plus.square.fill"
            
        } else {
            
            return "eye"
        }
    }
    
}
