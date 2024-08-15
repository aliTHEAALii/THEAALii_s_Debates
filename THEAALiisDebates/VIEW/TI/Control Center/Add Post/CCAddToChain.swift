//
//  CCAddToChain.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 6/15/24.
//

import SwiftUI

struct CCAddToChain: View {
    
    let leftOrRight: LeftOrRight?
    @Binding var ti: TI?
    @Binding var tiChainLink: ChainLink?
    @Binding var tiChain: [String]
    @AppStorage("current_user_uid") var currentUserUID: String = ""

    let postID = UUID().uuidString
    var vm = CCAddToChainVM()
    
    //Post
    @State private var postType: PostType         = .video      //FIXME: - Dynamic
    @State private var postThumbnailData: Data?   = nil
    @State private var postVideoURL: String?      = nil
    @State private var postTitle                  = ""
    @State private var postDescription            = ""
    
    //FSC Controls
    @Binding var showAddPostFSC: Bool
    @State private var isLoading = false
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            //1. Header - Title & Close Button
            HStack(spacing: 0) {
                
                Text(headerText)
                    .font(.title)
                    .foregroundStyle(.white)
                    .frame(width: width * 0.85, height: width * 0.15, alignment: .leading)
                
                //---Close Button
                Button {
                    isLoading = true
                    if postVideoURL != nil {
                        Task {
                            do {
                                try await VideoManager.shared.deleteVideo(videoID: postID)
                                showAddPostFSC.toggle()
                                isLoading = true

                            } catch {
                                print("🆘🎥 Error Closed CCAddPost Button but didn't delete created video 🎥🆘")
                                isLoading = true
                            }

                        }
                    } else {
                        showAddPostFSC.toggle()
                        isLoading = true

                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: width * 0.075, weight: .thin))
                        .foregroundColor(postVideoURL == nil ? .primary : .red)
                }
                .preferredColorScheme(.dark)
            }
            // - Header - Title & Close Button - \\

            //2. Pick Post Type
            PickPostTypeBar(postType: $postType)
            
            
            //3. Pick Post Thumbnail
            if postType != .text {
                PickThumbnailSV(thumbnailFor: .video,
                                thumbnailForTypeId: "change!",
                                imageData: $postThumbnailData,
                                buttonText: "Pick Post \(postType == .image ? "Image" : "Thumbnail")")
                .padding(.top)
            }
            
            
            //4. Pick Video
            if postType == .video {
                PickVideoButton(videoID: postID, videoURL: $postVideoURL)
            }
            
            
            //5. Enter Title & Description
            EnterTiTitle(placeholderText: "Post Title", tiTitle: $postTitle)
            EnterDescriptionButton(description: $postDescription,
                                   buttonTitle: "Enter Post Text",
                                   buttonColor: postType == .text ? .red : .secondary)
            
            
            Spacer()
            
            
            //----6.  Post Button
            Button {
                
                if buttonText == "POST" {
                    
                    //MARK: - Post to Left Or Right Chain
                    if leftOrRight != nil {
                        
                        Task {
                            isLoading = true
                            
                            try await vm.uploadPostToChain(tiID: ti!.id, postID: postID, leftOrRightChain: leftOrRight!, title: postTitle, postType: postType, description: postDescription, imageData: postThumbnailData, videoURL: postVideoURL, creatorUID: currentUserUID)
                            
                            if leftOrRight == .left {
                                tiChain.insert(postID, at: 0)
                                ti?.leftSideChain?.append(postID)
                                
                            } else if leftOrRight == .right {
                                tiChain.append(postID)
                                ti?.rightSideChain.append(postID)
                            }
                            
                            isLoading = false
                            showAddPostFSC = false
                        }
                        
                        //MARK: - Post to Vertical List
                    } else if leftOrRight == nil {
                        
                        Task {
                            isLoading = true
                            if let chainLinkID = tiChainLink?.id {
                                
                                try await VerticalListVM().uploadPostToChainLinkVerticalList(tiID: ti!.id, chainLinkID: chainLinkID, postID: postID, title: postTitle, postType: postType, description: postDescription, imageData: postThumbnailData, videoURL: postVideoURL, creatorUID: currentUserUID) { error in
                                    if (error != nil) {
//                                        isLoading = false
//                                        showAddPostFSC = false
                                    } else {
                                        tiChainLink?.verticalList.append(postID)
                                    }
                                }
                            }
                            isLoading = false
                            showAddPostFSC = false                        }
                    }
                }
                
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                    
                    Text(buttonText)
                }
            }
            .foregroundStyle(buttonText == "POST" ? Color.ADColors.green : .primary)
            .frame(width: width * 0.8, height: width * 0.15)
            .padding(.bottom)
            //Post Button //
            
        }
        .overlay { if isLoading { LoadingView() } }
    }
    
    
    
    
    
    //MARK: - Text
    var headerText: String {
        "Add Post to " + (leftOrRight == .right ? "RIGHT Chain" : "LEFT Chain")
    }
        
    var buttonText: String {
        if postType == .text {
            if postTitle.isEmpty {
                return "Enter Title"
            } else if postDescription.isEmpty {
                return "Enter Post Text"
            } else {
                return "POST"
            }
        } else if postType == .image {
            if postThumbnailData == nil {
                return "Provide Image"
            } else if postTitle.isEmpty {
                return "Enter Title"
            } else {
                return "POST"
            }
        } else if postType == .video {
            if postVideoURL == nil {
                return "Pick A Video"
            } else if postThumbnailData == nil {
                return "Provide Image"
            } else if postTitle.isEmpty {
                return "Enter Title"
            } else {
                return "POST"
            }
        }
        return "POST"
    }
}

#Preview {
    CCAddToChain(leftOrRight: .right, ti: .constant(TestingModels().testTI0), tiChainLink: .constant(nil), tiChain: .constant(["ii"]), showAddPostFSC: .constant(true))
}
















//MARK: - Pick Post Type Bar
struct PickPostTypeBar: View {
    
    @Binding var postType: PostType
    
    var body: some View {
        HStack(spacing: 0) {
            
            //Text Button
            Button {
                postType = .text
            } label: {
                ZStack {
                    if postType == .text {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                    }
                    Text("Text")
                }
                .frame(width: width * 0.33)
            }
            .foregroundStyle(postType == .text ? .primary : .secondary)
            
            
            //Image Button
            Button {
                postType = .image
            } label: {
                ZStack {
                    
                    if postType == .image {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                    }
                    
                    Text("Image")
                }
                .frame(width: width * 0.33)
            }
            .foregroundStyle(postType == .image ? .primary : .secondary)
            
            
            //Video Button
            Button {
                postType = .video
            } label: {
                ZStack {
                    
                    if postType == .video {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                    }
                    
                    Text("Video")
                }
                .frame(width: width * 0.33)
            }
            .foregroundStyle(postType == .video ? .primary : .secondary)
            
        }
        .frame(height: width * 0.125)
    }
}
