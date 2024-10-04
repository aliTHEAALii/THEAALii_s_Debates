//
//  CTiStep2D1.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 4/29/24.
//

import SwiftUI

struct CTiStep2D1: View {
    
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

    @Binding var rightUser: UserModel?
    @Binding var rightTeam: [String]
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            CTiPickTeamBar(currentUser: currentUser, tiInteractionType: $tiInteractionType, leftTeam: .constant([]), rightTeam: $rightTeam)
            
            //Pick thumbnail - D1 Icon - Creator Pic
            ZStack(alignment: .bottom) {
                
                //Pick thumbnail
                VStack(spacing: 0) {
                    
                    //Thumbnail & Team
                    ZStack {
                        PickThumbnailButton(thumbnailFor: .TI, thumbnailForTypeID: tiID, imageData: $tiThumbnailData, buttonText: "TI \nThumbnail")
                        
                        //Team
                        if tiInteractionType == .d2 {
                            HStack {
                                //Left Side
//                                VStack(spacing: 25) {
//                                    
//                                    ForEach(leftTeam.reversed(), id: \.self) { userUID in
//                                        UserButton(userUID: userUID)
//                                    }
//                                }
//                                .frame(height: width * 0.45, alignment: .bottom)
//                                .padding(.bottom, 25)
                                
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
                    .padding(.bottom, 40)
//                    .frame(width: width, height: width * 0.5625)
                    
//                    Spacer()
                    
                }
                
                HStack(spacing: 0) {
                    
                    Rectangle()
                        .foregroundStyle(.clear)
                        .frame(width: width * 0.2375)
                    
                    
                    TiMapRectangleShape(cornerRadius: 8)
                        .stroke(lineWidth: 0.5)
                        .frame(width: width * 0.525, height: width * 0.085)
                    
                    UserButton(user: currentUser)
                        .frame(width: width * 0.2375, alignment: .trailing)

                    

                }
                .frame(width: width, height: width * 0.1, alignment: .trailing)
//                TiMapRectD1(ti: ti, cornerRadius: 8, rectWidth: width * 0.525, rectHeight: width * 0.085, stroke: 0.5)
                    

                //Creator Pic
//                ZStack {
//                    if let profileImageURLString = currentUser?.profileImageURLString {
//                        
//                        AsyncImage(url: URL(string: profileImageURLString), scale: 0.5) { image in
//                            
//                            image
//                                .resizable()
//                                .clipShape( Circle() )
//                                .scaledToFit()
//                                .frame(width: width * 0.11, height: width * 0.11)
//
//                            
//                            
//                        } placeholder: {
//                            ProgressView()
//                        }
//                        //User with Nil image
//                    } else { PersonTITIconSV(scale: 1.3) }
//                    
//                    //Border
//                    Circle()
//                        .stroke(lineWidth: 0.4)
//                        .foregroundStyle(.white)
//                        .frame(width: width * 0.11)
//
//                }
//                .frame(width: width * 0.99, height: width * 0.68, alignment: .bottomTrailing)

            }
            .frame(width: width, height: width * 0.68)
            
            
            //MARK: TI Title
            EnterTiTitle(tiTitle: $tiTitle)
                .padding(.top)
            
        }

        
    }
}

#Preview {
//    CTiStep2D1(
//        currentUser: TestingModels().user1,
//        tiID: "tiID",
//        tiInteractionType: .constant(.d1),
//        tiThumbnailData: .constant(nil),
//        thumbnailForTypeID: "tiID",
//        tiTitle: .constant("meaw"),
//        rightUser: .constant(TestingModels().user1)
//    )
    
    CreateTI(showFSC: .constant(true), selectedTabIndex: .constant(2), indexStep: 1)

}
