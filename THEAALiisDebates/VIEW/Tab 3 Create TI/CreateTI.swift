//
//  CreateTI.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 4/6/24.
//

import SwiftUI

struct CreateTI: View {
    
    @AppStorage("current_user_uid") var currentUserUID: String = ""
//    var currentUser: UserModel? {
//        return UserVM().getUser(userUID: currentUserUID)
//    }
    @State var currentUser: UserModel? = nil
    
    // - //
    var vm = CreateTiVM()
    
    //TI
    let tiID = UUID().uuidString
    @State private var tiInteractionType: TIType = .d1
    @State private var tiAdminsUIDs: [String] = []
    @State private var verticalListAccess: VerticalListAccess = .open
    
    @State private var tiThumbnailData: Data? = nil
    @State private var tiTitle              = ""
    @State private var tiDescription        = ""
    
    //VS(D2) TI
    @State private var leftUser : UserModel?    = nil
    @State private var rightUser: UserModel?    = nil
    
    @State var leftTeam : [String] = []
    @State var rightTeam: [String] = []
    
    //INTRO Post
    @State private var introUnitType: PostType = .video
    @State private var introPostThumbnailData: Data? = nil
    @State private var introPostVideoURL: String? = nil
    @State private var introPostTitle              = ""
    @State private var introPostDescription        = ""
    
    
    @Binding var showFSC: Bool
    @Binding var selectedTabIndex: Int
    
    @State private var isLoading = false
    
    @State var indexStep = 0
    
    //MARK: View
    var body: some View {
        
        VStack {
            
            //1. Top bar
            HStack(spacing: 0) {
                Text("Create a THEAALii Interaction")
                    .font(.title2).foregroundColor(.ADColors.green)
                    .frame(width: width * 0.85, height: width * 0.15)
                
                //Close Button
                Button {
                    Task {
                        closeButtonPressed()
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: width * 0.1, weight: .thin))
                        .foregroundColor(.primary)
                        .frame(width: width * 0.15)
                }
            }// top bar - //
            
            //2. Step Indicators
            HStack(spacing: 20) {
                ForEach(0..<3) { i in
                    
                    Button {
                        indexStep = i
                    } label: {
                        ZStack {
                            Circle()
                                .stroke()
                                .frame(width: width * 0.125)//, height: width * 0.1)
                            
                            Text("\(i + 1)")
                        }
                        .foregroundStyle(indexStep == i ? Color.ADColors.green : .white)
                    }
                }
            }
            .frame(width: width, height: width * 0.08)
                .padding(.bottom, 5)
            
            
            //MARK: - Body ( Input )
            if indexStep == 0 {
                
                CTiStep1(tiInteractionType: $tiInteractionType)
                
            } else if indexStep == 1 {
                
                if tiInteractionType == .d1 {
                    
                    CTiStep2D1(
                        currentUser: currentUser,
                        tiID: tiID,
                        tiInteractionType: $tiInteractionType,
                        tiThumbnailData: $tiThumbnailData,
                        thumbnailForTypeID: tiID,
                        tiTitle: $tiTitle,
                        rightUser: $rightUser
                    )
                    
                } else if tiInteractionType == .d2 {
                    
                    CTiStep2D2(
                        currentUser: currentUser,
                        tiID: tiID,
                        tiInteractionType: $tiInteractionType,
                        tiThumbnailData: $tiThumbnailData,
                        thumbnailForTypeID: tiID,
                        tiTitle: $tiTitle,
                        leftUser: $leftUser,
                        rightUser: $rightUser
                    )
                }
                
            } else if indexStep == 2 {
                
                CTiStep3(
                    currentUser: currentUser,
                    tiAdminsUIDs: $tiAdminsUIDs,
                    tiInteractionType: $tiInteractionType,
                    tiDescription: $tiDescription,
                    verticalListAccess: $verticalListAccess)
                
            }
            
            
            
            
            Spacer()
            
            //Next Step Button
            Button {
                nextStepButton()
            } label: {
                ZStack {
                    Text(nextStepText)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 2)
                        .frame(width: width * 0.8, height: width * 0.15)
                }
                .foregroundStyle(Color.ADColors.green)
            }
            .padding(.vertical, width * 0.1)
        }
        .overlay { if isLoading { LoadingView() } }
        .onAppear{ Task { currentUser = try await UserManager.shared.getUser(userId: currentUserUID) } }
    }
    
    //MARK: - Functions
    private func closeButtonPressed() {
        isLoading = true
        
        selectedTabIndex = 0
        isLoading = false
        showFSC = false
    }
    
    private func nextStepButton() {
        if indexStep == 0 {
            indexStep += 1
            
        } else if indexStep == 1 {
            guard nextStepText == "Next Step" else { return }
            indexStep += 1
            
        } else if indexStep == 2 && nextStepText == "CREATE TI" {
            Task {
                await createTI() ///
            }
        }
    }
    var nextStepText: String {
        
        if indexStep == 0 {
            
            return "Select TI Type"
            
        } else {
            guard tiThumbnailData != nil else { return "Pick TI Thumbnail" }
            
            if tiInteractionType == .d2 {
                if leftUser == nil  { return "Pick Left User"  }
                if rightUser == nil { return "Pick Right User" }
            }
            
            guard tiTitle != "" else { return "Enter Title" }
            
            if indexStep == 1 {
                return "Next Step"
            }
            
            return "CREATE TI"
        }
        
    }
    var BottomButtonText: String {
        
        if indexStep == 0 { return "Select TI Type"
            
            //indexStep == 1
        } else if tiThumbnailData == nil {
            return "upload Thumbnail"
        } else if tiTitle == "" {
            return "Enter Title"
        }
        
        return "UPLOAD THEAALii's Interaction"
    }
    
    //MARK: - Create Ti
    func createTI() async {
        if tiInteractionType == .d1 {
            
            isLoading = true

            let _ = await vm.createD1Ti(id: tiID, title: tiTitle, description: tiDescription,
                                           tiThumbnailData: tiThumbnailData,
                                           creatorUID: currentUserUID, 
                                           tiAdminsUIDs: tiAdminsUIDs,
                                           rsLevel1UsersUIDs: nil,
                                           rsLevel2UsersUIDs: nil,
                                           rsLevel3UsersUIDs: nil,
                                           rsVerticalListAccess: verticalListAccess
            ) { success in
                if success {
                    showFSC = false
                    selectedTabIndex = 4
                    print("success = \(success)" + " ✅✅🚪🔥")
                    
                }
            }
            
            isLoading = false
            
        } else if tiInteractionType == .d2 {
            
            //TODO: vm.createD2Ti
            isLoading = true

            //extra security 
            guard let _ = rightUser?.userUID , let _ = leftUser?.userUID else {
                print("Error = right of left user is nil" + " ❌❌🚪🔥")
                isLoading = false
                return
            }
            let _ = await vm.createD2TiOld(id: tiID, title: tiTitle, description: tiDescription,
                                        tiThumbnailData: tiThumbnailData,
                                        creatorUID: currentUserUID, tiAdminsUIDs: tiAdminsUIDs,
                                        //right
                                        rsUserUID: rightUser!.userUID, //FIXME: userUID
                                        rsLevel1UsersUIDs: nil,
                                        rsLevel2UsersUIDs: nil,
                                        rsLevel3UsersUIDs: nil,
                                        rsVerticalListAccess: verticalListAccess,
                                        //left
                                        lsUserUID: leftUser!.userUID, //FIXME: userUID
                                        lsLevel1UsersUIDs: nil,
                                        lsLevel2UsersUIDs: nil,
                                        lsLevel3UsersUIDs: nil,
                                        lsVerticalListAccess: verticalListAccess) { success in
                
                    if success {
                        showFSC = false
                        selectedTabIndex = 4
                        print("success = \(success)" + " ✅✅🚪🔥")
                        
                    }
            }
            
            isLoading = false

        }
    }
}

