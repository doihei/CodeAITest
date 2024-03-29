//
//  GitHubAPIClient.swift
//  CodeAI
//
//  Created by 土井大平 on 2024/03/26.
//

// Please create a GitHub API client using only the standard OS libraries in Swift.
// MARK: - CodeAI Output
import Foundation

class GitHubAPIClient {
    
    private let baseURL = "https://api.github.com"
    
    func fetchRepositories(forUser username: String, completion: @escaping ([Repository]?, Error?) -> Void) {
        let url = URL(string: "\(baseURL)/users/\(username)/repos")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "NoData", code: 0, userInfo: nil))
                return
            }
            
            // Please use Repository model
            do {
                let repositories = try JSONDecoder().decode([Repository].self, from: data)
                completion(repositories, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    func fetchRepositories(forUser username: String) async throws -> [Repository] {
        let url = URL(string: "\(baseURL)/users/\(username)/repos")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let repositories = try JSONDecoder().decode([Repository].self, from: data)
            return repositories
        } catch {
            throw error
        }
    }
}
