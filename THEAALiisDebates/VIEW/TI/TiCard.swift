//
//  TiCard.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 7/7/24.
//

import SwiftUI


struct TiCard: View {
    
    @State var ti: TI? = nil
    var tiID: String? = nil
        
    @State private var showTiView: Bool = false
    
    var body: some View {
        
        
        Button {
            showTiView = true
        } label: {
            
            VStack(spacing: 0) {
                
                ZStack(alignment: .bottom) {
                    
                    //1. - Thumbnail && Teams
                    ZStack(alignment: .bottom) {
                        //Thumbnail
                        if let thumbnailURL = ti?.thumbnailURL {
                            AsyncImage(url: URL(string: thumbnailURL)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: width, height: width * 0.5625)
                                
                            } placeholder: {
                                ProgressView()
                                    .frame(width: width, height: width * 0.5625)
                            }
                        } else {
                            ImageView(imageUrlString: ti?.thumbnailURL)
                        }
                        
                        //Team
                        if ti?.tiType == .d2 {
                            HStack {
                                //Left Side
                                VStack(spacing: 25) {
                                    
                                    ForEach(ti!.lsLevel1UsersUIDs?.reversed() ?? [], id: \.self) { userUID in
                                        UserButton(userUID: userUID)
                                    }
                                }
                                .frame(height: width * 0.45, alignment: .bottom)
                                .padding(.bottom, 25)
                                
                                Spacer()
                                
                                //Right Side
                                VStack(spacing: 25) {
                                    ForEach(ti!.rsLevel1UsersUIDs?.reversed() ?? [], id: \.self) { userUID in
                                        UserButton(userUID: userUID)
                                    }
                                }
                                .frame(height: width * 0.45, alignment: .bottom)
                                .padding(.bottom, 25)
                            }
                        } else if ti?.tiType == .d1 {
                            HStack {
                                Spacer()
                                
                                //Right Side
                                VStack(spacing: 25) {
                                    ForEach(ti!.rsLevel1UsersUIDs?.reversed() ?? [], id: \.self) { userUID in
                                        UserButton(userUID: userUID)
                                    }
                                }
                                .frame(height: width * 0.5625, alignment: .bottom)
                                .padding(.bottom)
                            }
                        }
                    }
                    .padding(.bottom, ti?.tiType == .d2 ? width * 0.14 : width * 0.085)
                    
                    //2. - Users Bar
                    if ti?.tiType == .d2 {
                        if let ti {
                            D2IconBarNew(ti: ti)
                        }
                        
                    } else if ti?.tiType == .d1 {
                        if let ti {
                            TiMapRectD1(ti: ti, cornerRadius: 8, rectWidth: width * 0.525, rectHeight: width * 0.085, stroke: 0.5)
                        }
                    }
                }
                
                if ti?.tiType == .d2 {
                    Text(ti?.title ?? "No TI")
                        .foregroundStyle(.white)
                        .padding(.vertical, width * 0.02)
                    
                } else if ti?.tiType == .d1 {
                    HStack(spacing: 0) {
                        Text(ti?.title ?? "No TI")
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                            .padding(.horizontal, width * 0.01)
                            .frame(width: width * 0.67, alignment: .leading)
                        
                        UserButton(userUID: ti?.creatorUID, horizontalName: true, scale: 0.7, horizontalWidth: width * 0.21)
                    }
                    .frame(height: ti?.title.count ?? 0 < 25 ? width * 0.13 : width * 0.17)
                }
            }
        }
        .fullScreenCover(isPresented: $showTiView) {
            TiView(ti: ti, showTiView: $showTiView)
        }
        .task {
            do {
                if let tiID {
                    ti = try await TIManager.shared.fetchTI(tiID: tiID)
                }
            } catch {  print("❌ Error Couldn't get TI for Library Tab Cell ❌") }
        }
    }
    
    
}


//MARK: - Preview
#Preview {
    
    //        D2CardBar(ti: TestingModels().testTI0)
    