#Preview {
    CreateTI(showFSC: .constant(true), selectedTabIndex: .constant(0))
}



//MARK: - Ti Creating VM
@MainActor
final class TiCreatingVM {
    
    let tiID = UUID().uuidString
    @AppStorage("current_user_uid") var currentUserUID: String = ""
    
    func createTI(
        //1
        tiType: TIType,
        //2
        tithumbnail: Data?,
        leftUser  : String,
        rightUser : String,
        tiTitle: String,
        
        //3
        tiAdmins: [String],
        introDescription: String,
        verticalListAccess: VerticalListAccess
    ) async throws {
        
        if tiType == .d1 {
            
            //FIXME: - ti Post Type
            
            _ = Post(id: tiID, title: "INTRO", type: .text, text: introDescription, imageURL: nil, videoURL: nil, creatorUID: currentUserUID, dateCreated: Date.now, addedToChain: true, totalVotes: 0, upVotes: 0, downVotes: 0, upVotersUIDsArray: [], downVotersUIDsArray: [], commentsArray: []
            )
            
            _ = TITChainLinkModel(
                id: tiID,
                postID: tiID,
                verticalList: []
            )
            //            TITChainLModel(id: <#T##String#>, videoId: <#T##String#>, videoTitle: <#T##String#>, videoThumbnail: <#T##String?#>, responseList: <#T##[String]#>)
            
            
//            let ti = TI(
//                id: tiID, title: tiTitle, description: "No TI Description Yet",
//                thumbnailURL: "",
//                introPostID: introChLink.id,
//                creatorUID: currentUserUID,
//                tiAdminsUIDs: tiAdmins,
//                dateCreated: Date.now, tiType: tiType,
//                rightChain: [], leftChain: [],
//                responseListAccess: verticalListAccess
//            )
            
            Task {
//                do {
//                    try await TIManager.shared.createTI(ti: ti)
//                    try await PostManager.shared.createTI(tiID: ti.id, post: post)
//                    try await TITChainLinkManager.shared.createTITChainLink(TITid: tiID, TITChainLink: introChLink)
                    
                    
                    //                    (titId: ti.id, titCL: introChLink)
                    //                try await TITVideoManager.shared.createTitVideo(titID: tit.id, titVideo: titVideo)
                    //                try await TITChainLinkManager.shared.createTITChainLink(TITid: tit.id, TITChainLink: titChainLink)
                    
                    //                try await TITManager.shared.addToChain(titId: tit.id, chainId: titChainLink.id)
                    
//                } catch {
//                    print("❌❌❌ Error: Couldn't Create TI ❌❌❌")
//                }
            }
            
        } else if tiType == .d2 {
//
        }
    }
}
