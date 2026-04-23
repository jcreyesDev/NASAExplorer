import SwiftUI

struct StarsView: View {
    
    private struct Star: Identifiable {
        let id = UUID()
        let x: CGFloat
        let y: CGFloat
        let size: CGFloat
        let opacity: Double
    }
    
    private let stars: [Star] = (0..<80).map { _ in
        Star(x: CGFloat.random(in: 0...1),
             y: CGFloat.random(in: 0...1),
             size: CGFloat.random(in: 1...3),
             opacity: Double.random(in: 0.3...1.0))
    }
    
    var body: some View {
        GeometryReader { geo in
            ForEach(stars) { star in
                Circle()
                    .fill(.white)
                    .frame(width: star.size, height: star.size)
                    .position(x: star.x * geo.size.width, y: star.y * geo.size.height)
                    .opacity(star.opacity)
            }
        }
        .ignoresSafeArea()
    }
}
