//
//  UserPostedDebateCard.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 3/8/23.
//

import SwiftUI

struct UserPostedDebateCard: View {
    
    var debateTitle: String = "Debate Title goes Here: It's not very pleasant today. I hate Everything. "
    var body: some View {
        
        Button {
            
        } label: {
            
            VStack(spacing: 0) {
                
                //TODO: Video
                ZStack(alignment: .bottom) {
                    
                    //FIXME: Debate Chains Count
                    DebateCardIndicatorCirclesSV(debateChainsCount: 100)
                    
                    //Border
                    RoundedRectangle(cornerRadius: 8)
                        .trim(from: 0, to: 0.5)
                        .stroke(lineWidth: 1)
                        .frame(width: width * 0.45, height: width * 0.15)
                        .foregroundColor(.primary)
                    
                    
                    // 0.5625 + 0.0575 = 0.61
                    VStack(spacing: 0) {
                        Rectangle()
                            .frame(width: width, height: width * 0.5625)
                            .foregroundColor(.secondary)
                        Rectangle()
                        //                            .frame(width: width, height: width * 0.0575)
                            .frame(width: width, height: width * 0.08)
                            .foregroundColor(.clear)
                    }
                }
                
                //FIXME: Debate Title
                Text(debateTitle)
                    .padding(.all)
                    .frame(height: debateTitle.count < 100 ? nil : width * 0.15)
            }
            .foregroundColor(.primary)
        }
    }
}

struct UserPostedDebateCard_Previews: PreviewProvider {
    static var previews: some View {
        UserPostedDebateCard()
            .preferredColorScheme(.dark)
    }
}

//MARK: - TI Card Indicator Circles SV
struct DebateCardIndicatorCirclesSV: View {
    
    var debateChainsCount: Int
    var scale: CGFloat = 1
    
    var body: some View {
        
        HStack {
            
            if debateChainsCount < 10 {
                ForEach(0..<(debateChainsCount < 6 ? debateChainsCount : 5), id: \.self) { i in
                    
                    ZStack {
                        
                        Text("\(debateChainsCount < 6 ? i + 1 : (debateChainsCount - 4 + i))")
//                            .font(debateChainsCount < 10 ? .body : .caption)
                            .fontWeight(.light)
                        
                        Circle()
                            .stroke(lineWidth: 1 * scale)
                            .frame(width: width * 0.05 * scale)
                    }
                    
                }
                
            } else if debateChainsCount < 100 {
                ForEach(0..<5, id: \.self) { i in
                    
                    ZStack {
                        
                        Text("\(debateChainsCount - 4 + i)")
                            .font(.caption)
                        
                        Circle()
                            .stroke(lineWidth: 1 * scale)
                            .frame(width: width * 0.055 * scale)
                    }
                    
                }
            } else {
                
                ForEach(0..<5, id: \.self) { i in
                    
                    ZStack {
                        
                        Text("\(debateChainsCount - 4 + i)")
                            .font(.caption2)
//                            .fontWeight(.light)
                        
                        Circle()
                            .stroke(lineWidth: 0.7 * scale)
                            .frame(width: width * 0.06 * scale)
                    }
                    
                }
            }
        }
        .frame(width: width * 0.5 * scale, height: width * 0.08 * scale)
    }
}
