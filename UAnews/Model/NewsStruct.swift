//
//  NewsStruct.swift
//  UAnews
//
//  Created by Ruslan Veleshchuk on 01.08.2024.
//

import Foundation

struct Source: Codable {
    let id: String?
    let name: String
}

struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    
}

struct Response: Codable {
    var status: String = ""
    var totalResults: Int = 0
    var articles: [Article] = []
}
