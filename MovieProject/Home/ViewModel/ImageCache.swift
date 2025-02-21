

import SwiftUI

@MainActor
class ImageCache: ObservableObject {
    
    @Published var images: [String: Image] = [:]
    @Published var errorMessage: String?
    
    private static let cache = NSCache<NSString, UIImage>()
    
    func loadImage(from url: String) async {
        if let cachedImage = ImageCache.cache.object(forKey: url as NSString) {
            images[url] = Image(uiImage: cachedImage)
            return
        }
        
        guard let imageURL = URL(string: url) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: imageURL)
            if let downloadedImage = UIImage(data: data) {
                ImageCache.cache.setObject(downloadedImage, forKey: url as NSString)
                images[url] = Image(uiImage: downloadedImage)
                
            }
        } catch {
            errorMessage = "Failed to load image!"
        }
    }
}
