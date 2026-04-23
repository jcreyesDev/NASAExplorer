import SwiftUI

struct APODCardView: View {
    
    let item: APODItem
    
    var body: some View {
        HStack(spacing: 14) {
            AsyncImage(url: item.imageURL) { phase in
                switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Image(systemName: "photo.slash")
                            .foregroundStyle(.white.opacity(0.3))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    case .empty:
                        ProgressView()
                            .tint(.blue)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    @unknown default:
                        EmptyView()
                }
            }
            .frame(width: 90, height: 90)
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12)
                .stroke(.white.opacity(0.1), lineWidth: 1))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption2)
                        .foregroundStyle(.blue.opacity(0.8))
                    Text(item.date)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.5))
                }
                
                if let copyright = item.copyright {
                    HStack(spacing: 4) {
                        Image(systemName: "camera")
                            .font(.caption2)
                            .foregroundStyle(.purple.opacity(0.8))
                        Text(copyright)
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.4))
                            .lineLimit(1)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.3))
        }
        .padding(14)
        .background(.white.opacity(0.06))
        .overlay(RoundedRectangle(cornerRadius: 16)
            .stroke(.white.opacity(0.1), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
