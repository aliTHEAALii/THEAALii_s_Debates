//
//  VotingPostCardContent.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 6/30/24.
//

import SwiftUI


import AVKit

//MARK: - Voting Post Card Content
struct VotingPostCardContent: View {
    
    @Binding var post: Post?
//    var urlString : String
    var sf: CGFloat = 1
    
    // - Player
    @State var player: AVPlayer = AVPlayer()
    @State var isPlaying: Bool = false
    
    @State private var showThumbnail = true
    
    var body: some View {
        
        ZStack {
            if post != nil {
                
                //MARK: - content
                if post!.type == .video {
                    
                    VideoPlayer(player: player)
                    
                } else if post!.type == .image {
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
                } else if post!.type == .text {
                    Text(post?.text ?? "nil")
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal)
                }

                
                //MARK: - Video Content Thumbnail
                if post?.type == .video && thumbnailURL != nil && showThumbnail {
                    Button {
                        thumbnailPressed()
                    } label: {
                        ZStack {
                            //BackGround
                            Rectangle()
                                .fill(Color.black)
                            
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
                            
                            
                            Image(systemName: "play.fill")
                                .foregroundStyle(Color.ADColors.green)
                                .font(.system(size: width * 0.15, weight: .regular))
                            
                        }
                    }
                }
            } else {
                // tiVideo == nil
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                    if let postTitle = post?.title {
                        Text(postTitle)
                    } else {
                        LoadingView()
                    }
                }
                
            }
            
        }// ZStack
        .preferredColorScheme(.dark)
        .frame(width: width * sf, height: width * 0.5625 * sf)
        .onAppear{  onAppearVideoPlayer()  }
        .onChange(of: videoURL) { _, _ in onAppearVideoPlayer() }
    }
    
    
    private var thumbnailURL: URL? {
        guard let thumbnailString = post?.imageURL else { return nil}
        return URL(string: thumbnailString)
    }
    private var videoURL: URL? {
        guard let videoURLString = post?.videoURL else { return nil }
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
        player.play()
    }
}

#Preview {
    TiView(ti: nil, showTiView: .constant(true))

//    VotingPostCardContent()
}
