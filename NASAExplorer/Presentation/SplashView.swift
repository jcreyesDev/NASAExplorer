import SwiftUI

struct SplashView: View {
    
    @State private var isActive = false
    @State private var opacity = 0.0
    @State private var scale = 0.8
    
    var body: some View {
        if isActive {
            SearchView()
        } else {
            splashContent
                .onAppear {
                    withAnimation(.easeIn(duration: 0.8)) {
                        opacity = 1.0
                        scale = 1.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isActive = true
                        }
                    }
                }
        }
    }
    
    private var splashContent: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.02, green: 0.03, blue: 0.08),
                                    Color(red: 0.05, green: 0.05, blue: 0.25),
                                    Color(red: 0.08, green: 0.02, blue: 0.20)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            RadialGradient(colors: [Color(red: 0.15, green: 0.10, blue: 0.45).opacity(0.6),
                                    Color.clear],
                           center: .center,
                           startRadius: 10,
                           endRadius: 350)
            .ignoresSafeArea()
            
            StarsView()
            
            VStack(spacing: 20) {
                Text("NASA Explorer")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                
                Text("explore the universe")
                    .font(.subheadline)
                    .foregroundStyle(.blue.opacity(0.8))
                    .tracking(4)
            }
            .opacity(opacity)
            .scaleEffect(scale)
        }
    }
}
