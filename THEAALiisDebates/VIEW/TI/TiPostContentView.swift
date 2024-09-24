//
//  TiPostContentView.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 7/26/24.
//

import SwiftUI

struct TiPostContentView: View {
    
    @AppStorage("current_user_uid") var currentUserUID: String = "BXnHfiEaIQZiTcpvWs0bATdAdJo1"

    @Binding var post: Post?
    
    @State var scale: CGFloat = 1
    
    var body: some View {
        
        ZStack {
                
            if post != nil {
                
                if post!.type == .video {
                    
                    VideoSV(urlString: post!.videoURL ?? "")
                    
                } else if post!.type == .image {
                    
                    ImageView(imageUrlString: post!.imageURL)
                    
                } else if post!.type == .text {
                    
                    if post!.text!.isEmpty {
                        
                        Text("NO Text")
                            .frame(width: width * scale, height: width * 0.5625 * scale)
                            .background(Color.gray.opacity(0.1))


                    }
                    Text(post!.text ?? "NO Text")
                        .multilineTextAlignment(.center)
                    
                }
                    
            } else {
                Rectangle()
                    .foregroundStyle(.secondary.opacity(0.15))
            }
            
        }
        .frame(width: width * scale, height: width * 0.5625 * scale)
    }
}

#Preview {
//    TiPostContentView(post: .constant(nil))
    
    TiView(ti: nil, showTiView: .constant(true))

}


struct ImageView: View {
    
    var imageURL: URL? = nil
    var imageUrlString: String? = nil
    
    var scale: CGFloat = 1

    
    var body: some View {
        
        ZStack {
            
            AsyncImage(url: thumbnailURL) { image in
                
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width * scale, height: width * 0.5625 * scale)
                
                
            } placeholder: { ProgressView() }
        }
        .background(Color.gray.opacity(0.15))
        .frame(width: width * scale, height: width * 0.5625 * scale)

    }
    
    private var thumbnailURL: URL? {
        
        if imageURL != nil {
            return imageURL
        } else {
            
            guard let imageUrlString else { return nil }
            
            return URL(string: imageUrlString)
        }
    }

}


//1st new commit
