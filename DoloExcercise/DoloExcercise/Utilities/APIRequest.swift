//
//  APIRequest.swift
//  DoloExcercise
//
//  Created by Alex Hoff on 3/20/18.
//  Copyright © 2018 Alex Hoff. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkRequest: class {
    associatedtype Model
    func load(withCompletion completion: @escaping (Model?) -> Void)
    func decode(_ data: Data) -> Model?
}

extension NetworkRequest {
    fileprivate func load(_ url: URL, withCompletion completion: @escaping (Model?) -> Void) {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let task = session.dataTask(with: url, completionHandler: { [weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let error = error {
                print("Server error:", error)
                return
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                completion(self?.decode(data))
            }
        })
        task.resume()
    }
}

class ImageRequest {
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
}

extension ImageRequest: NetworkRequest {
    func decode(_ data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    
    func load(withCompletion completion: @escaping (Model?) -> Void){
        load(url, withCompletion: completion)
    }
}

class ApiRequest {
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
}

extension ApiRequest: NetworkRequest {
    func decode(_ data: Data) -> Session? {
        do {
            let session = try JSONDecoder().decode(Session.self, from: data)
            return session
        } catch {
            print("ERROR: ", error)
            return nil
        }
    }
    
    func load(withCompletion completion: @escaping (Model?) -> Void) {
        load(url, withCompletion: completion)
    }
}
