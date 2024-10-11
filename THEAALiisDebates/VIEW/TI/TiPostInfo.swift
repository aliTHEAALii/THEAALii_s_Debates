//
//  tiPostInfo.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 6/5/24.
//

import SwiftUI

struct TiPostInfo: View {
    
    @Binding var ti: TI?
    @Binding var tiPost: Post?
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            if tiPost != nil {
                
                Text(tiPost?.title ?? "No post found")
                    .font(.title2)
                    .frame(width: width, height: width * 0.2)
                
                //2. Description & Buttons
                ZStack {
                    HStack(spacing: 0) {
                        
                        //Post Description
                        DescriptionSV(descriptionTitle: "Post Description", text: tiPost!.text ?? "")
//                            .offset(x: width * -5)
                        
                        // - Post Buttons
                        VStack(spacing: 0) {
                            
                            //Post Creator
                            UserButton(userUID: tiPost!.creatorUID)
                                .frame(height: width * 0.15)
                            
                            //Comments
//                            CommentsButton()
                            Button {
                                
                            } label: {
                                Image(systemName: "circle")
                                    .foregroundStyle(.gray)
                                    .frame(width: width * 0.15, height: width * 0.15)
                            }
                            
                            //Expand SideSheet PlaceHolder
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: width * 0.15, height: width * 0.15)
                            
                        }
                        .frame(width: width * 0.15, height: width * 0.45)
                    }
                    
                    // - Side Sheet (Don't Delete)
                    // SideOptionsSheet(showSideSheet: $showSideOptions)
                    //     .offset(x: showSideOptions ? width * 0.375 : width * 0.68)
                    SideSheet()
                }
            } else {
                ZStack {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.2))
                        .frame(width: width, height: width * 0.65)
                    Text("No Post")
                    ProgressView()
                }
            }
        }
    }
    
    //Functions
}

#Preview {
    //    TiPostInfo()
    
    TiView(ti: TestingModels().testTI0, showTiView: .constant(true))
        .environment(CurrentUser().self)
}
