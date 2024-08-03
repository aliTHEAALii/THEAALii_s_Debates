//
//  ResponseVideoCard.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 5/2/23.
//

import SwiftUI

//MARK: - Voting Video Card
struct VotingVideoCard: View {
    
    let tiID: String
    let tiChainLId: String
    let tiVideoID: String
    @State var tiVideo: TIVideoModel? = nil
    let order: Int
    
    let isAdmin: Bool
    @AppStorage("current_user_uid") private var currentUserId: String = ""

    
//    @StateObject private var cardVM = VotingCardViewModel()
    @State private var showSideOptions: Bool = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            ZStack {
                HStack(spacing: 0) {
                    
                    //Video
                    ZStack(alignment: .topLeading) {
                        if tiVideo != nil {
                            TIVideoPlayerViewOld(tiVideo: $tiVideo, urlString: "", sf: 0.85)
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                            LoadingView() }
                        Text("\(order)")
                            .padding(.all, width * 0.02)
                    }
                    
                    Divider()
                    
                    //Voting
                    if tiVideo != nil {
                        VotingSVOld(tiId: tiID, tiVideo: $tiVideo, showSideOptions: $showSideOptions)
                    } else {
                        ProgressView()
                            .frame(width: width * 0.15, height: width * 0.45)
                    }
                }
                .frame(width: width, alignment: .leading)
                
                
                //MARK: Side Options
                if isAdmin && tiVideo != nil {
                    
                    AdminResponseSideSheet(tiId: tiID, tiChainLId: tiChainLId, tiVideo: tiVideo!,
                                           isAdmin: isAdmin,
                                           showSideSheet: $showSideOptions
                    )
                    .offset(x: showSideOptions ? width * 0.275 : width * 0.777)
                    
                } else if tiVideo != nil {
                    SideSheetForVotingCellOld(isAdmin: isAdmin, showSideSheet: $showSideOptions)
                        .offset(x: showSideOptions ? width * 0.375 : width * 0.68)
                }
            }
            .frame(height: width * 0.5625 * 0.85)
            
            //Video Name
            Text(tiVideo?.name ?? "No Name detected for TI Video")
                .foregroundColor(tiVideo?.name != nil ? .primary : .secondary)
                .frame(width: width * 0.95, height: width * 0.15)
            
            
            Divider()
        }
        .background(Color.black)
        .preferredColorScheme(.dark)
        .onAppear{ Task { try await onAppearFetchTIVideo() } }
    }
    
    //MARK: - Fetch ☕️ Video
    func onAppearFetchTIVideo() async throws {
        do {
            tiVideo = try await TITVideoManager.shared.getTITVideo(TITid: tiID, TITVideoID: tiVideoID)
        } catch {
            
        }
    }
}

struct VotingVideoCard_Previews: PreviewProvider {
    static var previews: some View {
//        VotingVideoCard(tiID: TestingModels().testingTIModel.id, tiChainLId: "cId", tiVideoID: "256", order: 2, isAdmin: false)
        
        TiView(ti: nil, showTiView: .constant(true))

    }
}


//MARK: - View Model
@MainActor
final class VotingCardViewModel: ObservableObject {
    
    @Published var tiVideo: TIVideoModel?
    
    init() { }
    
    
    func fetchTIVideo(tiID: String, tiVideoID: String) async throws {
        do {
            tiVideo = try await TITVideoManager.shared.getTITVideo(TITid: tiID, TITVideoID: tiVideoID)
        } catch {
            print("❌ Error: cound't get TI Video")
        }
    }
    
    
    //MARK: add tiVideo from response List to TiChain
    func addTiVideoToTiChain(tiId: String, tiVideo: TIVideoModel) async throws {
        
        
        do {
            
            //1. create tiChain using Video
            let tiChainId = UUID().uuidString //FIXME: ChainID == VideoID
            let tiChainL = TITChainLModel(id: tiChainId, videoId: tiVideo.id, videoTitle: tiVideo.name, videoThumbnail: tiVideo.thumbnail, responseList: [])
            
            //2. [saving it in chain collection]
            try await TITChainLManager.shared.createCLink(titId: tiId, titCL: tiChainL)
            
            //3. add tiChain to TIModel interactionList
            try await TITManager.shared.addToChain(titId: tiId, chainId: tiChainId)
            
            try await TITVideoManager.shared.addedToChain(tiId: tiId, tiVideoId: tiVideo.id)
            
            print("✅⬆️🧬🔗 Error: cound't Create & add tiChain to TIT ✅")
        } catch {
            print("❌⬆️🧬🔗 Error: cound't Create & add tiChain to TIT ❌")
        }
    }
    
    //MARK: - Voting Functions
    func upVote(tiId: String, tiVideo: TIVideoModel) {
        Task {
            
        }
    }
    
    
    //MARK: Delete TIVideo
    func deleteTIVideoInRSList(tiId: String, tiChainLId: String,
                               tiVideoId: String, tiVideoThumbnailId: String?) async throws {
        Task {
            do {

                
                //1. remove video Id from chainL RS
                try await TITChainLManager.shared.deleteFromResponseList(titId: tiId, titChainLId: tiChainLId, titVideoId: tiVideoId)
                print("is tiVideo Removed from RS???🧐🧪👩‍🔬")
                
                //2. delete TIVideo
                try await TITVideoManager.shared.deleteTIVideo(tiId: tiId, tiVideoId: tiVideoId)
                print("delete tiVideo???🧐🧪👩‍🔬")

                //4. delete thumbnail if exist
                if let tiVideoThumbnailId {
                    print("🧐🧪👩‍🔬 entered image delete")
                    try await ImageManager.shared.deleteImage(imageID: tiVideoThumbnailId, thumbnailFor: .video)
                    print("🧐🧪👩‍🔬 Done~~ image delete")

                }
                
                //3. Delete video from storage reference
                try await VideoManager.shared.deleteVideo(videoID: tiVideoId)
                print("😈😏 video Deleted 🫥🫥👹")
                
                
                
                
                } catch {
                print("❌🎥 couldn't delete video 🎥❌ \(error.localizedDescription)")
                throw error
            }
        }
    }
}
