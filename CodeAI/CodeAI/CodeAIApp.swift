//
//  CodeAIApp.swift
//  CodeAI
//
//  Created by 土井大平 on 2024/03/26.
//

import SwiftUI

@main
struct CodeAIApp: App {
    var body: some Scene {
        WindowGroup {
            RepositoryListView(forUser: "doihei")
        }
    }
}
