import SwiftUI

struct SearchView: View {
    
    @StateObject private var viewModel = SearchViewModel()
    @State private var animateBackground = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                spaceBackground
                
                VStack(spacing: 0) {
                    searchBar
                    contentArea
                }
            }
            .navigationTitle("NASA Explorer")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.clear, for: .navigationBar)
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Background
    private var spaceBackground: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.02, green: 0.03, blue: 0.08),
                                    Color(red: 0.05, green: 0.05, blue: 0.25),
                                    Color(red: 0.08, green: 0.02, blue: 0.20)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            StarsView()
        }
        .ignoresSafeArea()
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.blue.opacity(0.8))
            
            TextField("", text: $viewModel.query,
                      prompt: Text("Search galaxies, nebulae, planets...")
                .foregroundStyle(.white.opacity(0.4)))
            .foregroundStyle(.white)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .onSubmit { viewModel.search() }
            .onChange(of: viewModel.query) {
                if viewModel.query.isEmpty {
                    viewModel.clearSearch()
                }
            }
            
            if !viewModel.query.isEmpty {
                Button {
                    viewModel.query = ""
                    viewModel.clearSearch()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.white.opacity(0.5))
                }
            }
        }
        .padding(12)
        .background(.white.opacity(0.08))
        .overlay(RoundedRectangle(cornerRadius: 14)
            .stroke(.white.opacity(0.15), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
    
    // MARK: - Content Area
    @ViewBuilder
    private var contentArea: some View {
        if viewModel.isLoading {
            Spacer()
            loadingView
            Spacer()
        } else if let error = viewModel.errorMessage {
            Spacer()
            errorView(message: error)
            Spacer()
        } else if viewModel.items.isEmpty && !viewModel.query.isEmpty {
            Spacer()
            emptyResultsView
            Spacer()
        } else if viewModel.items.isEmpty {
            Spacer()
            placeholderView
            Spacer()
        } else {
            resultsList
        }
    }
    
    // MARK: - Results List
    private var resultsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.items) { item in
                    NavigationLink(destination: DetailView(item: item)) {
                        APODCardView(item: item)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }
    
    // MARK: - States
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(.circular)
                .tint(.blue)
                .scaleEffect(1.4)
            Text("Searching the cosmos...")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.6))
        }
    }
    
    private var placeholderView: some View {
        VStack(spacing: 16) {
            Text("Explore the Universe")
                .font(.title2.bold())
                .foregroundStyle(.white)
            Text("Search for galaxies, nebulae,\nplanets and more")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.5))
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private var emptyResultsView: some View {
        VStack(spacing: 16) {
            Text("No results found")
                .font(.title3.bold())
                .foregroundStyle(.white)
            Text("Try 'galaxy', 'nebula' or 'Apollo'")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.5))
        }
        .padding()
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundStyle(.orange)
            Text("Something went wrong")
                .font(.title3.bold())
                .foregroundStyle(.white)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.5))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button("Retry") {
                viewModel.search()
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
        }
        .padding()
    }
}
