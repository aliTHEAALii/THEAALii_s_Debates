//
//  iiView.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 6/19/24.
//

import SwiftUI

struct iiView: View {
    
    @AppStorage("current_user_uid") var currentUserUID: String = "BXnHfiEaIQZiTcpvWs0bATdAdJo1"
    
//    @Binding var currentUser: UserModel?
    @Environment(CurrentUser.self) var currentUser

    @Binding var ti: TI?
    
    @State private var notFollowingTi: Bool = false
    
    var body: some View {
        
        if ti != nil {
            ScrollView(.vertical, showsIndicators: true) {
                
                VStack(spacing: 0) {
                    
                    // 1. Top
                    D2IconBarNew(ti: ti!)
                    
                    Divider()
                        .padding(.top, 3)
                    
                    // 1.5 Teams
                    TeamsSV(tiID: ti!.id)
                    
                    Divider()
//                        .padding(.top)
                    
                    // 2. Title
                    Text(ti?.title ?? "")
                        .font(.title)
                        .padding(.bottom)
                    
                    // 2. Thumbnail
                    
                    
                    
                    
                    
                    
                    //5. Votes (Up - Total - Down)
                    
                    //6. Description
                    if ((ti?.description.isEmpty) != nil)  || ti!.description == "" {
                        Text("No Description")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.gray)
                            .padding()
                        
                    } else {
                        Text(ti?.description ?? "No Description")
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    
                    if !TiViewModel().isAdmin(ti: ti, currentUserUID: currentUserUID) {
                        
                        PickNewThumbnailBar(thumbnailFor: .TI, thumbnailForTypeId: ti?.id ?? "", thumbnailUrlString: ti?.thumbnailURL, buttonText: "Thumbnail")
                            .padding(.vertical)
                        
                    }
                    //                else {
                    //                    ZStack {
                    //                        RoundedRectangle(cornerRadius: 8)
                    //                            .stroke(lineWidth: 1)
                    //                            .frame(width: width * 0.22, height: width * 0.5625 * 0.22)
                    //                        
                    //                        ImageView(imageUrlString: ti?.thumbnailURL, scale: 0.22)
                    //                    }
                    //                }
                    
                    // 3. Creator
                    HStack(spacing: 0) {
                        Text("Ti Creator:")
                        
                        Spacer() //FIXME: bug
                        
                        UserButton(userUID: ti?.creatorUID, horizontalName: true)
                            .padding(.trailing, 2)
                    }
                    .frame(height: width * 0.15)
                    
                    Divider()
                    
                    //4. Admins
                    iiEditTiAdminsBar(ti: $ti)
                    
                    //5. Followers
                    HStack {
                        
                        Text("Ti Followers:   \(ti?.tiObserversUIDs.count ?? 0)")
                        
                        Spacer()
                        
                        FollowTiButton(ti: $ti, notFollowingTi: $notFollowingTi)
                            .padding(.trailing, width * 0.001)
                    }
                    
                    //6.
                    
                    Spacer()
                }
                .preferredColorScheme(.dark)
                .onAppear{
                    notFollowingTi = ControlCenterViewModel().notFollowingTiFunc(currentUserUID: currentUserUID, ti: ti, currentUser: currentUser.userModel()) }
            }
            .frame(width: width)
            
        } else { ProgressView() }
    }
}

#Preview {
    //    iiView(ti: .constant(TiViewModel().ti))
    
    TiView(ti: nil, showTiView: .constant(true))
}




//struct UploadToTiChainFSC: View {
//    var body: some View {
//        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
//    }
//}
