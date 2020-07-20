//
//  NetworkWeather.swift
//  WeatherSwiftUI
//
//  Created by Gary on 2/17/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import Foundation
import Combine


enum NetworkError: Error, LocalizedError {
    case invalidHTTPResponse, invalidServerResponse, jsonParsingError, apiError(reason: String)

    var errorDescription: String? {
        switch self {
        case .invalidHTTPResponse:
            return "Invalid HTTP response"
        case .invalidServerResponse:
            return "Invalid service sesponse"
        case .jsonParsingError:
            return "Error parsing JSON"
        case .apiError(let reason):
            return reason
        }
    }
}


enum DataFetcher {

    static func fetch<T: Decodable>(url: URL?, myType: T.Type) -> AnyPublisher<T, NetworkError> {
        guard let url = url else {
            fatalError("Did you enter your AccuWeather API Key?")
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> T in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.invalidHTTPResponse
                }
                //print(String(bytes: data, encoding: String.Encoding.utf8))
                let value = try JSONDecoder().decode(T.self, from: data)
                return value
        }
        .mapError { error in
            if let _ = error as? DecodingError {
                return NetworkError.jsonParsingError
            } else if let error = error as? NetworkError {
                return error
            }

            // handle service errors (e.g. not being able to connect)
            return NetworkError.invalidServerResponse
        }
        .eraseToAnyPublisher()
    }

}
