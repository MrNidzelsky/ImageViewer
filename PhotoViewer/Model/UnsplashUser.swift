//
//  UnsplashUser.swift
//  PhotoViewer
//
//  Created by Dmitry  Nidzelsky  on 3/31/20.
//  Copyright © 2020 Dmitry  Nidzelsky . All rights reserved.
//

import Foundation

// MARK: - User
struct UnsplashUser: Codable {
    var id, username, name, firstName: String?
    var lastName, instagramUsername, twitterUsername: String?
    var portfolioURL: String?
    var profileImage: ProfileImage?
    var links: UserLinks?
    
    enum CodingKeys: String, CodingKey {
        case id, username, name
        case firstName = "first_name"
        case lastName = "last_name"
        case instagramUsername = "instagram_username"
        case twitterUsername = "twitter_username"
        case portfolioURL = "portfolio_url"
        case profileImage = "profile_image"
        case links
    }
    
    // MARK: - Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try? container.decode(String.self, forKey: .id)
        self.username = try? container.decode(String.self, forKey: .username)
        self.name = try? container.decode(String.self, forKey: .name)
        
        self.links = try? container.decode(UserLinks.self, forKey: .links)
        
        self.firstName = try? container.decode(String.self, forKey: .firstName)
        self.lastName = try? container.decode(String.self, forKey: .lastName)
        self.instagramUsername = try? container.decode(String.self, forKey: .instagramUsername)
        self.twitterUsername = try? container.decode(String.self, forKey: .twitterUsername)
        self.portfolioURL = try? container.decode(String.self, forKey: .portfolioURL)
    
        self.profileImage = try? container.decode(ProfileImage.self, forKey: .profileImage)
    }
}


// MARK: - UserLinks
struct UserLinks: Codable {
    let linksSelf: String
    let html: String
    let photos, likes: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, likes
    }
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let small, medium, large: String
}