//    RootView(logStatus: true)
    
    TabsBar()
        .environment(CurrentUser().self)

    //    TiCard2(ti: TestingModels().testTI0)
}




//MARK: - D-2 Card Bar OLD
struct D2IconBarOld: View {
    
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
                
                TiCircleIcon()
            }
            
            
            if rightUser != nil {
                UserButton(user: rightUser )
            } else { UserButton() }
        }
        .frame(height: width * 0.2)
        .task { await fetchUser() }
    }
    
    //MARK: - Fetch User
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

//MARK: - D-2 Card Bar NEW
struct D2IconBarNew: View {
    
    var ti: TI
    
    //TODO: Pass this to the tiView since the fetch is already done here, don't fetch L & R users again in TiView
    @State var leftUser: UserModel? = nil
    @State var rightUser: UserModel? = nil
    
    var scale: CGFloat = 1
    
    var body: some View {
        
        ZStack {
            
            // -  Border & Names
            VStack(spacing: width * 0.0075 * scale) {
                
                //Upper space
                Rectangle()
                    .foregroundStyle(.clear)
                    .frame(height: width * 0.05 * scale)
                
                // Border
                RoundedRectangle(cornerRadius: 16 * scale)
                    .stroke(lineWidth: 1 * scale)
                    .foregroundStyle(.gray)
                    .frame(width: width * 0.9 * scale, height: width * 0.08 * scale)
                
                //Name (left & right) //Bottom Space
                HStack(spacing: 0) {
                    Text(leftUser?.displayName ?? "nil")
                        .font(.system(size: width * 0.033 * scale, weight: .regular))
                    
                    Spacer()
                    
                    Text(rightUser?.displayName ?? "nil")
                        .font(.system(size: width * 0.033 * scale, weight: .regular))
                    
                }
                .foregroundStyle(.white)
                .frame(width: width * 0.775 * scale, height: width * 0.05 * scale)
            } // --- \\
            //            .padding(.top, width * 0.05)
            
            //MARK: - Circles
            HStack(spacing: 0) {
                
                //left Circles
                HStack(spacing: 0) {
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
                }.frame(width: width * 0.4 * scale)
                
                Rectangle()
                    .foregroundStyle(.clear)
                    .frame(width: width * 0.05 * scale)
                
                //right Circles
                HStack(spacing: 0) {
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
                }.frame(width: width * 0.4 * scale)
                
                
            }
            
            // - Ti Icon & Users
            HStack(spacing: 0) {
                
                if leftUser != nil {
                    UserButton(user: leftUser, scale: scale )
                    
                } else {
                    UserButton(scale: scale)
                }
                
                //MARK: - Circle Icon
                Spacer()
                TiCircleIcon(scale: scale)
                Spacer()
                
                
                if rightUser != nil {
                    UserButton(user: rightUser,scale: scale )
                } else {
                    UserButton(scale: scale)
                }
            }
        }
        .frame(height: width * 0.2 * scale)
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



//MARK: Map Rect D-1
struct TiMapRectD1: View {
    
    let ti: TI
    
    var cornerRadius: CGFloat = 16
    var rectWidth: CGFloat = width * 0.7
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
                    
                    //right Circles
                    HStack(spacing: 0) {
                        if ti.rightSideChain.count > 5 {
                            ForEach(0..<6) { i in
                                
                                CircleForTiCard(number: ti.rightSideChain.count - (3 - i))
                                    .padding(.horizontal, 1)

                                
                            }
                        } else if ti.rightSideChain.count <= 5 && !ti.rightSideChain.isEmpty {
                            ForEach(0..<6) { i in
                                
                                if (i + 1) <= ti.rightSideChain.count {
                                    CircleForTiCard(number: i + 1)
                                        .padding(.horizontal, 1)
                                } //else {
                                    //blank circle for space
//                                    CircleForTiCard(number: nil, color: .clear)
//                                }
                            }
                        }
                    }//.frame(width: width * 0.4 * scale)
                    
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
