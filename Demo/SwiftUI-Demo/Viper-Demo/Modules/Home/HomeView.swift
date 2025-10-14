//
//  Viper_DemoApp.swift
//  Viper-Demo
//
//  Created by Hrvoje Hrvoić on 2025-09-03.
//

import SwiftUI
import Kingfisher

/// Home View
/// The main home interface displaying list of TV shows
struct HomeView: View {
    
    @StateObject var presenter: HomePresenter
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            if presenter.isLoading {
                ProgressView("Loading shows...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground).opacity(0.8))
            } else if presenter.shows.isEmpty {
                EmptyStateView()
            } else {
                ShowsListView(
                    shows: presenter.shows,
                    onShowSelected: presenter.selectShow
                )
            }
        }
        .navigationTitle("Shows")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                LogoutButtonView(onLogout: presenter.logout)
            }
        }
        .alert("Error", isPresented: .constant(presenter.errorMessage != nil)) {
            Button("OK") {
                presenter.clearError()
            }
        } message: {
            if let errorMessage = presenter.errorMessage {
                Text(errorMessage)
            }
        }
        .onAppear {
            presenter.loadShows()
        }
    }
}

// MARK: - Shows List View

private struct ShowsListView: View {
    
    let shows: [Show]
    let onShowSelected: (Show) -> Void
    
    var body: some View {
        List(shows, id: \.id) { show in
            ShowRowView(
                show: show,
                onTap: { onShowSelected(show) }
            )
            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color(.systemBackground))
    }
}

// MARK: - Show Row View

private struct ShowRowView: View {
    
    let show: Show
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 20) {
                ShowImageView(imageUrl: show.imageUrl)
                ShowDetailsView(title: show.title)
                Spacer()
            }
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Show Image View

private struct ShowImageView: View {
    
    let imageUrl: String?
    
    var body: some View {
        KFImage(URL(string: imageUrl ?? ""))
            .placeholder {
                Image("show_placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 64, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Show Details View

private struct ShowDetailsView: View {
    
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 17, weight: .medium))
            .foregroundColor(.primary)
            .multilineTextAlignment(.leading)
            .lineLimit(2)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Logout Button View

private struct LogoutButtonView: View {
    
    let onLogout: () -> Void
    
    var body: some View {
        Button("Logout") {
            onLogout()
        }
        .foregroundColor(.blue)
        .font(.system(size: 17))
    }
}

// MARK: - Empty State View

private struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "tv")
                .font(.system(size: 64))
                .foregroundColor(.gray)
            
            Text("No Shows Available")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Text("Check back later for new content")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

// MARK: - SwiftUI Previews

#Preview("Default State") {
    NavigationStack {
        HomeView(presenter: HomePresenter(
            interactor: HomeInteractor(),
            wireframe: HomeWireframe(navigationPath: .constant(NavigationPath()))
        ))
    }
}

#Preview("Loading State") {
    NavigationStack {
        HomeView(presenter: {
            let presenter = HomePresenter(
                interactor: HomeInteractor(),
                wireframe: HomeWireframe(navigationPath: .constant(NavigationPath()))
            )
            presenter.isLoading = true
            return presenter
        }())
    }
}

#Preview("With Shows") {
    NavigationStack {
        HomeView(presenter: {
            let presenter = HomePresenter(
                interactor: HomeInteractor(),
                wireframe: HomeWireframe(navigationPath: .constant(NavigationPath()))
            )
            presenter.shows = [
                Show(id: "1", averageRating: 4.5, description: "Great show", imageUrl: nil, noOfReviews: 100, title: "Breaking Bad"),
                Show(id: "2", averageRating: 4.2, description: "Another great show", imageUrl: nil, noOfReviews: 85, title: "Game of Thrones")
            ]
            return presenter
        }())
    }
}
