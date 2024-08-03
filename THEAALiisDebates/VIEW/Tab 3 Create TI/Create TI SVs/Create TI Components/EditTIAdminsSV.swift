//
//  EditTIAdminsSV.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 4/20/24.
//

import SwiftUI

struct EditTIAdminsSV: View {
    
    let currentUser: UserModel?
    @Binding var tiAdminsUIDs: [String]
    
    @State private var showEditAdmins = false
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            //
            HStack(spacing: 0) {
                //TI Creator
                UserButton(user: currentUser)
                    .padding(.leading, width * 0.02)
                
                Divider()
                    .padding(.leading, width * 0.02)
                
                //Admins
                ForEach(tiAdminsUIDs, id: \.self) { adminUID in
                    
                    UserButton(userUID: adminUID)
                        .padding(.leading, width * 0.02)
                }
            }
            .frame(width: width * 0.85, alignment: .leading)
            
            //Edit Button
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
                
                // 2. Creator
                HStack {
                    Text("TI Creator")
                        
                    
                    Spacer()
                    
                    UserButton(user: currentUser, horizontalName: true)
                }
                .foregroundStyle(.white)
                .frame(width: width, height: width * 0.15, alignment: .trailing)
                .padding(.vertical)
                
                Divider()
                
                //Admins
                HStack(spacing: 0) {
                    
                    //Admins
                    ForEach(tiAdminsUIDs, id: \.self) { adminUID in
                        
                        UserButton(userUID: adminUID)
                            .padding(.leading, width * 0.02)
                    }
                }
                .frame(width: width * 0.85, height: width * 0.15, alignment: .leading)
                
                Divider()
                
                
                Text("Saved Users")
                    .foregroundStyle(.white)
                    .font(.title)

                //AddOrRemove Saved Users
                if currentUser != nil {
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
                }
                
                Spacer()
            }
        }
        .frame(width: width, height: width * 0.2)
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
}

#Preview {
//    EditTIAdminsSV()
    
    CreateTI(showFSC: .constant(true), selectedTabIndex: .constant(2), indexStep: 2)

}


//MARK: Add Remove Create Ti Admin Cell
struct AddRemoveCTiAdminCell: View {
    
    
    @Binding var currentUser: UserModel
    @Binding var tiAdminsUIDs: [String]
    
    let userUID: String?
        
    var body: some View {
        
        
        HStack(spacing: 0) {
            
            
            Button {
                Task {
                    if addOrRemove == .add {
                        if let userUID {
                            tiAdminsUIDs.append(userUID)
                        }
                    } else if addOrRemove == .remove {
                        if let userUID {
                            tiAdminsUIDs.remove(object: userUID)
                        }
                    }
                }
            } label: {
                Image(systemName: addOrRemove == .add ? "plus.circle" : "minus.circle")
                    .font(.title)
                    .foregroundColor(addOrRemove == .add ? .ADColors.green : .red)
            }
            .padding()
            
            
            Spacer()
            
            
            UserButton(userUID: userUID, horizontalName: true)
        }
    }
    
    var addOrRemove: AddOrRemove {
        
        if !tiAdminsUIDs.contains(userUID ?? "No User UID" ) {
            return .add
        } else {
            return .remove
        }
    }
}
