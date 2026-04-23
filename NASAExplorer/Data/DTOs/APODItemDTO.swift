import Foundation

struct SearchResponseDTO: Decodable {
    let collection: CollectionDTO
}

struct CollectionDTO: Decodable {
    let items: [NASAItemDTO]
}

struct NASAItemDTO: Decodable {
    let data: [NASAItemDataDTO]
    let links: [NASAItemLinkDTO]?
}

struct NASAItemDataDTO: Decodable {
    let nasaId: String
    let title: String
    let description: String
    let dateCreated: String
    let photographer: String?
    let keywords: [String]?
    
    enum CodingKeys: String, CodingKey {
        case nasaId       = "nasa_id"
        case title
        case description
        case dateCreated  = "date_created"
        case photographer
        case keywords
    }
}

struct NASAItemLinkDTO: Decodable {
    let href: String
    let rel: String?
}
