//
//  SideSheetForVotingCell.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 3/5/23.
//

import SwiftUI

struct SideSheetForVotingCellOld: View {
    
    let isAdmin: Bool
    
    
    @ObservedObject var cardVM = VotingCardViewModel()
    @Binding var showSideSheet: Bool
    
    var body: some View {
                
        ZStack {
            
            // - Black Background
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.black)
                .frame(width: width * 0.35, height: width * 0.5625 * 0.85)

            
            // - Border
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(lineWidth: 0.2)
                .foregroundColor(.primary)
                .frame(width: width * 0.35, height: width * 0.5625 * 0.85)

            
            
            HStack(spacing: 0) {
                
                
                //MARK: - Left Column
                VStack(spacing: 0) {
                    
                    // -
                    Button {
                        
                    } label: {
                        Image(systemName: "circle")
                            .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.33)

                    }
                    
                    // -
                    Button {

                    } label: {
                        Image(systemName: "circle")
                            .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.33)

                    }
                    
                    // -
                    // -
                    Button {
                        
                    } label: {
                        Image(systemName: "circle")
                            .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.33)

                    }
                    
                }
                .frame(width: width * 0.15, height: width * 0.5625 * 0.85)
                
                //MARK: - Right Column
                VStack(spacing: 0) {
                    
                    // -
                    Button {
                        
                    } label: {
                        Image(systemName: "circle")
                            .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.33)

                    }
                    
                    // - collapse button
                    Button {
                        withAnimation(.spring()) {
                            showSideSheet.toggle()
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.title)
                            .fontWeight(.thin)
                            .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.33)

                    }
                    
                    // -
                    Button {
                        
                    } label: {
                        Image(systemName: "circle")
                            .frame(width: width * 0.15, height: width * 0.5625 * 0.85 * 0.33)
                        
                    }
                    
                }
                .frame(width: width * 0.15, height: width * 0.15)
                
            }
            .foregroundColor(.primary)
            .frame(width: width * 0.35, height: width * 0.5625 * 0.85, alignment: .leading)
        }
    }
}

struct SideSheetForVotingCell_Previews: PreviewProvider {
    static var previews: some View {
        
        VotingCell()
            .preferredColorScheme(.dark)

        SideSheetForVotingCellOld(isAdmin: true, showSideSheet: .constant(true))
            .preferredColorScheme(.dark)
    }
}


