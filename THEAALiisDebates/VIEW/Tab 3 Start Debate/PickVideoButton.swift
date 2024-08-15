//
//  PickVideoButton.swift
//  TheAaliiDebates
//
//  Created by Ali Abraham on 4/12/23.
//

import AVKit
import PhotosUI
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift


//MARK: - View Model
@MainActor
final class PickVideoButtonVM: ObservableObject {
    
    func uploadVideoURL(videoModel: VideoModel, videoID: String) async -> String? {
        return await VideoManager.shared.uploadVideo(video: videoModel, videoID: videoID)
    }
    
    func uploadVideoGetUrl(videoModel: VideoModel, videoID: String, completion: @escaping (String?) -> Void) {
        VideoManager.shared.uploadVideoWithHandler(video: videoModel, videoID: videoID) { result in
            switch result {
                
            case .success(let urlString):
                completion(urlString)
                
            case .failure(_):
                completion(nil)
            }
        }
    }
}

//MARK: - View
struct PickVideoButtonOld: View {
    
    @ObservedObject private var createTitVM = CreateTITVM()
    @StateObject    private var videoVM     = PickVideoButtonVM()

    @AppStorage("uploaded_video_id") var uploadedVideoID: String? //FIXME: should remove this
    var videoID: String = ""
    ///
    @Binding var videoURL: String?
    
    enum LoadState {
        case unknown, loading, loaded, failed
    }
    
    @State private var selectedVideo: PhotosPickerItem?
    @State private var loadState: LoadState = .unknown
    
    @Environment(\.dismiss) private var dismiss
    @State private var showVideoPicker = false

    var body: some View {
        
        VStack {

             switch loadState {
            
            case .unknown:
                EmptyView()
                 
            case .loading:
                ProgressView()
                Text("Uploading: Please wait for it to finish.\nDon't close this view.")
                     .foregroundStyle(.red)
                
            case .loaded:
//                 Text("😎🎥📄 VIDEO URL: \(createTitVM.videoURL ?? "") 👽🎥😎")
//                 Text("😎🎥📄🤖 VIDEO URL 2: \(videoURL ?? "") 🤖👽🎥😎")

                 //FIXME: Thread 1: Fatal error: Unexpectedly found nil while unwrapping an Optional value
                 if videoURL != nil {
                     VideoPlayer(player: AVPlayer(url: URL(string: videoURL ?? "")! ) )
                 }
//                 if videoURL != nil {
//                     HVideoView(urlString: videoURL ?? "")
//                         .scaledToFit()
//                         .frame(width: width, height: width * 0.5625)
//                 }
                
                Text("Done Uploading")
                
            case .failed:
                Text("❌🎥Uploading Video failed🎥❌")
            }
            
            //MARK: - Pick Video Button
            Button {
                showVideoPicker.toggle()
            } label: {
                if videoURL != nil || loadState == .loading {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .frame(width: width * 0.8, height: width * 0.1)
                        Text("Pick Another Video")
//                        VideoPlayer(player: AVPlayer(url: URL(string: videoURL!)! ) )
                    }
                    .foregroundStyle(.secondary)
                } else {
                    PickVideoButtonSV()
                }
            }
            .foregroundStyle(.primary)
            .preferredColorScheme(.dark)
            //MARK: - Logic
            .photosPicker(isPresented: $showVideoPicker, selection: $selectedVideo, matching: .videos)
            ///https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-import-videos-using-photospicker
//            .onChange(of: selectedVideo) { _, _ in
//                Task {
//                    do {
//                        loadState = .loading
//                        
////                        createTitVM.videoURL = nil
//                        
//                        if let movie = try await selectedVideo?.loadTransferable(type: VideoModel.self) {
//                            
//                            let uploadedVideoURL: String? = await videoVM.uploadVideoURL(videoModel: movie, videoID: createTitVM.videoId)
//                            
//                            uploadedVideoID = createTitVM.videoId //grab a stable ID (changes because @published)
//                            
//                            createTitVM.videoURL = uploadedVideoURL
//                            ///
//                            videoURL = uploadedVideoURL
//                            loadState = .loaded
//                            print("😎🎥👽 VIDEO URL: \(movie.url) 👽🎥😎")
//                        } else {
//                            loadState = .failed
//                        }
//                    } catch {
//                        loadState = .failed
//                    }
//                }
//            }
            //MARK: - New (Ti onChange)
            .onChange(of: selectedVideo) { _, _ in
                loadState = .loading
                
                selectedVideo?.loadTransferable(type: VideoModel.self) { result in
                    
                    switch result {
                    case .success(let pickedVideo):
                        if let pickedVideo = pickedVideo {
                            
                            //FIXME: - videoID same as postID
                            videoVM.uploadVideoGetUrl(videoModel: pickedVideo, videoID: videoID) { urlString in
                                
//                                let uploadedVideoURL: String? = urlString
                                videoURL = urlString
                                loadState = .loaded
                                print("??😎🎥👽 VIDEO URL: \(pickedVideo.url) 👽🎥😎??")
                            }
                        }
                    case .failure(_):
                        loadState = .failed
                        return
                    }
                }
                
            }
        }
    }
}

