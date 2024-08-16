//
//  PickVideoButtonNew.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 8/14/24.
//

import SwiftUI
import AVKit
import PhotosUI
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift


//MARK: - View
struct PickVideoButton: View {
    
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
    
    @State private var loadStateDescriptiveText = ""
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
                Text(loadStateDescriptiveText)
                
            case .loaded:
                
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
                Text("❌ Uploading Video failed ❌")
                Text(loadStateDescriptiveText)
                
                //Pick AnotherVideo
//                if videoURL != nil {
//                    Button {
//                        showVideoPicker.toggle()
//                    } label: {
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 8)
//                                .stroke(lineWidth: 1)
//                                .frame(width: width * 0.8, height: width * 0.1)
//                            Text("Pick Another Video")
//                        }
//                        .foregroundStyle(.secondary)
//                    }
//                }
            }
            
            //MARK: - Pick Video Button
            Button {
                showVideoPicker.toggle()
            } label: {
                if videoURL != nil  { //
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .frame(width: width * 0.8, height: width * 0.1)
                        Text("Pick Another Video")
                    }
                    .foregroundStyle(.secondary)
                } else if loadState == .loading {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .frame(width: width * 0.8, height: width * 0.1)
                        Text("Pick Another Video")
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

            .onChange(of: selectedVideo) { _, _ in
                loadState = .loading
                loadStateDescriptiveText = ""
                
                selectedVideo?.loadTransferable(type: VideoModel.self) { result in
                    
                    switch result {
                        
                    case .success(let pickedVideo):
                        
                        if let pickedVideo {
                            
                            var videoDuration: Double = 0.0//getVideoDuration(url: pickedVideo.url)
                            let videoSizeInMB = getFileSize(url: pickedVideo.url)
                            
                            getVideoDuration(url: pickedVideo.url) { result in
                                switch result {
                                case .success(let duration):
                                    videoDuration = duration
                                    print("🟢Video duration: \(duration) seconds🥎")
                                    
                                    // Check if the video length and size are acceptable (5 min)
                                    if videoDuration > 300.0 { // For example, max 60 seconds
                                        print("🟣🥩🎥🥎 video Duration larger than: 300.0 seconds 🥎🎥🟣")
                                        loadStateDescriptiveText = "Video Duration more than: 5 Minutes"
                                        loadState = .failed
                                        return
                                    }
                                    
                                    if let size = videoSizeInMB, size > 300.0 { // For example, max 50 MB
                                        // Compress the video if it's larger than 50MB
                                        
                                        print("🟣🥩🎥🥎 video Size larger than: 300.0 MB 🥎🎥🟣")
                                        loadStateDescriptiveText = "Compressing Video"
                                        
                                        let outputURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("compressedVideo.mp4")
                                        compressVideo(inputURL: pickedVideo.url, outputURL: outputURL) { success in
                                            if success {
                                                // Proceed with uploading the compressed video
                                                videoVM.uploadVideoGetUrl(videoModel: VideoModel(url: outputURL), videoID: videoID) { urlString in
                                                    loadStateDescriptiveText = "Compressed Video"

                                                    videoURL = urlString
                                                    loadState = .loaded
                                                }
                                            } else {
                                                loadState = .failed
                                                loadStateDescriptiveText = "❌ Failed to Compressing Video"

                                            }
                                        }
                                    } else {
                                        // Proceed with uploading the original video
                                        videoVM.uploadVideoGetUrl(videoModel: pickedVideo, videoID: videoID) { urlString in
                                            videoURL = urlString
                                            loadState = .loaded
                                            
                                        }
                                    }
                                    
                                //---
                                case .failure(let error):
                                    print("🔴Failed to get video duration: \(error)🔴")
                                }
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
    
    //----Works But OutDated
    //    func getVideoDuration(url: URL) -> Double {
    //        let asset = AVAsset(url: url)
    //        return CMTimeGetSeconds(asset.duration) //---This line outdated
    //    }
    func getVideoDuration(url: URL, completion: @escaping (Result<Double, Error>) -> Void) {
        let asset = AVAsset(url: url)
        Task {
            do {
                let duration = try await asset.load(.duration)
                let durationInSeconds = CMTimeGetSeconds(duration)
                completion(.success(durationInSeconds))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func getFileSize(url: URL) -> Double? {
        do {
            let resources = try url.resourceValues(forKeys: [.fileSizeKey])
            if let fileSize = resources.fileSize {
                let fileSizeInMB = Double(fileSize) / (1024 * 1024)
                return fileSizeInMB
            }
        } catch {
            print("Error retrieving file size: \(error.localizedDescription)")
        }
        return nil
    }
    
    func compressVideo(inputURL: URL, outputURL: URL, completion: @escaping (Bool) -> Void) {
        let asset = AVAsset(url: inputURL)
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality)
        exportSession?.outputURL = outputURL
        exportSession?.outputFileType = .mp4
        exportSession?.shouldOptimizeForNetworkUse = true
        
        exportSession?.exportAsynchronously {
            switch exportSession?.status {
            case .completed:
                completion(true)
            case .failed, .cancelled:
                completion(false)
            default:
                completion(false)
            }
        }
    }
    
}

#Preview {
    CCAddToChain(leftOrRight: .right, ti: .constant(TestingModels().testTI0), tiChainLink: .constant(nil), tiChain: .constant(["ii"]), showAddPostFSC: .constant(true))
}




//MARK: - Old Way Of uploading Video
//----(no checking Video Duration & Size)-----

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
//            .onChange(of: selectedVideo) { _, _ in
//                loadState = .loading
//
//                selectedVideo?.loadTransferable(type: VideoModel.self) { result in
//
//                    switch result {
//                    case .success(let pickedVideo):
//                        if let pickedVideo = pickedVideo {
//
//                            //FIXME: - videoID same as postID
//                            videoVM.uploadVideoGetUrl(videoModel: pickedVideo, videoID: videoID) { urlString in
//
////                                let uploadedVideoURL: String? = urlString
//                                videoURL = urlString
//                                loadState = .loaded
//                                print("??😎🎥👽 VIDEO URL: \(pickedVideo.url) 👽🎥😎??")
//                            }
//                        }
//                    case .failure(_):
//                        loadState = .failed
//                        return
//                    }
//                }
//
//            }
