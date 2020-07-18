//
//  Network.swift
//  DecadeOfMovies
//
//  Created by Yousef Hamza on 7/18/20.
//  Copyright © 2020 yousefahmza. All rights reserved.
//

import Foundation

class Network {
    static var shared = Network()

    /// Execute network request and process input and error, and in case of success
    /// decode the response data
    /// - Parameters:
    ///   - endPoint: End point to execute
    ///   - successCallback: Success callback with the decoded object from response
    ///   - errorCallback: Error callback with the what wrong happened in the request
    func executeRequest<T: Codable>(at urlRequest: URLRequestCreator,
                           successCallback: @escaping (T)->Void,
                           errorCallback: @escaping (NetworkError)->Void) {
        URLSession.shared.dataTask(with: urlRequest.urlRequest) { (data, response, error) in
            if let _ = error {
                DispatchQueue.main.async {
                    errorCallback(.clientError)
                }
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                DispatchQueue.main.async {
                    errorCallback(.serverError)
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    errorCallback(.noServerResponse)
                }
                return
            }
            guard let object = try? JSONDecoder().decode(T.self, from: data) else {
                DispatchQueue.main.async {
                    errorCallback(.couldNotDecodeResponse)
                }
                return
            }
            DispatchQueue.main.async {
                DispatchQueue.main.async {
                    successCallback(object)
                }
            }
        }.resume()
    }
}

class AnyResponse: Codable {} // Use this to not try to encode JSON
