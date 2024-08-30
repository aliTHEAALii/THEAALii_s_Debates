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
                iiEditTiAdminsBar(ti: $ti)
            }
            
            
            HStack {
                
                Spacer()
                
                FollowTiButton(ti: $ti)
                    .padding(.trailing, width * 0.001)
            }
            
            Spacer()
        }
        .preferredColorScheme(.dark)
        .refreshable {
            
        }
    }
}

#Preview {
    iiView(ti: .constant(TiViewModel().ti))
    
//    TiView(ti: nil, showTiView: .constant(true))
}




//struct UploadToTiChainFSC: View {
//    var body: some View {
//        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
//    }
//}
