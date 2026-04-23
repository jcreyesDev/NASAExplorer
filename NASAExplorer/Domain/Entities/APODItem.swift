import Foundation

struct APODItem: Identifiable, Equatable {
    let id: String
    let title: String
    let explanation: String
    let imageURL: URL?
    let hdImageURL: URL?
    let mediaType: MediaType
    let copyright: String?
    let date: String
    let keywords: [String]
    
    enum MediaType: String {
        case image
        case video
        case other
        
        init(rawString: String) {
            self = MediaType(rawValue: rawString) ?? .other
        }
    }
}
