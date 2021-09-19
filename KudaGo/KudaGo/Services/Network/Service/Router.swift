//
//  Router.swift
//  KudaGo
//
//  Created by Виктория Козырева on 27.07.2021.
//

import Foundation

class Router<EndPoint: EndPointType>: NetworkRouter {
    private var task: URLSessionTask?

    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { data, responce, error in
                completion(data, responce, error)
            })
        } catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }

    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseUrl.appendingPathComponent(NetworkManager.version + route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        request.httpMethod = route.HTTPMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParams(let bodyParams, let urlParams):
                try self.configureParameters(bodyParams: bodyParams, urlParams: urlParams, request: &request)
            }
            return request
        } catch {
            throw error
        }
    }

    fileprivate func configureParameters(bodyParams: Parameters?,
                                         urlParams: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            if let bodyParams = bodyParams {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParams)
            }
            if let urlParams = urlParams {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParams)
            }
        } catch {
            throw error
        }
    }

    func cancel() {
        self.task?.cancel()
    }
}
