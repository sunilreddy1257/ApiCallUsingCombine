//
//  NetworkManager.swift
//  ApiCallUsingCombine
//
//  Created by Sunil Kumar Reddy Sanepalli on 21/05/23.
//

import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    private init() {
        
    }
    private var cancellables = Set<AnyCancellable>()

    func apiCallUsingCombine<T: Decodable>(type: T.Type) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else { return promise(.failure(NetworkError.invalidURL)) }
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...209 ~= httpResponse.statusCode  else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .sink { completion in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        default:
                            promise(.failure(NetworkError.decodingError))
                        }
                    }
                } receiveValue: { decodeData in
                    promise(.success(decodeData))
                }
                .store(in: &self!.cancellables)
        }
    }
    
}
