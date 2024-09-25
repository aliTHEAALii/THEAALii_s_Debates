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
    @State private var observingTIsIDs: [String] = []
    @State private var savedUsersUIDs: [String?] = []
    
    @State private var savedTIsSelected = true
    //
    @State private var editButtonPressed = false
    @State private var isLoading = false
    
    var body: some View {
        
        NavigationStack {
            
            VStack(spacing: 0) {
                
                SavedTIsSelected(savedTIsSelected: $savedTIsSelected)
                
                if savedTIsSelected == true {
                    if currentUser != nil {
                        
                        //MARK: - Saved TIs
                        if currentUser != nil && !observingTIsIDs.isEmpty {
                            List {
                                //Edit
                                if !editButtonPressed {
                                    ForEach(0..<observingTIsIDs.count, id: \.self) { i in
//                                        SearchTiCell(ti: <#T##TI#>)
                                            SavedTICell(index: i, tiID: observingTIsIDs[i])
                                    }
                                //Not Edit
                                } else {
                                    ForEach(observingTIsIDs, id: \.self) { tiID in
                                        
                                        ZStack(alignment: .trailing) {
                                            
                                            SavedTICell(index: nil, tiID: tiID)
                                                .offset(x: editButtonPressed ? width * -0.05 : 0)
                                                .disabled(true)
                                            
                                            
                                            //Delete Button
                                            if editButtonPressed {
                                                if !isLoading {
                                                    Button {
                                                        deleteTiFromSavedTIs(tiID: tiID)
                                                    } label: {
                                                        Image(systemName: "xmark.circle")
                                                            .frame(width: width * 0.15, height: width * 0.25)
                                                            .foregroundColor(.black)
                                                            .background(Color.red)
                                                            .font(.title).fontWeight(.bold)
                                                    }
                                                    
                                                } else { ProgressView() }
                                            }
                                        }
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
                            //Edit
                            .toolbar{
                                Button {
                                    if !isLoading {
                                        editButtonPressed.toggle()
                                    }
                                } label: {
                                    ZStack {
                                        Text(editButtonPressed ? "Done" : "Edit")
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(lineWidth: 0.5)
                                            .frame(width: width * 0.1, height: width * 0.1 )
                                    }
                                    .foregroundStyle(.white)
                                }
                            }
                        }
                    }
                    
                //MARK: - Saved Users
                } else if savedTIsSelected == false {
                    if currentUser != nil {
                        List {
                            if !editButtonPressed {
                                ForEach(0..<savedUsersUIDs.count, id: \.self) { i in
                                    
                                    HStack {

                                        Spacer()
                                        
                                        UserButton(userUID: currentUser!.savedUsersUIDs[i], horizontalName: true)
                                    }
                                }
                            } else {
                                ForEach(savedUsersUIDs, id: \.self) { userUID in
                                    
                                    HStack {
                                        if editButtonPressed {
                                            if !isLoading {
                                                Button {
                                                    if let userUID {
                                                        deleteUserFromSavedUsers(userUID: userUID)
                                                    }
                                                } label: {
                                                    Image(systemName: "xmark.circle")
                                                        .frame(width: width * 0.15, height: width * 0.15)
                                                        .foregroundColor(.black)
                                                        .background(Color.red)
                                                        .font(.title).fontWeight(.bold)
                                                }
                                            }
                                            
                                        } else { ProgressView() }
                                        
                                        Spacer()
                                            
                                        UserButton(userUID: userUID, horizontalName: true)
                                            .disabled(true)
                                    }
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        .toolbar{
                            //Edit
                            Button {
                                if !isLoading {
                                    editButtonPressed.toggle()
                                }
                            } label: {
                                ZStack {
                                    Text(editButtonPressed ? "Done" : "Edit")
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(lineWidth: 0.5)
                                        .frame(width: width * 0.1, height: width * 0.1 )
                                }
                                .foregroundStyle(.white)
                            }

                        }
                    }
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
            .onChange(of: currentUser) { _, _ in
                guard let currentUser else { return }
                observingTIsIDs = currentUser.observingTIsIDs
                savedUsersUIDs = currentUser.savedUsersUIDs
            }
        }
    }
    
    //MARK: - Functions
//    func deleteTiFromSavedTIs(index: Int) {
    func deleteTiFromSavedTIs(tiID: String) {
        guard currentUser != nil else { return }
                
//        observingTIsIDs.removeAll(where: { $0 == tiID })

        Task {
            do {
                isLoading = true
                try await UserManager.shared.updateObservingTIs(tiUID: tiID, currentUserUID: currentUserUID, addOrRemove: .remove)
                observingTIsIDs.remove(object: tiID)
                isLoading = false
            } catch {
                print("❌ Error Couldn't delete Ti from current User Saved TIs❌")
                isLoading = false
            }
        }
    }
    func deleteUserFromSavedUsers(userUID: String) {
        guard currentUser != nil else { return }

//        savedUsersUIDs.remove(object: userUID)
        
        Task {
            do {
                isLoading = true
                try await UserManager.shared.updateSavedUsers(currentUserUID: currentUserUID, userIdForArray: userUID, addOrRemove: .remove)
                savedUsersUIDs.remove(object: userUID)
                isLoading = false
            } catch {
                print("❌ Error Couldn't delete Ti from current User Saved TIs❌")
                isLoading = false
            }
        }
        
    }
    
    func fetchUser() async {
        if currentUser == nil {
            do {
                currentUser = try await UserManager.shared.getUser(userId: currentUserUID)
            } catch { print("❌ Error Couldn't get user for Library Tab❌") }
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
    
    let index: Int?
    let tiID: String?
    
    @State private var ti: TI?
    
    @State private var showTiFSC: Bool = false
    
    var body: some View {
        
        Button {
            showTiFSC = true
        } label: {
            
            HStack(spacing: 0) {
                // 1. order
                if index != nil {
                    Text("\((index!) + 1).")
                        .frame(width: width * 0.07)
                } else {
                    Text("?")
                        .frame(width: width * 0.07)
                }

                
                // 2. Thumbnail
                VStack(spacing: 5) {
                    ImageView(imageUrlString: ti?.thumbnailURL, scale: 0.4)
                    
                    if ti != nil {
                        if ti!.tiType == .d1 {
                            MiniIndicatorsSV(ti: ti, tiChainCount: ti!.rightSideChain.count, scale: 1)
                        } else if ti!.tiType == .d2 {
                            HStack {
                                UserButton(userUID: ti!.lsUserUID, scale: 0.3)
                                
                                Spacer()
                                
                                Text("\(ti!.leftSideChain?.count ?? 0)")
                                    .font(.system(size: width * 0.03))
                                
                                Spacer()
                                
                                TiCircleIcon(scale: 0.3)
                                
                                Spacer()
                                
                                Text("\(ti!.rightSideChain.count)")
                                    .font(.system(size: width * 0.03))
                                
                                Spacer()
                                
                                UserButton(userUID: ti!.rsUserUID, scale: 0.3)
                                
                            }
                            .frame(width: width * 0.4, height: width * 0.05)
                        }
                    }
                }
                
                // 3. Title
                Text("\(ti?.title ??  "Debate Title: let's try something")")
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
