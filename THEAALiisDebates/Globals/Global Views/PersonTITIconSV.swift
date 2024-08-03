//
//  PersonTITIconSV.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 4/4/23.
//

import SwiftUI

struct PersonTITIconSV: View {
    
    var color = Color.primary
    var fill: Bool = false
    var scale: CGFloat = 1
    
    
    var body: some View {
        
        VStack() {
            Image(systemName: "circle\(fill ? ".fill" : "")")
                .font(.system(size: width * 0.025 * scale, weight: .light))
            
            Image(systemName: "triangle\(fill ? ".fill" : "")")
                .font(.system(size: width * 0.04 * scale, weight: .thin))
                .rotationEffect(.degrees(180))
            
        }
        .foregroundColor(color)
        .preferredColorScheme(.dark)
    }
}

struct PersonTITIconSV_Previews: PreviewProvider {
    static var previews: some View {
        PersonIcon()
        PersonTITIconSV()
    }
}



//MARK: - Person Icon
/// if the user provided no image
struct PersonIcon: View {
    
    var fill: Bool = false
    var color: Color = .primary
    var circle: Bool = true
    var circleColor: Color = .secondary
    var scale: CGFloat = 1
    
    var body: some View {
        
        ZStack {
            //Border
            if circle {
                Circle()
                    .stroke()
                    .foregroundColor(circleColor)
                    .frame(width: width * 0.6 * scale, height: width * 0.6 * scale)
                
                Circle()
                    .foregroundColor(.black)
                    .frame(width: width * 0.6 * scale, height: width * 0.6 * scale)
            }
            
            VStack() {
                Image(systemName: "circle\(fill ? ".fill" : "")")
                    .font(.system(size: width * 0.02 * 7.5 * scale, weight: .light))
                
                Image(systemName: "triangle\(fill ? ".fill" : "")")
                    .font(.system(size: width * 0.04 * 8 * scale, weight: .ultraLight))
                    .rotationEffect(.degrees(180))
            }
            .foregroundColor(color)
        }
        .preferredColorScheme(.dark)
    }
}
