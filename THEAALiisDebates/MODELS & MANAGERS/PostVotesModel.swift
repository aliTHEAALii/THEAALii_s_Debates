//
//  VotesModel.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 9/6/24.
//

import Foundation


struct PostVotesModel: Codable, Hashable, Equatable {
    
    static func ==(lhs: PostVotesModel, rhs: PostVotesModel) -> Bool {
        lhs.id == rhs.id
    }
}
