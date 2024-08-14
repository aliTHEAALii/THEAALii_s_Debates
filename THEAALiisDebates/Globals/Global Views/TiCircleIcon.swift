//
//  TIIcon.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 8/1/23.
//

import SwiftUI

//MARK: - TiIcon
struct TiCircleIcon: View {
    
    var scale: CGFloat = 1
    var tiType: TIType = .d2
    var rotationDegree: CGFloat = 180
    var timeLapseWeight: Font.Weight = .thin
    var triangleWeight:  Font.Weight = .light
    
    var showTriangle: Bool = true
    
    var body: some View {
        
        ZStack {
            Group {
                Circle()
                    .fill(Color.black)
                Circle()
                    .stroke(lineWidth: 0.7 * scale)
            }
            .frame(width: width * 0.2 * scale)

            
            Image(systemName: "timelapse")
                .foregroundColor(.gray)
                .font(.system(size: width * 0.16 * scale, weight: timeLapseWeight))
            if showTriangle {
                Image(systemName: "triangle")
                    .foregroundColor(.ADColors.green)
                    .font(.system(size: width * 0.06 * scale, weight: triangleWeight))
                    .offset(y: -3 * scale)
                    .rotationEffect(.degrees(tiType == .d2 ? 180 : 180))
            }
        }
        .foregroundColor(.primary)
        .preferredColorScheme(.dark)
    }
}
struct TiIconForMap: View {
    
    let tiType: TIType
    var showTriangle: Bool = true
    
    var body: some View {
        
        ZStack {
            Circle()
                .fill(Color.black)
                .frame(width: width * 0.25)
            Circle()
                .stroke(lineWidth: 0.7)
                .frame(width: width * 0.25)
            
            Image(systemName: "timelapse")
                .foregroundColor(.gray)
                .font(.system(size: width * 0.21, weight: .ultraLight))
            
            if showTriangle {
                Image(systemName: "triangle")
                    .foregroundColor(.ADColors.green)
                    .font(.system(size: width * 0.09, weight: .thin))
                    .offset(y: -3)
                    .rotationEffect(.degrees(tiType == .d2 ? 180 : 90))
            }
        }
        .foregroundColor(.primary)

    }
}

//MARK: - Preview
struct TIIcon_Previews: PreviewProvider {
    static var previews: some View {
//        TiCircleIcon()
        TIIconD1()
//        TIIconD2()
//        CreateTI(showFSC: .constant(true), selectedTabIndex: .constant(2), indexStep: 1)

    }
}

//MARK: - D1 icon
struct TIIconD1: View {
    
    var scale: CGFloat = 1
    var strokeScale: CGFloat = 1
    var rotationDegree: CGFloat = 180
    var timeLapseWeight: Font.Weight = .thin
    var triangleWeight:  Font.Weight = .light
    var showTiIcon = true

    
    var body: some View {
        
        ZStack(alignment: .leading) {
            
            //Border
            RoundedRectangle(cornerRadius: 8 * scale)
                .trim(from: 0, to: 0.5)
                .stroke(lineWidth: 1 * strokeScale)
                .offset(y: width * -0.03 * scale)
                .foregroundColor(.primary)
                .frame(width: width * 0.66 * scale, height: width * 0.15 * scale)
            
//            MiniIndicatorsSV(tiChainCount: 1)
            
        }
    }
}

//MARK: - D2 icon
struct TIIconD2: View {
    
    var scale: CGFloat = 1
    var rotationDegree: CGFloat = 180
    var timeLapseWeight: Font.Weight = .thin
    var triangleWeight:  Font.Weight = .light

    var showTwoSides = true
    
    var body: some View {
        
        ZStack {
            
            //Border
            RoundedRectangle(cornerRadius: 8 * scale)
                .trim(from: 0, to: 0.5)
                .stroke(lineWidth: 1 * scale)
                .offset(y: width * -0.03 *  scale)
                .frame(width: width * 0.7 * scale, height: width * 0.15 * scale)
                .foregroundColor(.primary)
            
            TiCircleIcon(scale: scale, rotationDegree: rotationDegree, timeLapseWeight: timeLapseWeight, triangleWeight: triangleWeight)
            
            //MARK: - Left & Right Users
            if showTwoSides {
                HStack {
                    
                    ZStack {
                        Circle()
                            .frame(width: width * 0.1 * scale)
                            .padding(.leading, width * 0.01 * scale)
                        Circle()
                            .stroke(lineWidth: 2 * scale)
                            .frame(width: width * 0.1 * scale)
                            .padding(.leading, width * 0.01 * scale)
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .frame(width: width * 0.1 * scale)
                            .padding(.leading, width * 0.01 * scale)
                        Circle()
                            .stroke(lineWidth: 2 * scale)
                            .frame(width: width * 0.1 * scale)
                            .padding(.trailing, width * 0.01 * scale)
                    }
                }
                .frame(width: width * scale, height: width * 0.15 * scale)
            }
        }
    }
}
