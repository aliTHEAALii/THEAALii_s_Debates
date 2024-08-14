//
//  ControlCenter.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 6/18/24.
//

import SwiftUI

//MARK: - Ti Control Center Light
struct ControlCenter: View {
    
    @AppStorage("current_user_uid") var currentUserUID: String = "ooo"
    
    @Binding var ti: TI?
    @Binding var tiChain: [String]
    
    @Binding var selectedChainLink: Int
    
    @State private var expandTiControls: Bool = false
    
    var body: some View {
        
        // - Control Center
        ZStack {
            
            VStack(spacing: 0) {
                
                // - Control Center Top Bar - \\
                CCTopBar(ti: $ti,
                         tiChain: $tiChain,
                         selectedChainLink: $selectedChainLink,
                         expandTiControls: $expandTiControls)
                                
                // - Expanded Controls - \\
                if expandTiControls {
                    
                    Divider()
                    
                    VStack(spacing: 0) {
                        // - MAP - \\ //height 0.3
                        CCMap(ti: $ti, tiChain: $tiChain, selectedChainLink: $selectedChainLink)
                        
                        //MARK: - Control Center Bottom(interaction) Bar
                 //b b
                        
                        CCBottomBar(ti: $ti, tiChain: $tiChain)
                        
                    }
                    .frame(width: width, height: width * 0.55)                 //b b
                }
                
            }// - VStack - //
            .frame(height: expandTiControls ? width * 0.7 : width * 0.15)      //b
            
            //Border of the ControlCenter
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(lineWidth: 0.5)
                .foregroundColor(.secondary)
                .frame(width: width,
                       height: expandTiControls ? width * 0.7 : width * 0.15)  //b
            
        }// - ZStack - //
        .preferredColorScheme(.dark)
    }
    
    
    //MARK: Functions
    private func order(index: Int) -> Int {
        guard let ti = ti else { return 0 }
        if index < ti.leftSideChain?.count ?? 0 {
            return (ti.leftSideChain?.count ?? 0) - index
        }
        return index - (ti.leftSideChain?.count ?? 0)
    }
}
#Preview {
    //    TiControlCenter(ti: .constant(<#T##value: TI##TI#>), expandTiControls: <#Bool#>)
    TiView(ti: TestingModels().testTI1nil, showTiView: .constant(true))
}



