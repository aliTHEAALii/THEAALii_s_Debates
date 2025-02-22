//
//  TeamsSV.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 9/29/24.
//
import SwiftUI

struct TeamsSV: View {
    
    @AppStorage("current_user_uid") var currentUserUID: String = "BXnHfiEaIQZiTcpvWs0bATdAdJo1"

    let tiID: String
    @State var ti: TI? = nil
    
//    @State private var currentUser: UserModel?
    @Environment(CurrentUser.self) var currentUser


    @State var leftTeam : [String] = []
    @State var rightTeam: [String] = []
    
    @State private var showEditTeamsFSC = false
    @State private var leftOrRight: LeftOrRight? = .left
    @State private var isLoading: Bool = false
    
    var body: some View {
        
        if !isLoading {
            HStack(spacing: 0) {
                
                //MARK: - Left Team
                VStack {
                    
                    if (leftTeam).isEmpty {
                        Button {
                            print("🔵 ooo")
                            
                            showEditTeamsFSC = true
                            leftOrRight = .left
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 0.5)
                                    .padding(.horizontal)
                                    .frame(height: width * 0.1)

                                
                                Text("No Left Team")
                                    .foregroundStyle(.gray)
                            }
                            .foregroundStyle(.white)
                        }
                        
                        
                        
                    } else {
                        Button {
                            print("🔵 1pppp")
                            
                            showEditTeamsFSC = true
                            leftOrRight = .left
                            print("🔵 1pppp \(showEditTeamsFSC)")
                            
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 0.5)
                                    .padding(.horizontal)
                                    .frame(height: width * 0.1)


                                Text("Left Team")
                            }
                            .foregroundStyle(.white)
                        }
                        .padding(.bottom)
                        
                        ForEach((leftTeam).indices, id: \.self) { i in
                            UserButton(userUID: leftTeam[i], leftOrRightName: .right, scale: 0.8, showDivider: false)
                        }
                    }
                }
                .frame(width: width * 0.5, alignment: .top)//
                

                
                
                //MARK: - Right Team
                VStack {
                    
                    if (rightTeam).isEmpty {
                        Button {
                            
                            showEditTeamsFSC = true
                            leftOrRight = .right
                            print("🔵 1uuuuu \(showEditTeamsFSC)")
                            
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 0.5)
                                    .padding(.horizontal)
                                    .frame(height: width * 0.1)

                                
                                
                                Text("No Right Team")
                                    .foregroundStyle(.gray)
                            }
                            .foregroundStyle(.white)
                        }
                    } else {
                        Button {
                            print("🔵 1yyyyy")
                            
                            showEditTeamsFSC = true
                            leftOrRight = .right
                            print("🔵 1yyyy \(showEditTeamsFSC)")
                            
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(lineWidth: 0.5)
                                    .padding(.horizontal)
                                    .frame(height: width * 0.1)

                                
                                
                                Text("Right Team")
                            }
                            .foregroundStyle(.white)
                        }
                        .padding(.bottom)
                        
                        ForEach((rightTeam).indices, id: \.self) { i in
                            UserButton(userUID: rightTeam[i], leftOrRightName: .left, scale: 0.8, showDivider: false)
                        }
                    }
                }
                .frame(width: width * 0.5, alignment: .top)
            }
            .padding(.vertical)
            .frame(height: viewHeight, alignment: .top)
            
            .fullScreenCover(isPresented: $showEditTeamsFSC) {
                FSCHeaderSV(showFSC: $showEditTeamsFSC, text: "Edit \(leftOrRight == .left ? "Left" : "Right") Team")
                
                Divider()
                
                //MARK: - Team
                HStack(spacing: 10) {
                    
                    if ti != nil {
                        //Admins
                        ForEach((leftOrRight == .left ? leftTeam : rightTeam), id: \.self) { teamMemberUID in
                            
                            VStack(spacing: 10) {
                                
                                UserButton(userUID: teamMemberUID)
                                
                                
                                //Remove team member button
                                Button {
                                    if leftOrRight == .left {
                                        leftTeam.remove(object: teamMemberUID)
                                        
                                    } else if leftOrRight == .right {
                                        rightTeam.remove(object: teamMemberUID)
                                    }
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
                
                
                //Current User
                AddRemoveTeamMemberCell(ti: $ti,
                                        leftTeam: $leftTeam,
                                        rightTeam: $rightTeam,
                                        savedUserUID: currentUser.UID, leftOrRight: leftOrRight!)
                .padding(.top)
                
                //MARK: - Your saved users
                Text("Your Saved Users")
                    .foregroundStyle(.white)
                    .font(.title)
                
                //AddOrRemove Saved Users
//                if currentUser != nil {
//                    Text(currentUser.UID)
//                }
                if !currentUser.savedUsersUIDs.isEmpty {

                    
                    ForEach(currentUser.savedUsersUIDs, id: \.self) { savedUserUID in
                        HStack {
                            
                            if leftOrRight != nil {
                                AddRemoveTeamMemberCell(ti: $ti,
                                                        leftTeam: $leftTeam,
                                                        rightTeam: $rightTeam,
                                                        savedUserUID: savedUserUID, leftOrRight: leftOrRight!)
                                
                            } else { ProgressView() }
                        }
                        .frame(width: width, height: width * 0.15)
                    }
                } else {
                    
                    Spacer()
                    Text("No Saved Users")
                    Spacer()
                }
                
                Spacer()
            }
            .onAppear{ onAppear() }
            .onChange(of: showEditTeamsFSC) { _, newValue in
                
                if newValue == false {
                    Task {
                        do {
                            if leftOrRight == .left {
                                try await TIManager.shared.newLv1Teams(tiID: ti!.id, lv1TeamUIDsArray: leftTeam, leftOrRight: .left)
                                
                            } else if leftOrRight == .right {
                                try await TIManager.shared.newLv1Teams(tiID: ti!.id, lv1TeamUIDsArray: rightTeam, leftOrRight: .right)
                                
                            }
                            
                            leftOrRight = nil
                            
                        } catch {
                            leftOrRight = nil
                        }
                    }
                }
            }
            
        } else { ProgressView() }
    }
    
    var viewHeight: CGFloat {
        
        return CGFloat(max(Int(width * 0.15) * ((leftTeam).count), Int(width * 0.15) * ((rightTeam).count))) + width * 0.2
    }
    
//    func fetchUser() async {
//        do {
//            self.currentUser = try await UserManager.shared.getUser(userId: currentUserUID)
//        } catch { print("❌ Couldn't fetch User: \(error.localizedDescription) ❌") }
//    }
    func getTi() async {
        do {
            ti = try await TIManager.shared.fetchTI(tiID: tiID)
        } catch { print("❌ Couldn't fetch Ti: \(error.localizedDescription) ❌") }
    }
    
    private func onAppear() {
        Task {
//            await fetchUser()
            await getTi()
            print("👹 \(ti?.lsLevel1UsersUIDs ?? []) pppp")
            print("👹 \(ti?.rsLevel1UsersUIDs ?? []) oooo")
            leftTeam = ti?.lsLevel1UsersUIDs ?? []
            rightTeam = ti?.rsLevel1UsersUIDs ?? []
        }
        
    }
}
    

#Preview {
    
    iiView(ti: .constant(TiViewModel().ti))
    .environment(CurrentUser().self)
    
//    TiView(ti: nil, showTiView: .constant(true))
//        .environment(CurrentUser().self)
}










//MARK: - Add Remove Team Member Cell
struct AddRemoveTeamMemberCell: View {
    
    
//    @Binding var currentUser: UserModel?
    @Environment(CurrentUser.self) var currentUser

    @Binding var ti: TI?
    
    @Binding var leftTeam : [String]
    @Binding var rightTeam: [String]
    
    let savedUserUID: String
    let leftOrRight: LeftOrRight

        
    var body: some View {
        
        
        HStack(spacing: 0) {
            
            //Add - Remove Button
            Button {
                if ti != nil {
                    editTeamMember(tiID: ti!.id, userUID: savedUserUID, leftOrRight: leftOrRight, addOrRemove: addOrRemove)
                }
            } label: {
                Image(systemName: addOrRemove == .add ? "plus.circle" : "minus.circle")
                    .font(.title)
                    .foregroundColor(addOrRemove == .add ? .ADColors.green : .red)
            }
            .padding()
            
            
            Spacer()
            
            //User Button
            if savedUserUID == currentUser.UID {
                UserButton(user: currentUser.userModel(), horizontalName: true)
            } else {
                UserButton(userUID: savedUserUID, horizontalName: true)
            }
        }
    }
    
    //MARK: - Functions
    func editTeamMember(tiID: String, userUID: String, leftOrRight: LeftOrRight, addOrRemove: AddOrRemove) {

        guard  ti != nil else { return }
        guard TiViewModel().isAdmin(ti: ti!, currentUserUID: currentUser.UID) else { print("🟠NOT Admin🟠"); return }
        
        if leftOrRight == .left {
            print("🟣 1")
            if addOrRemove == .add {
                print("🟣 2")
                guard leftTeam.count < 3 else { return }
                leftTeam.append(userUID)
                
            } else if addOrRemove == .remove {
                print("🟣 3")

                leftTeam.remove(object: userUID)
            }
            
        } else if leftOrRight == .right {
            print("🔵 1")

            if addOrRemove == .add {
                print("🔵 2")
                
                guard rightTeam.count < 3 else { return }
                rightTeam.append(userUID)
                
            } else if addOrRemove == .remove {
                print("🔵 3")

                rightTeam.remove(object: userUID)
            }
        }
        
    }
    
    var addOrRemove: AddOrRemove {
        
        if leftOrRight == .left {
            guard !leftTeam.isEmpty else { return .add }
            
            if !leftTeam.contains(savedUserUID) { return .add }
            
            return .remove
            
            
            
        } else if leftOrRight == .right {
            guard !rightTeam.isEmpty else { return .add }
            
            if !rightTeam.contains(savedUserUID) { return .add }
            
            return .remove
            
        }
        
        return .add
    }
}
