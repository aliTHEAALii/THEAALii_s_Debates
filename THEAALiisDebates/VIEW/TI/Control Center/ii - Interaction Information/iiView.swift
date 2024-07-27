//
//  iiView.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 6/19/24.
//

import SwiftUI

struct iiView: View {
    
    @AppStorage("current_user_uid") var currentUserUID: String = "BXnHfiEaIQZiTcpvWs0bATdAdJo1"
    //TODO: USERMODEL
    
    @Binding var ti: TI?
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            // 1. Top
            //if ti != nil {
//            if ti?.tiType == .d2 {
//                ZStack {
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(lineWidth: 0.5)
//                        .foregroundColor(.gray)
//                        .frame(width: width * 0.9, height: width * 0.08)
//                    
//                    HStack {
//                        UserButton(userUID: nil)
//                        Spacer()
//                        TIIcon()
//                        Spacer()
//                        UserButton(userUID: nil)
//                    }
//                }
//                .frame(height: width * 0.25)
//            }
            if let ti {
                D2IconBarNew(ti: ti)
            }
            //}
            
            // 2. Title
            Text(ti?.title ?? "")
                .font(.title)
                .padding()
            // 2. Thumbnail
            
            

            
//            Divider()
            

            
            //5. Votes (Up - Total - Down)
            
            //6. Description
            Text(ti?.description ?? "No Description")
                .multilineTextAlignment(.center)
                .padding()
            
            // 3. Creator
            HStack(spacing: 0) {
                Text("Ti Creator:")
                
                Spacer()
                
                UserButton(userUID: ti?.creatorUID, horizontalName: true)
            }
            .frame(height: width * 0.15)
            
            Divider()
            
            //4. Admins
            if ti != nil {
                iiEditTiAdminsSV(ti: $ti)
            }
            
            
            HStack {
                
                Spacer()
                
                FollowTiButton(ti: $ti)
                    .padding(.trailing, width * 0.001)
            }
            
            Spacer()
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    iiView(ti: .constant(TiViewModel().ti))
//    TestingModels().tiFromDBID2
//    TiViewModel().ti
}


//MARK: - ii Edit Admin SV
struct iiEditTiAdminsSV: View {
    
    @AppStorage("current_user_uid") var currentUserUID: String = "BXnHfiEaIQZiTcpvWs0bATdAdJo1"
    
    
    @State private var currentUser: UserModel?
    @Binding var ti: TI?
    @State var tiAdminsUIDs: [String] = []
    
    @State private var showEditAdmins = false
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            
            if ti != nil {
                HStack(spacing: 0) {
                    
                    Text("Admins: ")

                    //Admins
                    ForEach(ti!.tiAdminsUIDs, id: \.self) { adminUID in
                        
                        UserButton(userUID: adminUID)
                            .padding(.leading, width * 0.02)
                    }
                }
                .frame(width: width * 0.85, alignment: .leading)
            }
            
            //MARK: Edit Button
            Button {
                showEditAdmins.toggle()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: width * 0.001)
                        .frame(width: width * 0.12, height: width * 0.12)
                    
                    Text("Edit")
                }
                .frame(width: width * 0.15, height: width * 0.15)
                .foregroundStyle(.white)
            }
            //MARK: - Full Screen Cover
            .fullScreenCover(isPresented: $showEditAdmins) {
                
                FSCHeaderSV(showFSC: $showEditAdmins, text: "Edit Admins")
                
                
                Divider()
                
                //Admins
                HStack(spacing: 10) {
                    
                    if ti != nil {
                        //Admins
                        ForEach(ti!.tiAdminsUIDs, id: \.self) { adminUID in
                            
                            VStack(spacing: 10) {
                                
                                
                                UserButton(userUID: adminUID)
                                
                                //MARK: - Remove Admin button
                                Button {
                                    
                                } label: {
                                    Image(systemName: "x.circle")
                                        .foregroundStyle(.red)
                                }
                            }
                            
                        }
                    }
                }
                .frame(width: width * 0.85, height: width * 0.25, alignment: .leading)
                
                Divider()
                
                Text(currentUserUID)

                Text("Saved Users")
                    .foregroundStyle(.white)
                    .font(.title)
                
                //AddOrRemove Saved Users
                if let currentUser = currentUser, !currentUser.savedUsersUIDs.isEmpty {
                    
                    ForEach(currentUser.savedUsersUIDs, id: \.self) { savedUserUID in
                        HStack {
                            
                            
                            AddRemoveCTiAdminCell(
                                currentUser: .constant(currentUser),
                                tiAdminsUIDs: $tiAdminsUIDs,
                                userUID: savedUserUID
                            )
                        }
                        .frame(width: width, height: width * 0.15, alignment: .trailing)
                    }
                } else {
                    
                        Spacer()
                        Text("No Saved Users")
                        Spacer()
                }
                
                Spacer()
            }
        }
        .frame(width: width, height: width * 0.2)
        .onAppear{
            Task { await fetchUser() }
            tiAdminsUIDs = ti!.tiAdminsUIDs
        }
        .onChange(of: tiAdminsUIDs) { _, _ in
            guard ti != nil else { return }
            ti!.tiAdminsUIDs = tiAdminsUIDs
        }
    }
    
    func addOrRemoveAdmin(adminUID: String) {
        guard let currentUser else { return }
        
        if currentUser.savedUsersUIDs.contains(adminUID) {
            tiAdminsUIDs.remove(object: adminUID)
        }
        
        if !currentUser.savedUsersUIDs.contains(adminUID) {
            tiAdminsUIDs.append(adminUID)
        }
    }
    
    func fetchUser() async {
        Task {
            do {
                self.currentUser = try await UserManager.shared.getUser(userId: currentUserUID)
                tiAdminsUIDs = ti!.tiAdminsUIDs

            } catch {
                print("❌ Couldn't fetch right or left User ❌")
            }
        }
    }
    
    var adminsLessThan4: Bool {
        guard let ti else { return false }
        return ti.tiAdminsUIDs.count < 4
    }
    
    func removeAdmin(adminUID: String) {
        ti!.tiAdminsUIDs.remove(object: adminUID)
    }
}
