//
//  Repository.swift
//  CodeAI
//
//  Created by 土井大平 on 2024/03/26.
//

import Foundation

// chat gptで吐いてみた
// GitHubのリポジトリの基本情報を表す構造体
struct Repository: Codable {
    let id: Int
    let name: String
    let fullName: String
    let owner: Owner
    let htmlUrl: String
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case fullName = "full_name"
        case owner
        case htmlUrl = "html_url"
        case description
    }
}

// リポジトリのオーナー情報を簡略化した構造体
struct Owner: Codable {
    let login: String
    let id: Int
    let avatarUrl: String

    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarUrl = "avatar_url"
    }
}
