//
//  FeedTab.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 4/17/23.
//

import SwiftUI

//MARK: Feed Tab
//struct FeedTab: View {
//    
//    @StateObject var feedVM: FeedViewModel = FeedViewModel()
//    
//    var body: some View {
//        
//        ScrollView(showsIndicators: true) {
//            
//            //TODO: Add Intro Video
//            LazyVStack {
//                ForEach(feedVM.TITs, id: \.id) { tit in
//                    
//                    FeedCard(tit: tit)
//                }
//            }
//        }
//        .refreshable { Task { try await feedVM.fetchTITs() } } //fetching
//        .overlay { if feedVM.loading { LoadingView()   } } //loading
//    }
//}

//struct FeedTab_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedTab()
//            .preferredColorScheme(.dark)
//    }
//}

//MARK: - Feed Card
struct FeedCard: View {
    
    let tit: TIModel
    
    @State private var showTIT: Bool = false
    
    var body: some View {
        
        
        Button{
            showTIT.toggle()
        } label: {
            
            VStack(spacing: 0) {
                
                //Thumbnail
                ZStack(alignment: .bottom) {
                    
                    //Debate Chains Count
                    DebateCardIndicatorCirclesSV(debateChainsCount: tit.interactionChain.count)
                    
                    //indicators chain Border
                    RoundedRectangle(cornerRadius: 8)
                        .trim(from: 0, to: 0.5)
                        .stroke(lineWidth: 1)
                        .frame(width: width * 0.45, height: width * 0.15)
                        .foregroundColor(.primary)
                    
                    //thumbnail
                    VStack(spacing: 0) {
                        
                        ThumbnailSV(urlSting: tit.thumbnailURLString , name: tit.name)
                            .frame(width: width, height: width * 0.5625)
                        
                        Rectangle()
                            .frame(width: width, height: width * 0.08)
                            .foregroundColor(.clear)
                    }
                }
                
                
                //TIT Title
                HStack(spacing: 0) {
                    Text(tit.name)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 5)
                        .frame(width: width * 0.85, height: width * 0.15, alignment: .topLeading)
                    
                    UserButton(userUID: tit.creatorUID)
                }
                .frame(height: width * 0.18)
                
                Rectangle()
                    .fill(.secondary)
                    .opacity(0.1)
                    .frame(height: width * 0.02)
                
            }
            .foregroundColor(.primary)
        }
        //MARK: - TI 🍃 FSC
        .fullScreenCover(isPresented: $showTIT) {
//            TIView(ti: tit, showTIFSC: $showTIT)
        }
    }
}

//MARK: - Thumbnail SV
struct ThumbnailSV: View {
    
    let urlSting: String?
    let name: String
    var sf: CGFloat = 1
    
    var url: URL? {
        guard let urlSting = urlSting else { return nil }
        return URL(string: urlSting)
    }
    
    var body: some View {
        
        if url != nil {
            ZStack {
                //BackGround
                Rectangle()
//                    .fill(Color.black)
                    .foregroundColor(Color.gray.opacity(0.1))
                
                AsyncImage(url: url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width * sf, height: width * 0.5625 * sf)
                } placeholder: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color.gray.opacity(0.2))
                            .frame(width: width * sf, height: width * 0.5625 * sf)
                        
                        ProgressView()
                    }
                    .frame(width: width * sf, height: width * 0.5625 * sf)
                    
                }
            }
        } else {
            Text(name)
                .background(Color.gray.opacity(0.2))
                .frame(width: width * sf, height: width * 0.5625 * sf)
        }
    }
}
