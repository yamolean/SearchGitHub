//
//  GitHubRequest.swift
//  GitHubList
//
//  Created by 矢守叡 on 2020/03/01.
//  Copyright © 2020 yamolean. All rights reserved.
//

import Foundation
import APIKit

protocol GitHubRequest: Request {}

extension GitHubRequest {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
}

extension GitHubRequest {
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        switch urlResponse.statusCode {
        case 200 ..< 300:
            return object
        default:
            throw NSError(domain: "Bad Status Response", code: urlResponse.statusCode, userInfo: nil)
        }
    }
}

extension GitHubRequest where Response: Decodable {
    var dataParser: DataParser {
        return DecodableDataParser()
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        return try JSONDecoder().decode(Response.self, from: data)
    }
}

struct DecodableDataParser: DataParser {
    let contentType: String? = "application/json"
    
    func parse(data: Data) throws -> Any {
        return data
    }
}
