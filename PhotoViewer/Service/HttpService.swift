//
//  HttpService.swift
//  PhotoViewer
//
//  Created by Dmitry  Nidzelsky  on 4/1/20.
//  Copyright © 2020 Dmitry  Nidzelsky . All rights reserved.
//

import Foundation

class HttpService {
    
    enum Error: Swift.Error {
        case unknownAPIResponse
        case serverError
        case mimeType
    }
    
    //create request with URL, add headers
    func httpGetRequest(by url: URL, headers: [String: String],
                        completion: @escaping (Result<Data>) -> Void) {
        
        // search request
        var urlRequest = URLRequest(url: url)
         
        // add header fields
        for headerField in headers.keys {
            if let value = headers[headerField] {
                print("add value = \(value) to headerField \(headerField)")
                urlRequest.addValue(value, forHTTPHeaderField: headerField)
            }
        }

        // create data task
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil || data == nil {
                completion(Result.error(Error.unknownAPIResponse))
                print("error: \(error?.localizedDescription ?? "no description")")
                return
            }

            // check statusCode of response
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    completion(Result.error(Error.serverError))
                    return
            }

            // check mime type
            guard let mime = response.mimeType,
                mime == "application/json" else {
                    completion(Result.error(Error.mimeType))
                    return
            }

            // return response data
            if let responseData = data {
                completion(Result.results(responseData))
            } else {
                completion(Result.error(Error.serverError))
                return
            }
        }
        
        task.resume()
    }
}

