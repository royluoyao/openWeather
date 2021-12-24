//
//  WeatherNetwork.swift
//  openWeather
//
//  Created by user on 2021/12/24.
//

import Foundation
import CoreLocation
import Combine
let baseURL = "http://api.openweathermap.org/data/2.5/onecall?"
let openWeatherKey = "03b3d7da4d7589649645ce3bc78bd8cd"
let weatherDataKey = "weatherDataKey"
enum Path {
    case onecallWeather(lat: Float, lon: Float)
    case icon(name: String)
    func endpoint() -> String {
        switch self {
        case let .onecallWeather(lat ,lon):
            return "\(baseURL)lat=\(lat)&lon=\(lon)&exclude=hourly,minutely,alerts&appid=\(openWeatherKey)"
        case let .icon(name):
            return "http://openweathermap.org/img/wn/\(name)@2x.png"
        }
    }
    
    func url() -> URL? {
            return URL(string: self.endpoint())
        }
}

protocol WeatherProtocal {
    func fetchData<T: Decodable>(url: URL?, type: T.Type) -> Future<T, Error>
}

public class WeatherNetwork {
    static let shared = WeatherNetwork()
    private var cancellables = Set<AnyCancellable>()

    func fetchData<T: Decodable>(url: URL?, type: T.Type) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self = self, let url = url else {
                return promise(.failure(NetworkError.invalidURL))
            }
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                }, receiveValue: {
                    promise(.success($0))
                })
                .store(in: &self.cancellables)
        }
    }
    
}

enum NetworkError: Error {
    case invalidURL
    case responseError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}
