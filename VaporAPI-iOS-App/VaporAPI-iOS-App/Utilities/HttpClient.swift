//
//  HttpClient.swift
//  
//  Created by Manajit Halder on 01/08/23 using Swift 5.0 on MacOS 13.4
//  

import Foundation

enum HttpError: Error {
    case badURL
    case badResponse
    case errorDecodingData
    case invalidURL
}

enum HttpMethods: String {
    case GET
    case POST
    case PUT
    case DELETE
}

enum MIMEType: String {
    case JSON = "application/json"
}

enum HttpHeaders: String {
    case contentType = "Content-Type"
}

class HttpClient {
    private init() {}
    static let shared = HttpClient()
    
    func fetch<T: Codable>(url: URL) async throws -> [T] {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }
        
        guard let object = try? JSONDecoder().decode([T].self, from: data) else {
            throw HttpError.errorDecodingData
        }
        
        return object
    }
    
    func sendData<T: Codable>(to url: URL, object: T, httpMethod: String) async throws {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue(MIMEType.JSON.rawValue, forHTTPHeaderField: HttpHeaders.contentType.rawValue)
        request.httpBody = try?JSONEncoder().encode(object)
        
        let (_, response) = try await URLSession.shared.data(for: request)
       
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw HttpError.badResponse
        }
    }
}
