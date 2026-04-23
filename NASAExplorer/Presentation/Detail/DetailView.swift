import SwiftUI

struct DetailView: View {
    
    let item: APODItem
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.02, green: 0.03, blue: 0.08),
                                    Color(red: 0.05, green: 0.05, blue: 0.25),
                                    Color(red: 0.08, green: 0.02, blue: 0.20)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            StarsView()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    heroImage
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text(item.title)
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        metaInfo
                        
                        if !item.keywords.isEmpty {
                            keywordsView
                        }
                        
                        Rectangle()
                            .fill(.white.opacity(0.1))
                            .frame(height: 1)
                        
                        Text(item.explanation)
                            .font(.body)
                            .foregroundStyle(.white.opacity(0.8))
                            .lineSpacing(6)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.clear, for: .navigationBar)
    }
    
    private var heroImage: some View {
        GeometryReader { geo in
            AsyncImage(url: item.imageURL) { phase in
                switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: 280)
                            .clipped()
                    case .failure:
                        Rectangle()
                            .fill(.white.opacity(0.05))
                            .frame(width: geo.size.width, height: 280)
                            .overlay(Image(systemName: "photo.slash")
                                .foregroundStyle(.white.opacity(0.3))
                                .font(.largeTitle))
                    case .empty:
                        Rectangle()
                            .fill(.white.opacity(0.05))
                            .frame(width: geo.size.width, height: 280)
                            .overlay(ProgressView().tint(.blue))
                    @unknown default:
                        EmptyView()
                }
            }
        }
        .frame(height: 280)
    }
    
    private var metaInfo: some View {
        HStack(spacing: 10) {
            Label(item.date, systemImage: "calendar")
                .font(.caption)
                .foregroundStyle(.blue.opacity(0.9))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.blue.opacity(0.12))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(.blue.opacity(0.3), lineWidth: 1))
            
            if let copyright = item.copyright {
                Label(copyright, systemImage: "camera")
                    .font(.caption)
                    .foregroundStyle(.purple.opacity(0.9))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.purple.opacity(0.12))
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(.purple.opacity(0.3), lineWidth: 1))
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var keywordsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(item.keywords.prefix(8), id: \.self) { keyword in
                    Text(keyword)
                        .font(.caption2)
                        .foregroundStyle(.cyan.opacity(0.9))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.cyan.opacity(0.08))
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(.cyan.opacity(0.25), lineWidth: 1))
                }
            }
        }
    }
}
