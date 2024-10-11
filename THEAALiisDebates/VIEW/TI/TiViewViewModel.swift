//
//  Ti.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 10/11/24.
//

import Foundation
import Observation

@Observable class TiViewViewModel {
    
    var ti: TI? = nil
    
    
    init() { }
    init (ti: TI?) {
        self.ti = ti
    }
    
    
    
    func fetchTi(tiID: String?) async {
        guard let tiID else { return }
        
        Task {
            do {
                let ti = try await TIManager.shared.fetchTI(tiID: tiID) //API.fetchTi(tiID: tiID)
                self.ti = ti
            } catch {
                print("🆘🌎 Error @Observable Ti fetching Ti: \(error) 🌎🆘")
            }
        }
    }
    
    
    
}
