//
//  UserLibraryTab.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 8/8/24.
//

import SwiftUI

struct UserLibraryTab: View {
    
    @AppStorage("current_user_uid") var currentUserUID: String = "BXnHfiEaIQZiTcpvWs0bATdAdJo1"
    @State var currentUser: UserModel? = nil
    
    @State private var savedTIsSelected = true
    
    var body: some View {
        
        NavigationStack {
            
            VStack(spacing: 0) {
                
                SavedTIsSelected(savedTIsSelected: $savedTIsSelected)
                
                if savedTIsSelected == true {
                    if currentUser != nil {
//                        List(0..<currentUser!.observingTIsIDs.count, id: \.self) { i in
//                            
//                            SavedTICell(index: i, tiID: currentUser!.observingTIsIDs[i])
//                            //.listRowSeparator(.hidden) // Hide separators between rows
//                            //.padding(.vertical, 0) // Remove vertical padding
//                        }
//                        .listStyle(PlainListStyle())
//                        .navigationTitle("Saved TIs")
//                        .onDelete {
//                            
//                        }
                        List {
                            ForEach(0..<currentUser!.observingTIsIDs.count, id: \.self) { i in
                                
                                SavedTICell(index: i, tiID: currentUser!.observingTIsIDs[i])
                                //.listRowSeparator(.hidden) // Hide separators between rows
                                //.padding(.vertical, 0) // Remove vertical padding
                            }
                            .onDelete(perform: <#T##Optional<(IndexSet) -> Void>##Optional<(IndexSet) -> Void>##(IndexSet) -> Void#>)
                            
                        }
                        .listStyle(PlainListStyle())
                        .navigationTitle("Saved TIs")
                    }
                    
                    //MARK: - Saved Users
                } else if savedTIsSelected == false {
                    if currentUser != nil {
                        List(0..<currentUser!.savedUsersUIDs.count, id: \.self) { i in
                            
                            HStack {
                                Spacer()
                                UserButton(userUID: currentUser!.savedUsersUIDs[i], horizontalName: true)
                            }
                        }
                        .listStyle(PlainListStyle())
                        .navigationTitle("Saved Users")
                        .refreshable {
                            
                        }
                    }
                    
                    //MARK: - Saved Users
                }
                Spacer()
            }
            .task {
                if currentUser == nil {
                    do {
                        currentUser = try await UserManager.shared.getUser(userId: currentUserUID)
                    } catch { print("❌ Error Couldn't get user for Library Tab❌") }
                }
            }
        }
    }
    
    //MARK: - Functions
    func deleteTiFromSavedTIs(at offset: IndexSet, tiID: String, currentUserUID: String) async {
        Task {
            await UserManager.shared.updateObservingTIs(tiUID: tiID, currentUserUID: currentUserUID, addOrRemove: .remove)
        }
    }
    func deleteUserFromSavedUsers(userUID: String, currentUserUID: String) {
        
    }
    
    func fetchUser() async throws {
        if currentUser == nil {
            currentUser = try await UserManager.shared.getUser(userId: currentUserUID)
        }
    }
}

#Preview {
    UserLibraryTab()
}

//MARK: - Pick Search Type Bar
struct SavedTIsSelected: View {
    
    @Binding var savedTIsSelected: Bool
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            Button {
                savedTIsSelected = true
            } label: {
                ZStack {
                    if savedTIsSelected == true {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 0.5)
                            .foregroundColor(.secondary)
                    }
                    Text("Saved TIs")
                        .font(.title2)
                }
                .frame(width: width * 0.4, height: width * 0.1)
            }
            
            Spacer()

            Button {
                savedTIsSelected = false
            } label: {
                ZStack {
                    if savedTIsSelected == false {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 0.5)
                            .foregroundColor(.secondary)
                    }
                    Text("Saved Users")
                        .font(.title2)
                }
                .frame(width: width * 0.4, height: width * 0.1)
            }

        }
        .foregroundColor(.primary)
        .frame(width: width * 0.85)
        .padding(.vertical)
    }
}


//MARK: Saved TI Cell
struct SavedTICell: View {
    
    let index: Int
    let tiID: String?
    
    @State private var ti: TI?
    
    @State private var showTiFSC: Bool = false
    
    var body: some View {
        
        Button {
            showTiFSC = true
        } label: {
            
            HStack(spacing: 0) {
                // 1. order
                Text("\(index + 1).")
                    .frame(width: width * 0.07)
                
                // 2. Thumbnail
                VStack(spacing: 5) {
                    ImageView(imageUrlString: ti?.thumbnailURL, scale: 0.4)
                    
                    if ti != nil {
                        MiniIndicatorsSV(ti: ti, tiChainCount: ti!.rightSideChain.count, scale: 1)
                    }
                }
                
                // 3. Title
                Text("\(ti?.title ??  "Debate Title: let's try something") ")
                    .multilineTextAlignment(.leading)
                    .padding(.leading, width * 0.02)
                    .frame(width: width * 0.53, alignment: .leading)
            }
        }
        .foregroundColor(.primary)
        .frame(height: width * 0.5625 * 0.45)
        .task {
            do {
                if let tiID {
                    ti = try await TIManager.shared.fetchTI(tiID: tiID)
                }
            } catch {  print("❌ Error Couldn't get TI for Library Tab Cell ❌") }
        }
        .fullScreenCover(isPresented: $showTiFSC) {
            TiView(ti: ti, showTiView: $showTiFSC)
        }
    }
    
    private func fetchTI() async throws {
//        TITManager.shared.getTIT(TITid: tiId)
    }
}
