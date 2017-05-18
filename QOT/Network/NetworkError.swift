//
//  NetworkError.swift
//  QOT
//
//  Created by Sam Wyndham on 17.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    
    case failedToParseData(Data, error: Error)
    case unknown(Error)
}
