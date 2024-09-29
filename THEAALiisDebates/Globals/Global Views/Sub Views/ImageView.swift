//MARK: - Image View
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