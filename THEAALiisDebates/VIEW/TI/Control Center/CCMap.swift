//
//  CCMap.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 6/22/24.
//

import SwiftUI

//MARK: - Ti Map
struct CCMap: View {
    
    @Binding var ti: TI?
    @Binding var tiChain: [String]
    @Binding var selectedChainLink: Int
    
    var ccVM = ControlCenterViewModel()
    
    var body: some View {
        
        if ti != nil {
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    LazyHStack(spacing: 10) {
                        
                        //Black rectangles for the scroll view (empty left & right Chain)
                        if ti?.tiType == .d2 {
                            if (ti?.leftSideChain?.count ?? 0) < 2 {
                                if (ti?.leftSideChain?.count ?? 0) < 1 {
                                    Rectangle()
                                        .foregroundStyle(.clear)
                                        .frame(width: width * 0.22, height: width * 0.5625 * 0.22)
                                }
                                
                                Rectangle()
                                    .foregroundStyle(.clear)
                                    .frame(width: width * 0.11, height: width * 0.5625 * 0.22)
                            }
                        } else {
                            Rectangle()
                                .foregroundStyle(.clear)
                                .frame(width: width * 0.02, height: width * 0.5625 * 0.22)
                        }
                        
                        //ti Chain
                        ForEach(0..<tiChain.count, id: \.self) { i in
                            
                            if i == ControlCenterViewModel().introPostIndex(ti: ti) {
                                
                                //MARK: - Center
                                Button {
                                    selectedChainLink = i
                                } label: {
                                    //TI Icon
                                    TiIconForMap(tiType: ti!.tiType, showTriangle: selectedChainLink == i ? true : false)
                                        .id(i)
                                }
                                
                            } else {
                                
                                CCMapPostSV(ti: $ti, order: ccVM.order(ti: ti!, index: i), selectedChainLink: $selectedChainLink, index: i, chainLinkID: tiChain[i])
                                    .id(i)
                            }
                        }
                        
                        //Black rectangles for the scroll view (empty left & right Chain)
                        //                    if ti!.tiType == .d2  {
                        //                        if ti!.rightSideChain.count < 2 {
                        //                            if ti!.rightSideChain.count < 1 {
                        //                                Rectangle()
                        //                                    .foregroundStyle(.clear)
                        //                                    .frame(width: width * 0.22, height: width * 0.5625 * 0.22)
                        //                            }
                        //
                        //                            Rectangle()
                        //                                .foregroundStyle(.clear)
                        //                                .frame(width: width * 0.11, height: width * 0.5625 * 0.22)
                        //                        }
                        //                    }
                        
                        if ti!.tiType == .d2  {
                            ForEach(0..<numberOfRectangles, id: \.self) { _ in
                                Rectangle()
                                    .foregroundStyle(.clear)
                                    .frame(width: width * 0.22, height: width * 0.5625 * 0.22)
                            }
                            
                        }
                    }
                }
                .onAppear{ proxy.scrollTo(ccVM.introPostIndex(ti: ti), anchor: .center) }
                .onChange(of: selectedChainLink) { _, _ in proxy.scrollTo(selectedChainLink) }
                .onChange(of: tiChain) { _, _ in proxy.scrollTo(ccVM.introPostIndex(ti: ti), anchor: .center) }
                
            }
            .frame(width: width, height: width * 0.3)
        }
        
    }
    
    //MARK: Functions
    private func order(index: Int) -> Int {
        if index < ti?.leftSideChain?.count ?? 0 {
            return (ti?.leftSideChain?.count ?? 0) - index
        }
        return index - (ti?.leftSideChain?.count ?? 0)
    }
    
    var numberOfRectangles:  Int {
        guard let ti else { return 0 }
        guard ti.tiType == .d2 else { return 0}
        let lc = ti.leftSideChain?.count ?? 0
        let rc = ti.rightSideChain.count
        return abs(lc - rc)
    }
}

#Preview {
    TiView(ti: TestingModels().testTI0, showTiView: .constant(true))
}
//#Preview {
//    CCMap(ti: .constant(TestingModels().testTI0), tiChain: ["a", "b"], selectedChainLink: .constant(0) )
//}



//MARK: - VS Map Post SV
struct CCMapPostSV: View {
    
    @Binding var ti: TI?
    let order: Int
    
    @Binding var selectedChainLink: Int
    let index: Int
    
    let chainLinkID: String
    @State private var chainLink: ChainLink? = nil
    
    var body: some View {
        
        Button {
            selectedChainLink = index
        } label: {
            
            ZStack {
                
                ZStack(alignment: .topLeading) {
                    
                    //post & title
                    VStack(spacing: 0) {
                        
                        //thumbnail
                        if let thumbnailURL = chainLink?.thumbnailURL {
                            AsyncImage(url: URL(string: thumbnailURL)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: width * 0.22, height: width * 0.5625 * 0.22)
                                
                            } placeholder: {
                                LoadingView()
                                    .frame(width: width * 0.22, height: width * 0.5625 * 0.22)
                            }
                            
                        } else {
                            
//                            Rectangle()
//                                .foregroundColor(.gray)
//                                .frame(width: width * 0.22, height: width * 0.5625)
                            Text(chainLink?.title ?? "nil")
                                .font(.caption)
                                .frame(width: width * 0.22, height: width * 0.5625 * 0.22 + width * 0.1)


                        }
                        
                        if chainLink?.thumbnailURL != nil {
                            Text(chainLink?.title ?? "nil")
                                .font(.caption)
                                .frame(height: width * 0.1)
                                .foregroundStyle(chainLink == nil ? .secondary : .primary)
                        }
                        
                    }
                    .frame(width: width * 0.22)
                    
                    //order & User
                    HStack() {
                        Text("\(order)")
                        //.padding(.topLeft, width * 0.1)
                        
                        Spacer()
                        
                        if chainLink != nil {
                            UserButton(userUID: chainLink?.creatorUID, scale: 0.5)
                                .frame(height: width * 0.05)
                        }
                    }
                    
                    
                }
                .foregroundStyle(.white)
                
                //Green Border (if selected
                if selectedChainLink == index {
                    Image(systemName: "triangle")
                        .foregroundColor(.ADColors.green)
                        .font(.system(size: width * 0.15, weight: .light))
                        .rotationEffect(.degrees(180))
                    
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(lineWidth: 2)
                        .foregroundStyle(Color.ADColors.green)
                }

            }
            .background(chainLink?.addedFromVerticalList == true ? Color.ADColors.green.opacity(0.2) : .clear )
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
        .onAppear{ getChainLink() }
    }
    
    
    //MARK: - Functions
    func getChainLink() {
        guard let ti = ti else { return }
        ChainLinkManager.shared.getChainLink(tiID: ti.id, chainID: chainLinkID) { result in
            switch result {
                
            case .success(let chainLink):
                self.chainLink = chainLink
                
            case .failure(_):
                chainLink = nil
            }
        }
    }
}
