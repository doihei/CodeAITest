//
//  CodeAITests.swift
//  CodeAITests
//
//  Created by 土井大平 on 2024/03/26.
//

import XCTest
@testable import CodeAI

class GitHubAPIClientTests: XCTestCase {
    
    func testFetchRepositoriesCompletionSuccess() {
        let apiClient = GitHubAPIClient()
        
        apiClient.fetchRepositories(forUser: "doihei") { repositories, error in
            XCTAssertNotNil(repositories)
            XCTAssertNil(error)
        }
    }
    
    func testFetchRepositoriesCompletionFailure() {
        let apiClient = GitHubAPIClient()
        
        apiClient.fetchRepositories(forUser: "nonExistentUser") { repositories, error in
            XCTAssertNil(repositories)
            XCTAssertNotNil(error)
        }
    }
    
    func testFetchRepositoriesAsyncSuccess() async {
        do {
            let repositories = try await GitHubAPIClient().fetchRepositories(forUser: "doihei")
            XCTAssertNotNil(repositories)
        } catch {
            XCTFail("Error thrown when fetching repositories asynchronously")
        }
    }
    
    func testFetchRepositoriesAsyncFailure() async {
        do {
            _ = try await GitHubAPIClient().fetchRepositories(forUser: "nonExistentUser")
            XCTFail("No error thrown when fetching repositories for non-existent user")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func testRepositoryModelDecoding() {
        let json = """
                [
                   {
                     "id": 12345,
                     "name": "sample-repo1",
                     "full_name": "owner/sample-repo1",
                     "owner": {
                       "login": "owner",
                       "id": 54321,
                       "avatar_url": "https://example.com/avatar.jpg"
                     },
                     "html_url": "https://github.com/owner/sample-repo2",
                     "description": "This is a sample repository"
                   },
                    {
                      "id": 12346,
                      "name": "sample-repo2",
                      "full_name": "owner/sample-repo2",
                      "owner": {
                        "login": "owner",
                        "id": 54321,
                        "avatar_url": "https://example.com/avatar.jpg"
                      },
                      "html_url": "",
                      "description": "This is a sample repository"
                    }
                ]
                """.data(using: .utf8)!
        
        do {
            let repositories = try JSONDecoder().decode([Repository].self, from: json)
            
            XCTAssertEqual(repositories.count, 2)
            XCTAssertNotEqual(repositories[0].id, repositories[1].id)
            XCTAssertEqual(repositories[0].owner.id, repositories[1].owner.id)
            
        } catch {
            XCTFail("Error decoding Repository model from JSON")
        }
    }
    
}
