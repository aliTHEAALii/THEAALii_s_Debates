//
//  VerticalListControlBar.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 7/26/24.
//

import SwiftUI

struct VerticalListControlBar: View {
    
    @AppStorage("current_user_uid") var currentUserUID: String = "BXnHfiEaIQZiTcpvWs0bATdAdJo1" //"ooo"

    @Binding var ti: TI?
    @Binding var tiChain: [String]
    @Binding var tiChainLink: ChainLink?
    var body: some View {
        
        //VL Header
        HStack(spacing: 0) {
 
            if !hasAdminAccess {
                Spacer()
                
                if canUploadToVL {
                    CCAddToChainButton(rightOrLeft: nil, ti: $ti, tiChainLink: $tiChainLink, tiChain: $tiChain)
                }
                
                Spacer()

                Text("Vertical List")
                    .foregroundColor(.secondary)

                Spacer()

                ChainLinkVLAccessButton(ti: $ti, tiChainLink: $tiChainLink)
                    .opacity(0.5)
                    .disabled(true)
                
                Spacer()

            } else {
                
                Spacer()
                
                Text("Vertical")
                    .foregroundColor(.secondary)
                    .frame(width: width * 0.3)
                
                Spacer()
                
                //MARK: Add Video to list
                if canUploadToVL {
                    CCAddToChainButton(rightOrLeft: nil, ti: $ti, tiChainLink: $tiChainLink, tiChain: $tiChain)
                }
                
                Spacer()
                
                Text("List")
                    .foregroundColor(.secondary)
                    .frame(width: width * 0.3)
                
                
                Spacer()
            }
        }
        .padding(.vertical)
            
    }
    
    //TODO: THIS VL Access
    var canUploadToVL: Bool {
        
        guard ti != nil else { return false }
        guard tiChainLink != nil else { return false }
        
        //selected cLIndex (left or right side)
        //ChainLink == open
        if tiChainLink!.listAccess == .open || tiChainLink!.listAccess == nil {
            
            return true
            
        } else {
            
//            if ti!.creatorUID == currentUserUID || ti!.tiAdminsUIDs.contains(currentUserUID) {
//                return true
//            } else {
//                return false
//            }
            return hasAdminAccess
        }
//        ti?.rsVerticalListAccess == "open"
//        ti?.leftSideChain == "open"
    }
    
    var hasAdminAccess: Bool {

        guard ti != nil else { return false }

        if ti!.creatorUID == currentUserUID || ti!.tiAdminsUIDs.contains(currentUserUID) {
            return true
        } else {
            return false
        }
    }
}

#Preview {
    TiView(ti: nil, showTiView: .constant(true))

//    VerticalListControlBar()
}





//MARK: - VL Access Button
struct ChainLinkVLAccessButton: View {
    
    @Binding var ti: TI?
    @Binding var tiChainLink: ChainLink?

    @State private var showSheet = false
    
    var body: some View {
        
        if ti != nil , tiChainLink != nil {
            Button {
                showSheet.toggle()
            } label: {
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: width * 0.001)
                        .frame(width: width * 0.12, height: width * 0.12)
                    
                    Text(tiChainLink?.listAccess == .open ? "Open" : "Closed")
                        .font(.system(size: width * 0.033))
                }
                .frame(width: width * 0.15, height: width * 0.15)
                .foregroundStyle(.white)
            }
            .sheet(isPresented: $showSheet) {
                
                VStack(spacing: width * 0.1) {
                    
                    Text("Note: You can change this at any time")
                        .foregroundStyle(.white)
                        .padding(.vertical, width * 0.15)
                    
                    Button {
                        Task {
                            do {
                                try await ChainLinkManager.shared.updateVerticalListAccess(tiID: ti!.id, chainLinkID: tiChainLink!.id, access: .open)
                                tiChainLink?.listAccess = .open
                                
                            } catch {
                                print("❌Error ChainLink access = .open Failed ❌")
                            }
                        }
                        showSheet = false
                    } label: {
                        ZStack {
                            
                            if tiChainLink?.listAccess == .open {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.ADColors.green.opacity(0.2))
                                    .frame(width: width * 0.95, height: width * 0.4)
                            } else {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(lineWidth: 2)
                                    .fill(Color.ADColors.green.opacity(0.2))
                                    .frame(width: width * 0.95, height: width * 0.4)
                            }
                            
                            //Words
                            VStack(spacing: width * 0.04) {
                                Text("OPEN")
                                    .padding(.bottom, width * 0.03)
                                
                                Text("[  Anyone  ]")
                                Text("Can upload to the Vertical List ")
                                
                            }
                            .foregroundStyle(.white)
                            
                        }
                        
                    }
                    
                    
                    
                    Button {
                        Task {
                            do {
                                try await ChainLinkManager.shared.updateVerticalListAccess(tiID: ti!.id, chainLinkID: tiChainLink!.id, access: .closed)
                                tiChainLink?.listAccess = .closed
                                
                            } catch {
                                print("❌Error ChainLink access = .closed Failed ❌")
                            }
                        }
                        showSheet = false
                    } label: {
                        ZStack {
                            if tiChainLink?.listAccess == .closed {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.ADColors.green.opacity(0.2))
                                    .frame(width: width * 0.95, height: width * 0.4)
                            } else {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(lineWidth: 2)
                                    .fill(Color.ADColors.green.opacity(0.2))
                                    .frame(width: width * 0.95, height: width * 0.4)
                            }
                            
                            
                            VStack(spacing: width * 0.04) {
                                Text("CLOSED")
                                    .padding(.bottom, width * 0.03)
                                
                                Text(closedAccessButtonText)
                                Text("Can upload to the Vertical List ")
                                
                            }
                            .foregroundStyle(.white)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
    var closedAccessButtonText: String {
        if ti?.tiType == .d1 {
            return "[ TI Creator & Admins  ]"
            
        } else { //TIType == .d2
            return "[  TI Creator  -  Admins  -  Teams  ]"
        }
        
    }
}

