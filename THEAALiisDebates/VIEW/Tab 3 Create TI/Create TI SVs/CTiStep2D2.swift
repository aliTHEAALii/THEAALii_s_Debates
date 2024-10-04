//
//  CTiStep2.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 4/25/24.
//

import SwiftUI

struct CTiStep2D2: View {
    
    @AppStorage("current_user_uid") var currentUserUID: String = "BXnHfiEaIQZiTcpvWs0bATdAdJo1"
    let currentUser: UserModel?
    
    let tiID: String
    @Binding var tiInteractionType: TIType
    
    @Binding var tiThumbnailData: Data?
    let thumbnailForTypeID: String
    
    @Binding var tiTitle: String
    //    enum Field {
    //        case debateTitle, debateDescription, videoTitle, videoDescription
    //    }
    //    @FocusState private var focusField: Field?
    
    @Binding var leftUser : UserModel?
    @Binding var rightUser: UserModel?
    
    @Binding var leftTeam: [String]
    @Binding var rightTeam: [String]
    
    
    
    var body: some View {
        
        ZStack {
            VStack(spacing: width * 0.07) {
                
                CTiPickTeamBar(currentUser: currentUser, leftTeam: $leftTeam, rightTeam: $rightTeam)
                
                //Thumbnail & Users
                ZStack(alignment: .bottom) {
                    
                    VStack(spacing: width * 0.02) {
                        
                        //MARK: Thumbnail
                        ZStack {
                            PickThumbnailButton(thumbnailFor: .TI, thumbnailForTypeID: tiID, imageData: $tiThumbnailData, buttonText: "TI \nThumbnail")
                            
                            //Team
                            if tiInteractionType == .d2 {
                                HStack {
                                    //Left Side
                                    VStack(spacing: 25) {
                                        
                                        ForEach(leftTeam.reversed(), id: \.self) { userUID in
                                            UserButton(userUID: userUID)
                                        }
                                    }
                                    .frame(height: width * 0.45, alignment: .bottom)
                                    .padding(.bottom, 25)
                                    
                                    Spacer()
                                    
                                    //Right Side
                                    VStack(spacing: 25) {
                                        ForEach(rightTeam.reversed(), id: \.self) { userUID in
                                            UserButton(userUID: userUID)
                                        }
                                    }
                                    .frame(height: width * 0.45, alignment: .bottom)
                                    .padding(.bottom, 25)
                                }
                            } else if tiInteractionType == .d1 {
                                HStack {
                                    Spacer()
                                    
                                    //Right Side
                                    VStack(spacing: 25) {
                                        ForEach(rightTeam.reversed(), id: \.self) { userUID in
                                            UserButton(userUID: userUID)
                                        }
                                    }
                                    .frame(height: width * 0.5625, alignment: .bottom)
                                    .padding(.bottom)
                                }
                            }
                        }
                        
                        
                        
                        //MARK: Pick Left & Write User
                        HStack {
                            
                            PickUserButton(currentUser: currentUser, pickedUser: $leftUser)
                            
                            Spacer()
                            
                            PickUserButton(currentUser: currentUser, pickedUser: $rightUser)
                        }
                    }
                    .frame(height: width * 0.7)
                    
                    //TI Icon
                    TIIconD2(scale: 0.95, showTwoSides: false)
                        .offset(y: width * -0.026)
                    
                }
                .frame(width: width, height: width * 0.7)
                
                
                
                //MARK: TI Title
                EnterTiTitle(tiTitle: $tiTitle)
                //                    .offset(y: width * 0.03)
                
                //MARK: Description
                //                EnterDescriptionButton(description: .constant("meaw"), buttonTitle: "TI Description")
                
            }
        }
    }
}

#Preview {
    //    CTiStep2D2(
    //        currentUser: <#UserModel?#>,
    //        tiID: <#String#>,
    //        tiInteractionType: <#Binding<TIType>#>,
    //        tiThumbnailData: <#Binding<Data?>#>,
    //        thumbnailForTypeID: <#String#>,
    //        tiTitle: <#Binding<String>#>,
    //        leftUser: <#Binding<UserModel?>#>,
    //        rightUser: <#Binding<UserModel?>#>)
    
    CreateTI(showFSC: .constant(true), selectedTabIndex: .constant(2), indexStep: 1)
    
}




//MARK: - CTiPickTeamBar
struct CTiPickTeamBar: View {
    
    let currentUser: UserModel?
    @State var showEditTeamsFSC: Bool = false
    @State var leftOrRight: LeftOrRight? = nil
    
    @Binding var leftTeam: [String]
    @Binding var rightTeam: [String]
    
    var body: some View {
        HStack {
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
            //                    .padding(.bottom)
            
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
        }
        .onChange(of: showEditTeamsFSC) { _, newValue in
            if newValue == false { leftOrRight = nil }
        }
        .fullScreenCover(isPresented: $showEditTeamsFSC) {
            FSCHeaderSV(showFSC: $showEditTeamsFSC, text: "Edit \(leftOrRight == .left ? "Left" : "Right") Team")
            
            Divider()
            
            //MARK: - Team
            HStack(spacing: 10) {
                
                //                if ti != nil {
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
                //                }
            }
            .frame(width: width * 0.85, height: width * 0.25, alignment: .leading)
            
            
            Divider()
            
            Text("Your Saved Users")
                .foregroundStyle(.white)
                .font(.title)
            
            //AddOrRemove Saved Users
            if currentUser != nil {
                Text(currentUser?.userUID ?? "no user yet")
            }
            if currentUser != nil, !currentUser!.savedUsersUIDs.isEmpty, let savedUsersUIDs = currentUser?.savedUsersUIDs {
                
                ForEach(savedUsersUIDs, id: \.self) { savedUserUID in
                    HStack {
                        if savedUserUID != nil, leftOrRight != nil {
                            CTiAddRemoveTeamMemberCell(currentUser: currentUser,
                                                       leftTeam: $leftTeam,
                                                       rightTeam: $rightTeam,
                                                       savedUserUID: currentUser?.userUID ?? "no user",
                                                       leftOrRight: leftOrRight!)
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
    }
}



//MARK: - Add Remove Team Member Cell
struct CTiAddRemoveTeamMemberCell: View {
    
    
    let currentUser: UserModel?
    //    @Binding var ti: TI?
    
    @Binding var leftTeam : [String]
    @Binding var rightTeam: [String]
    
    let savedUserUID: String
    let leftOrRight: LeftOrRight
    
    
    var body: some View {
        
        
        HStack(spacing: 0) {
            
            //Add - Remove Button
            Button {
                //                if ti != nil {
                editTeamMember(userUID: savedUserUID, leftOrRight: leftOrRight, addOrRemove: addOrRemove)
                //                }
            } label: {
                Image(systemName: addOrRemove == .add ? "plus.circle" : "minus.circle")
                    .font(.title)
                    .foregroundColor(addOrRemove == .add ? .ADColors.green : .red)
            }
            .padding()
            
            
            Spacer()
            
            
            UserButton(userUID: savedUserUID, horizontalName: true)
        }
    }
    
    //MARK: - Functions
    func editTeamMember(userUID: String, leftOrRight: LeftOrRight, addOrRemove: AddOrRemove) {
        
        //        guard  ti != nil else { return }
        //        guard TiViewModel().isAdmin(ti: ti!, currentUserUID: currentUser?.userUID ?? "no user") else { print("🟠NOT Admin🟠");return }
        
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
