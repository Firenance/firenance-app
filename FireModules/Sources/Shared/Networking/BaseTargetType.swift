//
//  BaseTargetType.swift
//
//
//  Created by Hien Tran on 23/11/2023.
//

import Foundation
import Moya

protocol BaseTargetType: TargetType {}

extension BaseTargetType {
    var baseURL: URL {
        // TODO: Use environment flag to set up different schemes
        // TODO: Move base url to env variable
        guard let url = URL(string: "http://localhost:80/api") else {
            preconditionFailure("Missing base URL in \(String(describing: self))")
        }
        return url
    }

    var headers: [String: String]? {
        return nil
    }
}
