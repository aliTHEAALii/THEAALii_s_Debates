//
//  PickNewThumbnailBar.swift
//  THEAALiisDebates
//
//  Created by Ali Kadhum on 9/28/24.
//
import SwiftUI
import PhotosUI


struct PickNewThumbnailBar: View {
    
    enum ThumbnailFor: String {
        case TI = "TIs_Thumbnails", video = "Video_Thumbnails"
    }
    
    let thumbnailFor: ThumbnailFor
    let thumbnailForTypeId: String
    let thumbnailUrlString: String?
    //    @Binding var imageURL: String?
    @State var imageData: Data? = nil //URL
    
    let buttonText: String
    
    @AppStorage("current_user_uid") var currentUserUID: String = ""
    
    @Environment(\.dismiss) var dismiss
    @State var showImagePicker = false
    @State var selectedPhoto: PhotosPickerItem?
    
    @State private var isLoading: Bool = false
    
    var body: some View {
        
        HStack() {
            
            Text("Change " + buttonText)
                .foregroundColor(.secondary)
            
            Spacer()
            
            //remove Image Button
//            if imageData != nil {
//                Button {
//                    imageData = nil
//                } label: {
//                    Image(systemName: "xmark.circle.fill")
//                        .font(.title)
//                        .foregroundColor(.secondary)
//                }
//            }
            
            //pickImageButton
            if !isLoading {
                Button {
                    showImagePicker.toggle() //= TestingComponents().imageURLStringDesign'nCode
                } label: {
                    
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 1)
                            .frame(width: width * 0.22, height: width * 0.5625 * 0.22)
                        
                        if imageData == nil {
                            
                            ImageView(imageUrlString: thumbnailUrlString, scale: 0.22)
                            
                        } else {
                            
                            Image(uiImage: UIImage(data: imageData! )!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: width * 0.22, height: width * 0.5625 * 0.22)
                        }
                    }
                }
                .padding(.trailing, 2)
                .foregroundColor(.primary)
                
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .frame(width: width * 0.22, height: width * 0.5625 * 0.22)
                    
                    ProgressView()
                }
                .padding(.trailing, 2)
            }
            
        }
        .frame(width: width, alignment: .leading)
        .preferredColorScheme(.dark)
        //MARK: pick
        .photosPicker(isPresented: $showImagePicker, selection: $selectedPhoto, matching: .images)
        .onChange(of: selectedPhoto) { _, newValue in
            //extracting uiImage from photoItem

            if let newValue {
                Task {
                    do {
                        isLoading = true
                        
                        guard let imageData = try await newValue.loadTransferable(type: Data.self) else { return }
                        
                        await MainActor.run(body: {
                            self.imageData = imageData
                        })
                        
                        //                        let _ = await saveImage(image: UIImage(data: imageData)!)
                        let imageUrlString = await ImageManager.shared.saveImage(imageData: imageData, thumbnailFor: .TI, thumbnailForTypeId: thumbnailForTypeId)
                        
                        guard let imageUrlString else {
                            try await ImageManager.shared.deleteImage(imageID: thumbnailForTypeId, thumbnailFor: .TI)
                            return
                        }
                        
                        try await TIManager.shared.updateTiThumbnail(tiID: thumbnailForTypeId, thumbnailUrlString: imageUrlString)
                        
                        isLoading = false
                        
                    } catch {
                        print("❌🤬📸Error: selecting image failed\(error.localizedDescription)")
                        isLoading = false
                    }
                }
            }
        }
    }
}


#Preview {
//    iiView(ti: .constant(TiViewModel().ti))
    
    TiView(ti: nil, showTiView: .constant(true))
}
