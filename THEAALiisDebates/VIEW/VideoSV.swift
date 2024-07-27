//
//  VideoSV.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 4/17/23.
//

import SwiftUI
import AVKit

struct VideoSV: View {
    
    @State var player = AVPlayer()
//    @State var player : AVPlayer

    
    let urlString : String
    private var url : URL? { return URL(string: urlString) }
    var heightFactor: CGFloat = 0.5625
    var sf: CGFloat = 1

    
    var body: some View {
        
        VStack() {
            if let url {
                VideoPlayer(player: AVPlayer(url: url))
//                HVideoView(urlString: urlString)
//                VideoPlayer(player: $player)            ///
                    .onAppear{player = AVPlayer(url: url)}
            } else {
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                    Text("Error: Couldn't get video")
                }
                
            }
        }
        .preferredColorScheme(.dark)
        .frame(width: width * sf, height: width * heightFactor * sf)
    }
    

}

struct VideoSV_Previews: PreviewProvider {
    static var previews: some View {
        //        VideoSV(urlString: TestingComponents().videoLink2)
        VotingVideoCard(tiID: "i", tiChainLId: "cid", tiVideoID: "v", tiVideo: TestingModels().titVideo, order: 3, isAdmin: true)
        TIVideoPlayerViewOld(tiVideo: .constant(TestingModels().titVideo), urlString: "", sf: 0.85)

        TIVideoPlayerViewOld(tiVideo: .constant(nil), urlString: "", sf: 0.85)
        VideoSV(urlString: "")
    }
}


//MARK: - TI Video Player SV
struct TIVideoPlayerViewOld: View {
    
    @Binding var tiVideo: TIVideoModel?
    var urlString : String
    var sf: CGFloat = 1
    
    // - Player
    @State var player: AVPlayer = AVPlayer()
    @State var isPlaying: Bool = false
    
    @State private var showThumbnail = true
    
    var body: some View {
        
        ZStack {
            if tiVideo != nil {
                
                //MARK: - Video
//                if let player = player {
                    VideoPlayer(player: player)
//                HVideoView(urlString: urlString)
//                    VideoPlayer(player: $player)            ///
//                } else {
//                    ZStack {
//                        Rectangle()
//                            .fill(Color.gray.opacity(0.2))
//                        LoadingView()
//                    }
//                }

                
                //MARK: - Thumbnail
                if thumbnailURL != nil && showThumbnail {
                    Button {
                        thumbnailPressed()
                    } label: {
                        ZStack {
                            
                            AsyncImage(url: thumbnailURL) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: width * sf, height: width * 0.5625 * sf)
                            } placeholder: {
                                ZStack {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                    LoadingView()
                                }
                                .frame(width: width * sf, height: width * 0.5625 * sf)
                            }
                        }
                        .background(Color.black)
                    }
                }
            } else {
                // tiVideo == nil
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                    if let videoTitle = tiVideo?.name {
                        Text(videoTitle)
                    } else {
                        LoadingView()
                    }
                }
                
            }
            
        }
        .preferredColorScheme(.dark)
        .frame(width: width * sf, height: width * 0.5625 * sf)
        .onAppear{  onAppearVideoPlayer()  }
//        .onChange(of: videoURL) { newValue in
//            onAppearVideoPlayer()
//        }
    }
    
    
    private var thumbnailURL: URL? {
        guard let thumbnailString = tiVideo?.thumbnail else { return nil}
        return URL(string: thumbnailString)
    }
    private var videoURL: URL? {
        guard let videoURLString = tiVideo?.videoURL else { return nil }
        return URL(string: videoURLString)
    }
    
    //MARK: - Functions
    private func onAppearVideoPlayer() {
        guard let videoURL = videoURL else { return }
        player = AVPlayer(url: videoURL)
    }
    
    private func thumbnailPressed() {
        showThumbnail = false
        isPlaying = true
//        if let player = player {
//            isPlaying ? player.play() : player.pause()
            player.play()
//        }
    }
}


//MARK: - Play Button SV -
//struct PlayButtonSV: View {
//    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 8)
//                .fill(Color.black)
//                .frame(width: width * 0.15, height: width * 0.12)
//            //Border
//            RoundedRectangle(cornerRadius: 8)
//                .stroke(lineWidth: 1)
//                .fill(Color.primary)
//                .frame(width: width * 0.15, height: width * 0.12)
//            Image(systemName: "triangle")
//                .font(.title2)
//                .offset(y: width * -0.005)
//                .foregroundColor(.ADColors.green)
//                .rotationEffect(.degrees(90))
//        }
//    }
//}
