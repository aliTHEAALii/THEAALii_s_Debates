//
//  D1Icon.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 4/10/24.
//

import SwiftUI

//MARK: - D1 Icon
struct D1Icon: View {
    
    var sf: CGFloat = 1
    var showPersonIcon = true

    
    var body: some View {
        
        
        ZStack(alignment: .bottom) {
            
            //FIXME: Debate Chains Count
            
            VStack(spacing: 0) {
                
                RoundedRectangle(cornerRadius: 8 * sf)
                    .stroke(lineWidth: 1 * sf)
                    .foregroundStyle(.white, .white)
                    .frame(width: width * sf, height: width * 0.5625 * sf)
                
                Spacer()
            }
            
            
            TIIconD1(scale: 0.8 * sf)
            
            //Left & Right User Icons
            if showPersonIcon {
                HStack {
//                    PersonIcon(circle: true, scale: 0.2 * sf)
//                        .padding(.leading, width * 0.01 * sf)
                    
                    Spacer()
                    
                    PersonIcon(circle: true, scale: 0.15 * sf)
                        .padding(.trailing, width * 0.01 * sf)
                }
            }
        }
        .frame(width: width * sf, height: width * 0.68 * sf)

    }
}

#Preview {
//    D1Icon()
    D2Icon()
}

//MARK: - D2 Icon Old
struct D2IconOld: View {
    
    var sf: CGFloat = 1
    var showPersonIcon = true

    
    var body: some View {
        
        
        ZStack(alignment: .bottom) {
            
            //FIXME: Debate Chains Count
//            DebateCardIndicatorCirclesSV(debateChainsCount: 1)
//
//            //Border
//            RoundedRectangle(cornerRadius: 8)
//                .trim(from: 0, to: 0.5)
//                .stroke(lineWidth: 1)
//                .frame(width: width * 0.45, height: width * 0.15)
//                .foregroundColor(.primary)

            
            VStack(spacing: 0) {
                
                RoundedRectangle(cornerRadius: 8 * sf)
                    .stroke(lineWidth: 1 * sf)
                    .foregroundStyle(.white, .white)
                    .frame(width: width * sf, height: width * 0.5625 * sf)
                
                Spacer()
            }
            
            
            TIIconD2(scale: 1 * sf, showTwoSides: false)
            
            
            //Left & Right User Icons
            if showPersonIcon {
                HStack {
                    PersonIcon(circle: true, scale: 0.2 * sf)
                        .padding(.leading, width * 0.01 * sf)
                    
                    Spacer()
                    
                    PersonIcon(circle: true, scale: 0.2 * sf)
                        .padding(.trailing, width * 0.01 * sf)
                }
            }
            
        }
        .frame(width: width * sf, height: width * 0.7 * sf)

    }
}


//MARK: - D2 Icon
struct D2Icon: View {
    
    var sf: CGFloat = 1
    var thumbnailUrlString: String? = nil
    
    var body: some View {
        
        
        ZStack(alignment: .bottom) {
            
            //Thumbnail
            VStack(spacing: 0) {
                
                if thumbnailUrlString != nil {
                    ImageView(imageUrlString: thumbnailUrlString, scale: sf)
                } else {
                    RoundedRectangle(cornerRadius: 8 * sf)
                        .stroke(lineWidth: 1 * sf)
                        .foregroundStyle(.white, .white)
                        .frame(width: width * sf, height: width * 0.5625 * sf)
                }
                
                Spacer()
            } // --- //
            
            
            
            //TIIconD2(scale: 1 * sf, showTwoSides: false)

            
            
            //Left & Right User Icons
            ZStack {
                
                RoundedRectangle(cornerRadius: 16 * sf)
                    .stroke(lineWidth: 1 * sf)
                    .foregroundStyle(.gray)
                    .frame(width: width * 0.9 * sf, height: width * 0.08 * sf)
                
                HStack {
                    PersonIcon(circle: true, scale: 0.2 * sf)
                        .padding(.leading, width * 0.01 * sf)
                    
                    Spacer()
                    TiCircleIcon(scale: sf)
                    Spacer()
                    
                    PersonIcon(circle: true, scale: 0.2 * sf)
                        .padding(.trailing, width * 0.01 * sf)
                }
            }
        }
        .frame(width: width * sf, height: width * 0.7 * sf)
        
    }
}
