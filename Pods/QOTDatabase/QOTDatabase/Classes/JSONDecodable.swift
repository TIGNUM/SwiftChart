//
//  URL+JSONDecodable.swift
//  Pods
//
//  Created by Sam Wyndham on 05/05/2017.
//
//

import Foundation
import Freddy

extension URL: JSONDecodable {

    public init(json: JSON) throws {
        guard case let JSON.string(string) = json, let url = URL(string: string) else {
            throw JSON.Error.valueNotConvertible(value: json, to: URL.self)
        }
        self = url
    }
}
