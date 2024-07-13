//
//  TiCard.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 7/7/24.
//

import SwiftUI


struct TiCard: View {
    
    var ti: TI
    
    @State private var showTiView: Bool = false
    
    var body: some View {
        
        
        Button {
            showTiView = true
        } label: {
            
            VStack(spacing: 0) {
                
                // Thumbnail
                ZStack(alignment: .bottom) {
                    VStack(spacing: 0) {
                        
                        if let thumbnailURL = ti.thumbnailURL {
                            AsyncImage(url: URL(string: thumbnailURL)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: width, height: width * 0.5625)
                                
                            } placeholder: {
                                LoadingView()
                                    .frame(width: width, height: width * 0.5625)
                            }
                        } else {
                            
                        }
                    }
                    .padding(.bottom, ti.tiType == .d2 ? width * 0.17 : width * 0.085)
                    
                    if ti.tiType == .d2 {
                        D2IconBar(ti: ti)
                        
                    } else if ti.tiType == .d1 {
                        TiMapRectD1(ti: ti, cornerRadius: 8, rectWidth: width * 0.5, rectHeight: width * 0.085, stroke: 0.5)
                    }
                }
                
                if ti.tiType == .d2 {
                    Text(ti.title)
                        .foregroundStyle(.white)
                        .padding(.vertical, width * 0.02)
                    
                } else if ti.tiType == .d1 {
                    HStack(spacing: 0) {
                        Text(ti.title)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                            .padding(.horizontal, width * 0.01)
                            .frame(width: width * 0.67, alignment: .leading)
                        
                        UserButton(userUID: ti.creatorUID, horizontalName: true, scale: 0.7, horizontalWidth: width * 0.21)
                    }
                    .frame(height: ti.title.count < 25 ? width * 0.13 : width * 0.17)
                }
            }
        }
        .fullScreenCover(isPresented: $showTiView) {
            TiView(ti: ti, showTiView: $showTiView)
        }
    }
    
    
}


//MARK: - Preview
#Preview {
    
//        D2CardBar(ti: TestingModels().testTI0)
    
    RootView(logStatus: true)
    
//    TiCard2(ti: TestingModels().testTI0)
}



//MARK: - D-2 Card Bar
struct D2IconBar: View {
    
    var ti: TI
    
    //TODO: Pass this to the tiView since the fetch is already done here, don't fetch L & R users again in TiView
    @State var leftUser: UserModel? = nil
    @State var rightUser: UserModel? = nil
    
//    var showNames = true
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            if leftUser != nil {
                UserButton(user: leftUser )
            } else { UserButton() }
            
            
            
            ZStack {
                VStack (spacing: width * 0.0075) {
                    TiMapRect(ti: ti, cornerRadius: 8, rectWidth: width * 0.7, rectHeight: width * 0.085, stroke: 0.5)
                    
                        
                        HStack(spacing: 0) {
                            Text(leftUser?.displayName ?? "nil")
                                .font(.system(size: width * 0.033, weight: .regular))
                            
                            Spacer()
                            
                            Text(rightUser?.displayName ?? "nil")
                                .font(.system(size: width * 0.033, weight: .regular))
                            
                        }
                        .foregroundStyle(.white)
                        
                }
                
                TIIcon()
            }
            
            
            if rightUser != nil {
                UserButton(user: rightUser )
            } else { UserButton() }
        }
        .frame(height: width * 0.2)
        .task { await fetchUser() }
    }
    
    func fetchUser() async {
        guard let lsUserUID = ti.lsUserUID else { return }
        
        do {
            leftUser = try await UserManager.shared.getUser(userId: lsUserUID)
            rightUser = try await UserManager.shared.getUser(userId: ti.rsUserUID)
        } catch {
            print("❌ Couldn't fetch right or left User ❌")
        }
    }
}


//MARK: - Ti Rect Shape
struct TiMapRectangleShape: Shape {
    
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
        
        path.move(to: topLeft)
        path.addArc(tangent1End: bottomLeft, tangent2End: bottomRight, radius: cornerRadius)
        path.addArc(tangent1End: bottomRight, tangent2End: topRight, radius: cornerRadius)
        path.addLine(to: topRight)
        
        
        return path
    }
}

//MARK: Map Rect
struct TiMapRect: View {
    
    let ti: TI
    
    var cornerRadius: CGFloat = 16
    var rectWidth: CGFloat = width * 0.55
    var rectHeight: CGFloat = width * 0.1
    var stroke: CGFloat = 1
    var color: Color = .white
    var fill = false
    
