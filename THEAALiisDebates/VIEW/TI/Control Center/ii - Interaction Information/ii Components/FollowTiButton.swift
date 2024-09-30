//
//  FollowTiButton.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 7/25/24.
//

import SwiftUI

struct FollowTiButton: View {
    
    @AppStorage("current_user_uid") var currentUserUID: String = "BXnHfiEaIQZiTcpvWs0bATdAdJo1"
    @Binding var currentUser: UserModel?
    
    @Binding var ti: TI?
    
    @Binding var notFollowingTi: Bool
    @State private var isLoading: Bool = false
    
    var body: some View {
        //MARK: Follow Button
        
        ZStack {
            if ti != nil {
                if !isLoading {
                    Button {
                        
                        Task {
                            if notFollowingTi {
                                await followTi(ti: ti, userUID: currentUserUID, addOrRemove: .add)
                                
                                
                            } else {
                                await followTi(ti: ti, userUID: currentUserUID, addOrRemove: .remove)
                            }
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
                    ProgressView()
                        .frame(width: width * 0.15, height: width * 0.15)
                }
            } else {
                Rectangle()
                    .foregroundStyle(.clear)
                    .frame(width: width * 0.15, height: width * 0.15)
            }
        }
        .onAppear {
            isLoading = true
            notFollowingTi = notFollowingTiFunc()
            isLoading = false
        }
    }
    
    func notFollowingTiFunc() -> Bool {
        guard ti != nil, currentUser != nil else { return false }
        
        if ti!.tiObserversUIDs.contains(currentUserUID) || currentUser!.observingTIsIDs.contains(ti!.id) { return false }
        
        return true
        
//        guard ti != nil, currentUser != nil else { return false }
//        
//        if ti!.tiObserversUIDs.contains(currentUserUID) || currentUser!.observingTIsIDs.contains(ti!.id) { return false }
//        
//        return true
    }
    
    private func followTi(ti: TI?, userUID: String, addOrRemove: AddOrRemove) async {
        guard ti != nil else { return }
        
        isLoading = true
        Task {
            if addOrRemove == .add {
                do {
                    try await UserManager.shared.updateObservingTIs(tiUID: ti!.id, currentUserUID: currentUserUID, addOrRemove: .add)
                    
                    try await TIManager.shared.updateObserversUIDs(tiUID: ti!.id, currentUserUID: currentUserUID, addOrRemove: .add)
                
                    self.ti!.tiObserversUIDs.append(currentUserUID)
                    print("🟢🧸success Observing \(notFollowingTi) Ti: \(ti!.id) 🚦 userUID: \(currentUserUID)")
                    
                    notFollowingTi = false
                    isLoading = false
                    
                    print("🟢111🧸success Observing \(notFollowingTi) Ti: \(ti!.id) 🚦 userUID: \(currentUserUID)")

                } catch {
                    print("🔴Error Observing Ti: \(error.localizedDescription)🔴")
                    notFollowingTi = true
                    isLoading = false
                    return
                }
                
            } else { //remove
                do {
                    try await UserManager.shared.updateObservingTIs(tiUID: ti!.id, currentUserUID: currentUserUID, addOrRemove: .remove)
                    
                    try await TIManager.shared.updateObserversUIDs(tiUID: ti!.id, currentUserUID: currentUserUID, addOrRemove: .remove)
                    
                    self.ti!.tiObserversUIDs.remove(object: currentUserUID)
                    print("🟢🔪success removing Observing \(notFollowingTi) Ti   \(ti!.id) 🚦 userUID: \(currentUserUID)")
                    
                    notFollowingTi = true
                    isLoading = false
                    print("🟢222🧸success removing \(notFollowingTi) Ti: \(ti!.id) 🚦 userUID: \(currentUserUID)")

                } catch {
                    print("🔴Error removing Observing Ti: \(error.localizedDescription)🔴")
                    notFollowingTi = false
                    isLoading = false
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
