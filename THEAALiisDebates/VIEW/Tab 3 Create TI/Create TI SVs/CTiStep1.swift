//
//  CTiStep1.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 4/25/24.
//

import SwiftUI

struct CTiStep1: View {
    
    @Binding var tiInteractionType: TIType
    
    var body: some View {
        VStack(spacing: width * 0.1) {
            
            //MARK: 1 - Select D1
            Button {
                tiInteractionType = .d1
            } label: {
                ZStack {
                    VStack {
                        
                        D1Icon(sf: 0.6)
                            .foregroundStyle(.primary, .primary)
                        
                        
                        Text("Mono Directional (D-1)")
                            .foregroundStyle(tiInteractionType == .d1 ? Color.ADColors.green : .primary)
                    }
                    if tiInteractionType == .d1 {
                        //border
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(lineWidth: 2.0)
                            .foregroundStyle(Color.ADColors.green)
                            .frame(width: width * 0.95, height: width * 0.55)
                        
                        //highlight
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundStyle(Color.ADColors.green.opacity(0.1))
                            .frame(width: width * 0.95, height: width * 0.55)
                    }
                }
                .frame(width: width * 0.97, height: width * 0.55)

            }
            
            //MARK: 2 -  Select D2
            Button {
                tiInteractionType = .d2
            } label: {
                ZStack {
                    
                    VStack {
                        D2Icon(sf: 0.6)
                                                
                        Text("Bi Directional (D-2)")
                            .foregroundStyle(tiInteractionType == .d2 ? Color.ADColors.green : .primary)
                    }
                    
                    //if selected : border & highlight
                    if tiInteractionType == .d2 {
                        //border
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(lineWidth: 2.0)
                            .foregroundStyle(Color.ADColors.green)
                            .frame(width: width * 0.95, height: width * 0.55)
                        
                        //highlight
                        RoundedRectangle(cornerRadius: 25)
//                            .stroke(lineWidth: 2.0)
                            .foregroundStyle(Color.ADColors.green.opacity(0.1))
                            .frame(width: width * 0.95, height: width * 0.55)
                    }
                }
                .frame(width: width * 0.97, height: width * 0.55)

            }
        }
    }
}
#Preview {
    
    CreateTI(showFSC: .constant(false), selectedTabIndex: .constant(0))

//    CTiStep1()
}