    var body: some View {
        
        ZStack {
            
            if fill {
                TiMapRectangleShape(cornerRadius: cornerRadius )
                    .foregroundStyle(color)
                    .frame(width: rectWidth, height: rectHeight)
                
            } else {
                
                
                ZStack {
                    
                    HStack(spacing: 0) {
                        //left Circles
                        if let leftSideChain = ti.leftSideChain {
                            if leftSideChain.count > 3 {
                                ForEach(0..<4) { i in
                                    CircleForTiCard(number: leftSideChain.count - i)

                                }
                            } else if leftSideChain.count <= 3, !leftSideChain.isEmpty  {
                                ForEach(0..<3) { i in
                                    
                                    
                                    if (3 - i) > leftSideChain.count {
                                        //blank circles for space
                                        CircleForTiCard(number: nil, color: .clear)

                                    } else {
                                        CircleForTiCard(number: 3 - i)
                                    }
                                }
                            }
                        }
                        
                        Rectangle()
                            .foregroundStyle(.clear)
                        
                        //right Circles
                        if ti.rightSideChain.count > 3 {
                            ForEach(0..<4) { i in
                                
                                CircleForTiCard(number: ti.rightSideChain.count - (3 - i))

                            }
                        } else if ti.rightSideChain.count <= 3 && !ti.rightSideChain.isEmpty {
                            ForEach(0..<3) { i in
                                
                                if (i + 1) <= ti.rightSideChain.count {
                                    CircleForTiCard(number: i + 1)
                                } else {
                                    //blank circle for space
                                    CircleForTiCard(number: nil, color: .clear)
                                }
                            }
                        }
                    }
                    .frame(width: rectWidth - width * 0.02, height: width * 0.07)
                    
                    
                    TiMapRectangleShape(cornerRadius: cornerRadius )
                        .stroke(lineWidth: stroke )
                        .foregroundStyle(color)
                        .frame(width: rectWidth, height: rectHeight)
                }
            }
        }
    }
}

//MARK: Map Rect
struct TiMapRectD1: View {
    
    let ti: TI
    
    var cornerRadius: CGFloat = 16
    var rectWidth: CGFloat = width * 0.55
    var rectHeight: CGFloat = width * 0.1
    var stroke: CGFloat = 1
    var color: Color = .white
    var fill = false
    
    var body: some View {
        
        ZStack {
            
            if fill {
                TiMapRectangleShape(cornerRadius: cornerRadius )
                    .foregroundStyle(color)
                    .frame(width: rectWidth, height: rectHeight)
                
            } else {
                
                ZStack {
                    
                    if ti.rightSideChain.count > 3 {
                        ForEach(0..<4) { i in
                            
                            CircleForTiCard(number:ti.rightSideChain.count - (3 - i))
                        }
                        
                    } else if ti.rightSideChain.count <= 3 && !ti.rightSideChain.isEmpty {
                        ForEach(0..<3) { i in
                            
                            if (i + 1) <= ti.rightSideChain.count {

                                CircleForTiCard(number: i + 1, color: Color.secondary)

                            } else {
                                //blank circle for space
                                CircleForTiCard(number: nil, color: .clear)
                            }
                        }
                    }
                    
                    
                    TiMapRectangleShape(cornerRadius: cornerRadius )
                        .stroke(lineWidth: stroke )
                        .foregroundStyle(color)
                        .frame(width: rectWidth, height: rectHeight)
                }
            }
        }
        .foregroundStyle(.gray)
    }
}


//MARK: - Ti Card Circle
struct CircleForTiCard: View {
    
    let number: Int?
    
    var fill = false
    
    var stroke: CGFloat = 0.5
    var color: Color = .secondary
    
    var body: some View {
        
        ZStack {
            if let number {
                Text("\(number)")
                    .font(.system(size: width * fontSize ))
                    .foregroundStyle(.white)
            }
            
            Circle()
                .stroke(lineWidth: stroke)
                .foregroundStyle(color)
                .padding(.horizontal, width * 0.005)
                .frame(height: width * 0.07)
        }
        .padding(.horizontal, width * 0.000)


    }
    
    var fontSize: CGFloat {
        guard let number else { return 0 }
        if number < 10 {
            return 0.035
            
        } else if number < 100 {
            return 0.03
            
        } else {
            return 0.0275
        }
    }
}
