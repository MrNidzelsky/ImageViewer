//
//  Unsplash.swift
//  PhotoViewer
//
//  Created by Dmitry  Nidzelsky  on 3/28/20.
//  Copyright © 2020 Dmitry  Nidzelsky . All rights reserved.
//

import Foundation
import UIKit

let accessKey = "2fYS8fVlbfGza931eEWeFbcNZYe5pzjpgQ45y-d45sM"
let baseUrl = "https://api.unsplash.com/"

protocol UnsplashAPIProtocol: AnyObject {
    func searchUnsplash(for searchTerm: String, pageNumber: Int,
                        completion: @escaping (Result<SearchResults>) -> Void)
}


class UnsplashClient: UnsplashAPIProtocol {
  
    private let httpService = HttpService()
    
    enum Error: Swift.Error {
        case unknownAPIResponse
        case generic
    }
  
    func searchUnsplash(for searchTerm: String, pageNumber: Int,
                        completion: @escaping (Result<SearchResults>) -> Void) {
        
        // create search url
        guard let searchURL = unsplashSearchURL(for: searchTerm, pageNumber: pageNumber) else {
            completion(Result.error(Error.unknownAPIResponse))
            return
        }
    
        let headerField = "Authorization"
        let value = "Client-ID \(accessKey)"
        
        // search with GET request
        httpService.httpGetRequest(by: searchURL, headers: [headerField : value]) { ( requestResult ) in
            switch requestResult {
            case .error(let error) :
                print("httpGetRequest Error: \(error)")
            case .results(let data):
                
                // Decoding
                let decodedResult = self.decode(modelType: SearchResults.self, data: data)
                   
                let results = decodedResult?.searchResults
                let total = decodedResult?.total ?? 0
                
                if total == 0 {
                    completion(Result.error(Error.generic))
                    return
                }
                
                // check results count
                guard results?.count ?? 0 > 0
                    else {
                        DispatchQueue.main.async {
                            completion(Result.error(Error.unknownAPIResponse))
                        }
                        return
                }

                if let results = decodedResult {
                    DispatchQueue.main.async {
                        completion(Result.results(results))
                    }
                }
            }
        }
    }
  

    // decoder
    func decode<T>(modelType: T.Type, data: Data) -> T? where T : Decodable  {
        guard let result = try? JSONDecoder().decode(modelType, from: data) else {
            return nil
        }
        return result
    }

    private func unsplashSearchURL(for searchTerm:String, pageNumber: Int) -> URL? {
        guard let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
            return nil
        }

        var urlString = "\(baseUrl)/search/photos?query=\(escapedTerm)"
        
        if pageNumber > 0 {
            urlString += "&page=\(pageNumber)"
        }
        
        return URL(string:urlString)
    }
}
