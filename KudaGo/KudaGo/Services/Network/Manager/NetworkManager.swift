//
//  NetworkManager.swift
//  KudaGo
//
//  Created by Виктория Козырева on 27.07.2021.
//

import Foundation

enum NetworkResponse: String {
    case success
    case clientError = "Client error: Data not found"
    case serverError = "Server error"
    case outdated = "URL is outdated"
    case failed = "Network request failed"
    case noData = "Responce returned with no data to decode"
    case unableToDecode = "Can't decode this responce. Check model."
}

enum Result<String> {
    case success
    case failure(String)
}

struct NetworkManager {
    static let version = "v1.4"
    static let shared = NetworkManager()
    private let router = Router<KudaGoAPI>()
    let queue = DispatchQueue.global(qos: .background)

    fileprivate func handleNetworkResponse(_ responce: HTTPURLResponse) -> Result<String> {
        switch responce.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.clientError.rawValue)
        case 501...599: return .failure(NetworkResponse.serverError.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
    // TODO: добавить дженерик на completion блок для задач
    func getLocations(completion: @escaping ([OnboardingApiResponse]?, _ error: String?) -> Void) {
        router.request(.locations, completion: { data, response, error in
            if error != nil {
                completion(nil, "Check your network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode([OnboardingApiResponse].self, from: responseData)
                        completion(apiResponse, nil)
                    } catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        })
    }

    func getEventCategories(completion: @escaping ([OnboardingApiResponse]?, _ error: String?) -> Void) {
        router.request(.eventCategories, completion: { data, response, error in
            if error != nil {
                completion(nil, "Check your network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode([OnboardingApiResponse].self, from: responseData)
                        completion(apiResponse, nil)
                    } catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        })
    }

    func getEvents(page: Int, pageSize: Int, completion: @escaping ([EventShortDescription]?, _ error: String?) -> Void) {
        router.request(.eventList(page: page, pageSize: pageSize), completion: { data, response, error in
            if error != nil {
                completion(nil, "Check your network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(EventsApiResponse.self, from: responseData)
                        completion(apiResponse.results, nil)
                    } catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        })
    }

    func getEvent(eventId: Int, completion: @escaping (EventFullDescription?, _ error: String?) -> Void) {
        router.request(.event(eventId: eventId), completion: { data, response, error in
            if error != nil {
                completion(nil, "Check your network connection")
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(EventFullDescription.self, from: responseData)
                        completion(apiResponse, nil)
                    } catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        })
    }

    func getImage(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        queue.async {
            URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
        }
    }

}
