//
//  TiView.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 5/29/24.
//

import SwiftUI


struct TiView: View {
    
    @AppStorage("current_user_uid") var currentUserUID: String = "BXnHfiEaIQZiTcpvWs0bATdAdJo1"
    @Environment(CurrentUser.self) var currentUser

    @State var ti: TI?
    @State var tiVM = TiViewModel()
    @State private var tiChain: [String] = []
    @State private var selectedChainLinkIndex: Int = 0
    @State private var tiChainLink: ChainLink? = nil
    @State var tiPost: Post?
    
    var vmTi = TiViewModel()
    var vmCC = ControlCenterViewModel()
    
    @State private var showPickIntroPostVideoButton: Bool = false
    @Binding var showTiView: Bool
    
    var body: some View {
        
        
        VStack(spacing: 0) {
            
//            FSCHeaderSV(showFSC: $showTiView, text: ti?.title ?? "Couldn't get Ti")
            FSCHeaderSV(showFSC: $showTiView, text: vmTi.ti?.title ?? "Couldn't get Ti")

            
            // - Video
            if tiPost != nil {
                
//                VideoSV(urlString: tiPost!.videoURL ?? "")
                TiPostContentView(post: $tiPost)
                
            } else {    //No Video Show text
                ZStack {
                    Rectangle()
                        .foregroundColor(.gray.opacity(0.2))
                        .frame(width: width, height: width * 0.5625)
                    
                    if let ti = ti {
                        Text(ti.description)
                            .frame(width: width, height: width * 0.5625)
                    }
                    
                }
            }
            
            

            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0){
                    
                    //CC
                    ControlCenter(ti: $ti, tiChain: $tiChain, selectedChainLink: $selectedChainLinkIndex)
                    
                    //Add Intro Video Button
//                    if ti != nil, tiPost != nil {
                    if vmTi.ti != nil, tiPost != nil {

                        if showPickIntroPostVideoButton {
                            PickIntroVideoButton(tiID: ti!.id, introPost: $tiPost)
                                .padding()
                        }
                    }
                    
                    //Selected Post Info
                    TiPostInfo(ti: $ti, tiPost: $tiPost)
                    
                    //Vertical List
                    TiVerticalListView(ti: $ti, tiChain: $tiChain, tiChainLink: $tiChainLink, tiPost: $tiPost, selectedChainLinkIndex: $selectedChainLinkIndex)
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear{ onAppearFetch() }
        .onChange(of: selectedChainLinkIndex) { _, _ in fetchTiPost(); getChainLink() }
    }
    
    //MARK: - Functions
    private func onAppearFetch() {
        
        vmTi.ti = ti
        tiVM.ti = ti
        
        tiChain = vmCC.tiChain(ti: ti)
        selectedChainLinkIndex = vmCC.introPostIndex(ti: ti)
        getChainLink()
        fetchTiPost()
        
//#if DEBUG
//        TIManager.shared.getTi(tiID: TestingModels().tiFromDBID2) { result in
//            switch result {
//            case .success(let gottenTi):
//                ti = gottenTi
//                vmTi.ti = gottenTi
//                tiO.ti = gottenTi
//                tiChain = vmCC.tiChain(ti: ti)
//                selectedChainLinkIndex = vmCC.introPostIndex(ti: ti)
//                getChainLink()
//                fetchTiPost()
//                
//            case .failure(_):
//                ti = nil
//                vmTi.ti = nil
//                tiO.ti = nil
//                tiPost = nil
//            }
//        }
//#endif
        
        
    }
    
    private func fetchTiPost() {
        guard !tiChain.isEmpty else { return }
        guard let ti else { return }
        
        PostManager.shared.getPost(tiID: ti.id, postID: tiChain[selectedChainLinkIndex]) { result in
            switch result{
            case .success(let post):
                tiPost = post
                showPickIntroPostVideoButtonFunc()
                
            case .failure(_): //error
                tiPost = nil
            }
        }
    }
    
    func getChainLink() {
        guard let ti = ti else { return }
        let chainLinkID = tiChain[selectedChainLinkIndex]
        ChainLinkManager.shared.getChainLink(tiID: ti.id, chainID: chainLinkID) { result in
            switch result {
                
            case .success(let gottenChainLink):
                tiChainLink = gottenChainLink
                showPickIntroPostVideoButtonFunc()
                
            case .failure(_):
                tiChainLink = nil
            }
        }
    }
    

    
    //TODO: if selected Index == intro Post index
//    var showPickIntroPostVideoButton: Bool {
//        guard selectedChainLinkIndex == vmTi.introPostIndex(ti: ti) else { return false }
//        guard currentUserUID == ti?.creatorUID else { return false }
//        
//        if tiPost != nil {
//            let hasVideo = tiPost!.type == .video
//            return !hasVideo
//        } else {
//            return false
//        }
//    }
    func showPickIntroPostVideoButtonFunc() {
        guard selectedChainLinkIndex == vmTi.introPostIndex(ti: ti) else {
            showPickIntroPostVideoButton = false; return

        }
        guard currentUserUID == ti?.creatorUID else {
            showPickIntroPostVideoButton = false; return
        }
        
        if tiPost != nil {
            let hasVideo = tiPost!.type == .video
            showPickIntroPostVideoButton = !hasVideo
        } else {
            showPickIntroPostVideoButton = false
        }
    }
}

#Preview {
    TiView(ti: nil, showTiView: .constant(true))
        .environment(CurrentUser().self)
    //TIView()
}
