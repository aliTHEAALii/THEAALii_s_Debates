//
//  CCBottomBar.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 7/13/24.
//

import SwiftUI

struct CCBottomBar: View {
    
    @AppStorage("current_user_uid") var currentUserUID: String = "BXnHfiEaIQZiTcpvWs0bATdAdJo1"
    @Binding var currentUser: UserModel?
    @Binding var ti: TI?
    @Binding var tiChain: [String]
    
    @State private var notFollowingTi: Bool = true
    
    var body: some View {
        
        //MARK: - Control Center Bottom(interaction) Bar
        HStack(spacing:0) {
            
            //Left Side
            if ti?.tiType == .d2 {
                UserButton(userUID: ti?.lsUserUID)
                    .frame(width: width * 0.2)      //u
                
                //AddButtonSV()   //width * 0.15
                if ti != nil {
                    if TiViewModel().isAdmin(ti: ti, currentUserUID: currentUserUID) {
                        CCAddToChainButton(rightOrLeft: .left, ti: $ti, tiChainLink: .constant(nil), tiChain: $tiChain)
                    } else {
                        
                        FollowTiButton(currentUser: $currentUser, ti: $ti, notFollowingTi: $notFollowingTi)
                        
                    }
                } else {
                    Rectangle()
                        .foregroundStyle(.clear)
                        .frame(width: width * 0.15)
                }
            } else if ti?.tiType == .d1 {
//                Rectangle()
//                    .foregroundStyle(.clear)
//                    .frame(width: width * 0.3)
                Spacer()
            }
            
            
            //( Interaction Info ) Button
            iiButton( currentUser: $currentUser, ti: $ti)
            
            //Right Side                                        //width * 0.15
            if ti != nil {
                if hasAdminAccess {
                    CCAddToChainButton(rightOrLeft: .right, ti: $ti, tiChainLink: .constant(nil), tiChain: $tiChain)
                } else {
                    
                    FollowTiButton(currentUser: $currentUser, ti: $ti, notFollowingTi: $notFollowingTi)

                }
            } else {
                Rectangle()
                    .foregroundStyle(.clear)
                    .frame(width: width * 0.15)
            }
            
            UserButton(userUID: ti?.rsUserUID)
                .frame(width: width * 0.2)      //u
        }
        .frame(width: width, height: width * 0.25)
        .onAppear{
            notFollowingTi = ControlCenterViewModel().notFollowingTiFunc(currentUserUID: currentUserUID, ti: ti, currentUser: currentUser) }
    }
    
    
    private var hasAdminAccess: Bool {
        guard let ti else { return false }
        //ti
        if ti.creatorUID == currentUserUID { return true }
        if ti.tiAdminsUIDs.contains(currentUserUID) { return true }
        //Left & Right
        if ti.lsUserUID == currentUserUID || ti.rsUserUID == currentUserUID { return true }
        //Teams
        if ((ti.lsLevel1UsersUIDs?.contains(currentUserUID)) != nil) { return true }
        if ((ti.rsLevel1UsersUIDs?.contains(currentUserUID)) != nil) { return true }
        
        return false
    }
    
//    func followTi(ti: TI?, userUID: String, addOrRemove: AddOrRemove) async throws {
//        guard let ti else { return }
//        
//        Task {
//            if addOrRemove == .add {
//                do {
//                    try await UserManager.shared.updateObservingTIs(tiUID: ti.id, currentUserUID: currentUserUID, addOrRemove: .add)
//                    try await TIManager.shared.updateObserversUIDs(tiUID: ti.id, currentUserUID: currentUserUID, addOrRemove: .add)
//                    print("🟢success Observing Ti")
//                } catch {
//                    print("🔴Error Observing Ti: \(error.localizedDescription)🔴")
//                    return
//                }
//                
//            } else { //remove
//                do {
//                    try await UserManager.shared.updateObservingTIs(tiUID: ti.id, currentUserUID: currentUserUID, addOrRemove: .remove)
//                    try await TIManager.shared.updateObserversUIDs(tiUID: ti.id, currentUserUID: currentUserUID, addOrRemove: .remove)
//                    print("🟢success removing Observing Ti")
//                } catch {
//                    print("🔴Error removing Observing Ti: \(error.localizedDescription)🔴")
//                    return
//                }
//            }
//        }
//    }
}

#Preview {
//    CCBottomBar()
    
    TiView(ti: TestingModels().testTI1nil, showTiView: .constant(true))

}
