//
//  FeedTITView.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 4/17/23.
//

import SwiftUI

struct TIViewOld: View {
    
    @AppStorage("current_user_uid") var currentUserId: String = ""
    
    //    let ti: TIModel
    @State var ti: TIModel
    @State private var isAdmin = false
    @State private var currentIndex = 0
    @State private var tiChainL: TITChainLModel? = nil
    @State private var tiVideo: TIVideoModel? = nil
    
    @Binding var showTIFSC: Bool
    var body: some View {
        
        VStack(spacing: 0) {
            
            // - FSC Header
            HStack(spacing: width * 0.02) {
                ScrollView(.horizontal, showsIndicators: false) {
                    Text(ti.name)
//                        .frame(width: width * 0.85, height: width * 0.1)
                }
                .frame(width: width * 0.83, height: width * 0.1)

//                Spacer()
                
                CloseButton(showFSC: $showTIFSC)
            }
            
            // - Video
            if tiVideo != nil {
                
                VideoSV(urlString: tiVideo!.videoURL)
                
            } else {
                ZStack {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.2))
                        .frame(width: width, height: width * 0.5625)
                    ProgressView()
                }
            }
            
            //MARK: Components SVs
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0){
                    
//                    TIControlsSV(ti: $ti, currentIndex: $currentIndex, isAdmin: isAdmin)
                    
                    // - TIT Video Info
                    VideoInfoSV(tit: ti, tiVideo: tiVideo )
                    
                    //TODO: - Move the progress view inside the SVs -
                    
                    //MARK: Response List
                    if tiChainL != nil {
                        
                        ResponseArrayTopBarSV(tiID: ti.id, chainLID: tiChainL!.id, totalVotesInResponseList: tiChainL!.responseList?.count)
                        
                    } else {
                        ProgressView()
                    }
                    
                    Divider()
                    
                    //MARK: - Response Videos
                    if tiChainL != nil {
//                        ForEach(0..<tiChainL.responseList!.count, id: \.self) { i in
//
//                            VotingVideoCard(tiID: ti.id, tiChainLId: tiChainL.id, tiVideoID: tiChainL.responseList![i], order: i + 1, isAdmin: isAdmin)
//                        }
                        ResponseListSV(tiId: ti.id, tiChainL: $tiChainL, isAdmin: isAdmin)
                    } else { ProgressView() }
                    
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: width, height: width * 0.5)
                    
                }
            }
        }// - VStack - //
//        .onAppear{ Task { try await onAppearFetch() } }
//        .onChange(of: currentIndex) { _, _ in Task { try await onChangeOfIndex() } }
    }
    
    //MARK: - Functions
    private func onAppearFetch() async throws {
        if ti.administratorsUID.contains(currentUserId) || ti.creatorUID == currentUserId {
            isAdmin = true
        }
        try await fetchTIChainL(); try await fetchTIVideo()
    }
    private func onChangeOfIndex() async throws {
        tiChainL = nil; tiVideo = nil
        try await fetchTIChainL(); try await fetchTIVideo()
    }
    
    private func fetchTIChainL() async throws  {
        let tiChainLId = ti.interactionChain[currentIndex]
        let chainL = try await TITChainLManager.shared.readCLink(titId: ti.id, titCLinkId: tiChainLId)
        tiChainL = chainL
    }
    private func fetchTIVideo() async throws {
        guard let tiVideoId = tiChainL?.videoId else { return }
        tiVideo = try await TITVideoManager.shared.getTITVideo(TITid: ti.id, TITVideoID: tiVideoId)
    }
}

//MARK: Preview
struct TIView_Previews: PreviewProvider {
    static var previews: some View {
        TIViewOld(ti: TestingModels().testingTIModel, showTIFSC: .constant(true))
    }
}

//MARK: - TI View ViewModel
//@MainActor
//final class TIViewVM: ObservableObject {
//
//    @Published var ti : TIModel?
//    var isAdmin = false
//    @Published var chainL: TITChainLinkModel?
//    @Published var currentLinkNumber: Int = 0
//    @Published var tiVideo: TIVideoModel?
//
//    init() { }
//
//    func onAppear(ti: TIModel, currentUserId: String) async {
//        self.ti = ti
//
//        Task {
//            do {
//                if ti.administratorsUID.contains(currentUserId) || ti.creatorUID == currentUserId { isAdmin = true }
//                let chainId = ti.interactionChain[0]
//                try await getTichain(titId: ti.id, chainId: chainId)
//                try await getTiVideo(titId: ti.id, videoId: chainL!.videoID)
//            } catch {
//                print("❌🧬🔻 Error getting chain Link & Video for TITView: " + error.localizedDescription)
//                throw error
//            }
//        }
//    }
//
//    func getTichain(titId: String, chainId: String) async throws {
//        chainL = try await TITChainLinkManager.shared.getTitChainLink(TITid: titId, titChainID: chainId)
//    }
//
//    func getTiVideo(titId: String, videoId: String) async throws {
//        tiVideo = try await TITVideoManager.shared.getTITVideo(TITid: titId, TITVideoID: videoId)
//    }
//
//}
