//
//  CCTopBar.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 6/20/24.
//

import SwiftUI

struct CCTopBar: View {
    
    @Binding var ti: TI?
    @Binding var tiChain: [String]
    
    @Binding var selectedChainLink: Int
    
    var vm = ControlCenterViewModel()
    
    @Binding var expandTiControls: Bool
    
    var body: some View {
        
        //Control Center Top Bar
        HStack(spacing: 0) {
            
            //MARK: Left button
            Button { moveCurrentIndex(rightOrLeft: .left) } label: {
                TiTriangle(scale: 0.125, stroke: width * 0.01)
                    .rotationEffect(.degrees(-90))
            }
            .frame(width: width * 0.15)                 //i
            
            Divider()
                .frame(height: width * 0.15)            //d
            
            
            
            
            
            //MARK: - //--- Bar ---\\
            Button {
                expandTiControls.toggle()
            } label: {
                
                if ti != nil {
                    CCIndicatorCircles(ti: $ti, tiChain: $tiChain, selectedChainLink: $selectedChainLink, expandTiControls: $expandTiControls)
                }
            }
            .foregroundStyle(.white)
            .frame(width: width * 0.7, height: width * 0.1)         //i
            
            
            
            Divider()
                .frame(height: width * 0.15)                         //d
            
            
            //MARK: Right Button
            Button { moveCurrentIndex(rightOrLeft: .right) } label: {
                TiTriangle(scale: 0.125, stroke: width * 0.01)
                    .rotationEffect(.degrees(90))
            }
            .frame(width: width * 0.15)             //i
        }
        .frame(width: width, height: width * 0.15)
    }
    
    private func moveCurrentIndex(rightOrLeft: LeftOrRight) {
        if rightOrLeft == .right {
            
            //TODO: -
            if selectedChainLink < vm.tiChain(ti: ti).count - 1 { selectedChainLink += 1 }
            
        } else if rightOrLeft == .left {
            
            if selectedChainLink > 0 {   selectedChainLink -= 1    }
        }
    }
}

#Preview {
    
    TiView(ti: TestingModels().testTId2, showTiView: .constant(true))
    
    //    CCD2TopBar(tiChainCount: 6, introPostIndex: 0, currentCLIndex: .constant(1), expandTiControls: .constant(true))
}




//MARK: - CC Indicator Circles
struct CCIndicatorCircles: View {
    
    @Binding var ti: TI?
    @Binding var tiChain: [String]
    
    @Binding var selectedChainLink: Int
    
    private let ccVM = ControlCenterViewModel()
    
    @Binding var expandTiControls: Bool
    
    var body: some View {
        
        ScrollViewReader { proxy in
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    
                    //Left Rectangle : For Centering scrollView content
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.clear)
                        .frame(width: leftRectangleWidth, height: width * 0.05)
                    
                    ForEach(0..<ccVM.tiChain(ti: ti).count, id: \.self) { i in
                        
                        //MARK: - Intro C
                        if i == introPostIndex {
                            ZStack {
                                TiCircleIcon(scale: 0.4, tiType: ti!.tiType,
                                             showTriangle: selectedChainLink == i ? true : false )
                                .id(i)
                            }
                            .frame(width: width * 0.1)
                            
                            //MARK: - Triangle C
                        } else if i == selectedChainLink {
                            ZStack {
                                TiTriangle(scale: 0.15, stroke: 5,
                                           color: Color.ADColors.green)
                                .offset(y: -(width * 0.0025))
                            }
                            .frame(width: width * 0.1)
                            
                            //MARK: - Regular Circles C
                        } else {
                            ZStack {
                                Circle()
                                    .stroke(lineWidth: 0.5)
                                    .foregroundStyle(.secondary)
                                    .frame(width: width * 0.075)
                                
                                if ti != nil {
                                    Text("\(ccVM.order(ti: ti!, index: i))")
                                    //                                    .fontWeight(.medium)
                                        .foregroundStyle(expandTiControls ? .secondary : .primary)
                                }
                            }
                            .frame(width: width * 0.1)
                        }
                    }
                    
                    //Right Rectangle : For Centering scrollView content
                    if ti?.tiType == .d2 {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.clear)
                            .frame(width: rightRectangleWidth, height: width * 0.05)
                    }
                }
                .padding(.horizontal, width * 0.002)
            }
            .onAppear{ proxy.scrollTo(ccVM.introPostIndex(ti: ti), anchor: .center) }
            .onChange(of: selectedChainLink) { _, _ in proxy.scrollTo(selectedChainLink) }
            .onChange(of: tiChain) { _, _ in proxy.scrollTo(ccVM.introPostIndex(ti: ti), anchor: .center) }
        }
        .frame(maxWidth: width * 0.69, minHeight: width * 0.15)
    }
    
    var introPostIndex: Int { TiViewModel().introPostIndex(ti: ti) }
    
    //For centering scrollView content
    var leftRectangleWidth: CGFloat {
        
        //return width * CGFloat(tiChainsCount) * 0.1 * 0.5     //Pushes to the Middle\\
        
        if ccVM.tiChain(ti: ti).count < 7 {
            return width * CGFloat(7 - ccVM.tiChain(ti: ti).count) * 0.1 * 0.5
        } else {
            return 0
        }
    }
    var rightRectangleWidth: CGFloat {
        width * 0.1 - leftRectangleWidth
    }
    
}
