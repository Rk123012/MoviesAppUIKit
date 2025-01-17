//
//  HttpClient.swift
//  MoviesAppUIKit
//
//  Created by Rezaul Karim on 17/1/25.
//

import Foundation
import Combine

enum NetworkError: Error {
    case badUrl
}


class HttpClient {
    
    
    func fetchMovies(search : String) -> AnyPublisher<[Movie], Error> {
        
        guard let encodedSearch = search.urlEncoded , let url = URL(string: "https://www.omdbapi.com/?s=\(encodedSearch)&page=2&apikey=e59c2b7a") else {
            return Fail(error: NetworkError.badUrl).eraseToAnyPublisher( )
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map(\.Search)
            .receive(on: DispatchQueue.main)
            .catch{
                error -> AnyPublisher<[Movie], Error> in
                return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
}
