//
//  SideSheetRectangle.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 7/16/24.
//

import SwiftUI

struct SideSheetRectangle: View {
    
    var cornerRadius: CGFloat = 8
    var rectWidth: CGFloat = width * 0.55
    var rectHeight: CGFloat = width * 0.1
    var color: Color = .white
    var fill = false
    var stroke: CGFloat? = 1

    
    var body: some View {
        
        if fill {
            SideSheetRectangleShape(cornerRadius: cornerRadius)
                .foregroundStyle(color)
                .frame(width: rectWidth, height: rectHeight)
        } else {
            SideSheetRectangleShape(cornerRadius: cornerRadius)
                .stroke(lineWidth: stroke ?? 1 )
                .foregroundStyle(color)
                .frame(width: rectWidth, height: rectHeight)
        }
    }
}

#Preview {
    SideSheetRectangle(cornerRadius: 8, rectWidth: width * 0.3, rectHeight: width * 0.45)
}

struct SideSheetRectangleShape: Shape {
    
    let cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        
        let width = rect.width
        let height = rect.height
        
        // The triangle's three corners.
        let bottomLeft = CGPoint(x: 0, y: height)
        let bottomRight = CGPoint(x: width, y: height)
        
        let topLeft = CGPoint(x: 0, y: 0)
        let topRight = CGPoint(x: width, y: 0)
        
        
        var path = Path()
        
        path.move(to: topRight)
        path.addArc(tangent1End: topLeft, tangent2End: bottomLeft, radius: cornerRadius)
        path.addArc(tangent1End: bottomLeft, tangent2End: bottomRight, radius: cornerRadius)
        
        path.addLine(to: bottomRight)
        
        
        return path
    }
}



