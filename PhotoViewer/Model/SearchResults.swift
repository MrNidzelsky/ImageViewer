//
//  SearchResults.swift
//  PhotoViewer
//
//  Created by Dmitry  Nidzelsky  on 3/28/20.
//  Copyright © 2020 Dmitry  Nidzelsky . All rights reserved.
//

import Foundation

// MARK: - Search results
struct SearchResults: Codable {
    let total : Int
    let totalPages : Int
    var searchResults : [UnsplashPhoto]?
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case searchResults = "results"
    }
    
    // MARK: - Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.total = try! container.decode(Int.self, forKey: .total)
        self.totalPages = try! container.decode(Int.self, forKey: .totalPages)
        self.searchResults = try? container.decode([UnsplashPhoto].self, forKey: .searchResults)
    }
    
}

