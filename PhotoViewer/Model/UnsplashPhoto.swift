//
//  UnsplashPhoto.swift
//  PhotoViewer
//
//  Created by Dmitry  Nidzelsky  on 3/28/20.
//  Copyright © 2020 Dmitry  Nidzelsky . All rights reserved.
//

import Foundation

final class UnsplashPhoto: Codable, Equatable {
  
    // MARK: - Properties
    
    // "id"
    let photoID: String
    
    // "links" to download
    let links: ResultLinks
    
    // "width" and "height"
    let width: Int
    let height: Int
    
    // "description"
    var description: String?
    
    // "user" (to get username by "name")
    let user: UnsplashUser
    
    // "urls" (to get link by keys: "raw", "full", "thumb", "regular", "small")
    let urls: Urls
    
    // TODO: add property for "location" field
    let location: String?
    
    // MARK: - Decodable
     init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.photoID = try! container.decode(String.self, forKey: .photoID)
        self.links = try! container.decode(ResultLinks.self, forKey: .links)
        self.urls = try! container.decode(Urls.self, forKey: .urls)
        
        self.width = try! container.decode(Int.self, forKey: .width)
        self.height = try! container.decode(Int.self, forKey: .height)
 
        self.user = try! container.decode(UnsplashUser.self, forKey: .user)
        self.description = try? container.decode(String.self, forKey: .description)
        
        self.location = try? container.decode(String.self, forKey: .location)
     }
  
    init (photoID: String, links: ResultLinks, urls: Urls, width: Int,
          height: Int, description: String, user: UnsplashUser, location: String) {
        self.photoID     = photoID
        self.links       = links
        self.urls        = urls
        self.width       = width
        self.height      = height
        self.description = description
        self.user        = user
        self.location    = location
    }
    
    // return url to regular
    func unsplashRegularImageURL() -> URL? {
        if let urlString = self.urls.regular {
            return URL(string: urlString)
        }
        
        return nil
    }
    
    // return url to thumb
    func unsplashThumbImageURL() -> URL? {
        if let urlString = self.urls.thumb {
            return URL(string: urlString)
        }
 
        return nil
    }
    
    
    enum Error: Swift.Error {
        case invalidURL
        case noData
    }
    
    static func ==(lhs: UnsplashPhoto, rhs: UnsplashPhoto) -> Bool {
        return lhs.photoID == rhs.photoID
    }
}

// MARK: - Decoding Keys
fileprivate extension  UnsplashPhoto {
    enum CodingKeys: String, CodingKey {
        case photoID = "id"
        case links
        case width
        case height
        case description
        case user
        case urls
        case location
    }
}

// MARK: - ResultLinks
struct ResultLinks: Codable {
    let linksSelf: String
    let html, download: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case download = "download_location"
        case html
    }
}

// MARK: - Urls
struct Urls: Codable {
    var raw, full, regular, small: String?
    var thumb: String?
}