struct PickVideoButton_Previews: PreviewProvider {
    static var previews: some View {
        //        PickVideoButton(videoURL: <#Binding<String?>#>)
//        CreateDebateFSC(selectedTabIndex: .constant(1), showFullScreenCover: .constant(true))
        CCAddToChain(leftOrRight: .right, ti: .constant(TestingModels().testTI0), tiChainLink: .constant(nil), tiChain: .constant(["ii"]), showAddPostFSC: .constant(true))
    }
}

//MARK: Pick Video Button SV
struct PickVideoButtonSV: View {
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(lineWidth: 1)
                .foregroundColor(.secondary)
                .frame(width: width, height: width * 0.5625)
            
                
                HStack(spacing: 0) {
                    
                    Text("Pick ")
                        .frame(width: width * 0.3, alignment: .trailing)
                    
                    Image(systemName: "triangle")
                        .font(.system(size: width * 0.075, weight: .light))
                        .frame(width: width * 0.15)
                        .offset(y: -1)
                        .rotationEffect(Angle(degrees: 90))
                    
                    
                    Text("Video")
                        .frame(width: width * 0.3, alignment: .leading)
                    
                }
                .foregroundColor(.ADColors.green)
            .font(.system(size: width * 0.1, weight: .thin))
                
                
            
            VStack {
                
                Text("Duration: Less than 5 minutes")
//                Text("Size: Less than 300 MB")
            }
            .foregroundStyle(.secondary)
            .frame(height: width * 0.37, alignment: .bottom)


        }
        .frame(width: width * 0.8)
    }
}



//MARK: - View
struct PickAVideoButton: View {
    
    @ObservedObject private var createTitVM = CreateTITVM()
    @StateObject private var videoVM = PickVideoButtonVM()

    @AppStorage("uploaded_video_id") var uploadedVideoID: String?

    ///
    @Binding var videoURL: String?
    
    enum LoadState {
        case unknown, loading, loaded, failed
    }
    
    
    @State private var selectedVideo: PhotosPickerItem?
    //    @State private var loadState = LoadState.unknown
    @State private var loadState: LoadState = .unknown
    
    
    @Environment(\.dismiss) private var dismiss
    @State private var showVideoPicker = false

    var body: some View {
        
        VStack {

             switch loadState {
            

            case .unknown:
                EmptyView()
            case .loading:
                ProgressView()
                Text("Uploading: Please wait for it to finish. Don't close this view.")
                
            case .loaded:
//                 Text("😎🎥📄 VIDEO URL: \(createTitVM.videoURL ?? "") 👽🎥😎")
//                 Text("😎🎥📄🤖 VIDEO URL 2: \(videoURL ?? "") 🤖👽🎥😎")

                 //FIXME: Thread 1: Fatal error: Unexpectedly found nil while unwrapping an Optional value
                 VideoPlayer(player: AVPlayer(url: URL(string: videoURL ?? "")! ) )
//                 if videoURL != nil {
//                     HVideoView(urlString: videoURL ?? "")
//                         .scaledToFit()
//                         .frame(width: width, height: width * 0.5625)
//                 }
                
                Text("Done Uploading")
                
            case .failed:
                Text("❌🎥Import Video failed🎥❌")
            }
            Button {
                showVideoPicker.toggle()
            } label: {
                PickVideoButtonSV()
            }
            .preferredColorScheme(.dark)
            .photosPicker(isPresented: $showVideoPicker, selection: $selectedVideo, matching: .videos)
            ///https://www.hackingwithswift.com/quick-start/swiftui/how-to-let-users-import-videos-using-photospicker
            //MARK: - Logic
            .onChange(of: selectedVideo) { _ , _ in
                Task {
                    do {
                        loadState = .loading
                        
//                        createTitVM.videoURL = nil
                        
                        if let movie = try await selectedVideo?.loadTransferable(type: VideoModel.self) {
                            
                            let downloadedvideoURL: String? = await videoVM.uploadVideoURL(videoModel: movie, videoID: createTitVM.videoId)
                            
                            uploadedVideoID = createTitVM.videoId
                            
                            createTitVM.videoURL = downloadedvideoURL
                            ///
                            videoURL = downloadedvideoURL
                            loadState = .loaded
                            print("😎🎥👽 VIDEO URL: \(movie.url) 👽🎥😎")
                        } else {
                            loadState = .failed
                        }
                    } catch {
                        loadState = .failed
                    }
                }
            }
        }
    }
}
