//
//  RepositoryListView.swift
//  CodeAI
//
//  Created by 土井大平 on 2024/03/26.
//

import SwiftUI

/**
 Adapt the RepositoryListView in SwiftUI to accept a username upon initialization. This username should be utilized by the GitHubAPIClient class to perform a fetch operation for repositories associated with the specified username. The GitHubAPIClient fetches data from the GitHub API and returns an array of Repository models based on the provided username. Ensure that the RepositoryListView initiates the fetch process using this username when the view is first loaded. Incorporate appropriate loading states and error handling mechanisms, and display the repository names in a user-friendly list format. The implementation should focus on delivering a seamless and informative user experience, with clear feedback during data retrieval and any errors that might occur.
 */
struct RepositoryListView: View {
    @State private var repositories: [Repository] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    private let name: String
    
    init(forUser name: String) {
        self.name = name
    }
    
    private func fetchRepositories(forUser username: String) {
        isLoading = true
        GitHubAPIClient().fetchRepositories(forUser: username) { fetchedRepositories, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    errorMessage = error.localizedDescription
                } else {
                    repositories = fetchedRepositories ?? []
                }
            }
        }
    }
    
    private func fetchRepositories(forUser username: String) async throws {
        isLoading = true
        repositories = try await GitHubAPIClient().fetchRepositories(forUser: username)
        isLoading = false
    }
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
            } else {
                List(repositories, id: \.id) { repository in
                    Text(repository.name)
                }
            }
        }
        .onAppear {
            // normal
            // fetchRepositories(forUser: name)
        }
        .task {
            // Swift Concurrency
            do {
                try await fetchRepositories(forUser: name)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    RepositoryListView(forUser: "doihei")
}
