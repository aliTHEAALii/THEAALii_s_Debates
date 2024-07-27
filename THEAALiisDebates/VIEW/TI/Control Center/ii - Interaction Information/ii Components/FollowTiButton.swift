//
//  FollowTiButton.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 7/25/24.
//

import SwiftUI

struct FollowTiButton: View {
    
    @AppStorage("current_user_uid") var currentUserUID: String = "BXnHfiEaIQZiTcpvWs0bATdAdJo1"

    @Binding var ti: TI?
    
    var body: some View {
        //MARK: Follow Button
        
        if ti != nil {
            Button {
                
                if notFollowingTi {
                    followTi(ti: ti, userUID: currentUserUID, addOrRemove: .add)
                } else {
                    followTi(ti: ti, userUID: currentUserUID, addOrRemove: .remove)
                }
                
            } label: {
                if notFollowingTi {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .foregroundStyle(.gray)
                            .frame(width: width * 0.15, height: width * 0.15)
                        
                        Text("Follow Ti")
                            .foregroundStyle(Color.ADColors.green)
                            .multilineTextAlignment(.center)
                            .frame(width: width * 0.15, height: width * 0.15)

                    }
                } else {
                    ZStack {
                        Text("Following Ti")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                            .frame(width: width * 0.15, height: width * 0.15)

                    }
                }
            }
            
        } else {
            Rectangle()
                .foregroundStyle(.clear)
                .frame(width: width * 0.15)
        }
    }
    
    var notFollowingTi: Bool {
        guard ti != nil else { return false }
        if ti!.tiObserversUIDs.contains(currentUserUID) { return false }
        return true
    }
    
    private func followTi(ti: TI?, userUID: String, addOrRemove: AddOrRemove) {
        guard ti != nil else { return }
        
        Task {
            if addOrRemove == .add {
                do {
                    try await UserManager.shared.updateObservingTIs(tiUID: ti!.id, currentUserUID: currentUserUID, addOrRemove: .add)
                    try await TIManager.shared.updateObserversUIDs(tiUID: ti!.id, currentUserUID: currentUserUID, addOrRemove: .add)
                
                    self.ti!.tiObserversUIDs.append(currentUserUID)
                    print("🟢🧸success Observing Ti: \(ti!.id) 🚦 userUID: \(currentUserUID)")
                } catch {
                    print("🔴Error Observing Ti: \(error.localizedDescription)🔴")
                    return
                }
                
            } else { //remove
                do {
                    try await UserManager.shared.updateObservingTIs(tiUID: ti!.id, currentUserUID: currentUserUID, addOrRemove: .remove)
                    try await TIManager.shared.updateObserversUIDs(tiUID: ti!.id, currentUserUID: currentUserUID, addOrRemove: .remove)
                    
                    self.ti!.tiObserversUIDs.remove(object: currentUserUID)
                    print("🟢🔪success removing Observing Ti   \(ti!.id) 🚦 userUID: \(currentUserUID)")
                } catch {
                    print("🔴Error removing Observing Ti: \(error.localizedDescription)🔴")
                    return
                }
            }
        }
    }
}

#Preview {
    TiView(ti: TestingModels().testTI1nil, showTiView: .constant(true))

//    FollowTiButton()
}
