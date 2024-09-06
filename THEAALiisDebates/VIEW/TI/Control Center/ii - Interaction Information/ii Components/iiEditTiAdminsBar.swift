//
//  iiEditTiAdminsBar.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 8/3/24.
//

import SwiftUI

//MARK: - ii Edit Admin SV --------
struct iiEditTiAdminsBar: View {
    
    @AppStorage("current_user_uid") var currentUserUID: String = "BXnHfiEaIQZiTcpvWs0bATdAdJo1"
    
    @State private var currentUser: UserModel?
    @Binding var ti: TI?
    @State var tiAdminsUIDs: [String] = []
    
    @State private var showEditAdmins = false
    
    var body: some View {
        
        //MARK: - Bar SubView
        HStack(spacing: 0) {
            
            if ti != nil {
                HStack(spacing: 0) {
                    
                    Text("Admins: ")
                    
                    //Admins
                    if tiAdminsUIDs.isEmpty {
                        
                        Spacer()
                        
                        Text("No Admins")
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                    } else {
                        ForEach(tiAdminsUIDs, id: \.self) { adminUID in

                            
                            UserButton(userUID: adminUID)
                                .padding(.leading, width * 0.02)
                        }
                    }
                }
                .frame(width: width * 0.85, alignment: .leading)
            }
            
            //MARK: Edit Admins Button ----
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
                        ForEach(tiAdminsUIDs, id: \.self) { adminUID in
                            
                            //MARK: - Vertical edit
                            VStack(spacing: 10) {
                                
                                
                                UserButton(userUID: adminUID)
                                
                                //MARK: - Remove Admin button
                                Button {
                                    Task { await addOrRemoveAdmin(adminUID: adminUID, remove: true) }
                                    print("🟠 remove admin pressed 🟠")
                                } label: {
                                    Image(systemName: "minus.circle")
                                        .foregroundStyle(.red)
                                }
                            }
                        }
                    }
                }
                .frame(width: width * 0.85, height: width * 0.25, alignment: .leading)
                
                Divider()
                
                //MARK: - Your saved users
                Text("Your Saved Users")
                    .foregroundStyle(.white)
                    .font(.title)
                
                //AddOrRemove Saved Users
                if currentUser != nil {
                    Text(currentUser?.userUID ?? "no user yet")
                }
                if currentUser != nil, !currentUser!.savedUsersUIDs.isEmpty {
                    
                    ForEach(currentUser!.savedUsersUIDs, id: \.self) { savedUserUID in
                        HStack {
                            
                            AddRemoveCTiAdminCell(
                                currentUser: .constant(currentUser!),
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
        .onAppear { Task { await fetchUser(); await fetchTI() } }
        .onChange(of: showEditAdmins) { _, _ in
            Task {
                do {
                    try await TIManager.shared.newAdmins(tiID: ti!.id, adminsUIDsArray: tiAdminsUIDs)
                } catch {
                    print("❌ Error updating admins: \(error.localizedDescription) ❌")
                }
            }
        }
//        .onChange(of: tiAdminsUIDs) { _, _ in ti!.tiAdminsUIDs = tiAdminsUIDs }
    }
    
    //MARK: - Function ----
    func addOrRemoveAdmin(adminUID: String, remove: Bool = false) async {
        guard currentUser != nil, ti != nil else { return }
        
        if remove {
            do {
                try await TIManager.shared.editAdmins(tiID: ti!.id, userUID: adminUID, addOrRemove: .remove)
                tiAdminsUIDs.remove(object: adminUID)
                ti!.tiAdminsUIDs.remove(object: adminUID)
                
            } catch {
                print("🆘 Error : \(error.localizedDescription) 🆘")
            }
            
        } else {
            if adminsLessThan4 {
                do {
                    try await TIManager.shared.editAdmins(tiID: ti!.id, userUID: adminUID, addOrRemove: .add)
                    tiAdminsUIDs.append(adminUID)
                    ti!.tiAdminsUIDs.append(adminUID)
                } catch {
                    print("🆘 Error : \(error.localizedDescription) 🆘")
                }
            }
        }
        
        if !currentUser!.savedUsersUIDs.contains(adminUID) {
            tiAdminsUIDs.append(adminUID)
        }
    }
    
    func fetchUser() async {
        do {
            self.currentUser = try await UserManager.shared.getUser(userId: currentUserUID)
            tiAdminsUIDs = ti!.tiAdminsUIDs
        } catch { print("❌ Couldn't fetch User: \(error.localizedDescription) ❌") }
    }
    func fetchTI() async {
        do {
            let newTI = try await TIManager.shared.fetchTI(tiID: ti!.id)
            tiAdminsUIDs = newTI?.tiAdminsUIDs ?? []
            
        } catch { print("❌ Couldn't fetch TI: \(error.localizedDescription) ❌") }
    }
    
    var adminsLessThan4: Bool {
        guard let ti else { return false }
        return ti.tiAdminsUIDs.count < 4
    }
    
    func removeAdmin(adminUID: String) {
        ti!.tiAdminsUIDs.remove(object: adminUID)
    }
}


//MARK: - Preview
#Preview {
//    iiEditTiAdminsBar()
    
    TiView(ti: nil, showTiView: .constant(true))
}
