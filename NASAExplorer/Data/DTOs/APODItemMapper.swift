import Foundation

enum APODItemMapper {
    static func map(_ dto: NASAItemDTO) -> APODItem? {
        guard let data = dto.data.first else { return nil }
        
        let imageURL = dto.links?
            .first(where: { $0.rel == "preview" || $0.rel == nil })
            .flatMap { URL(string: $0.href) }
        
        let formatter = ISO8601DateFormatter()
        let date = formatter.date(from: data.dateCreated)
        
        let displayDate: String
        
        if let date {
            let display = DateFormatter()
            display.dateStyle = .medium
            displayDate = display.string(from: date)
        } else {
            displayDate = String(data.dateCreated.prefix(10))
        }
        
        return APODItem(id: data.nasaId,
                        title: data.title,
                        explanation: data.description,
                        imageURL: imageURL,
                        hdImageURL: imageURL,
                        mediaType: .image,
                        copyright: data.photographer,
                        date: displayDate,
                        keywords: data.keywords ?? [])
    }
    
    static func map(_ dtos: [NASAItemDTO]) -> [APODItem] {
        dtos.compactMap { map($0) }
    }
}
