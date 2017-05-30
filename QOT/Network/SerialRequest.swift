//
//  SerialRequest.swift
//  QOT
//
//  Created by Sam Wyndham on 30.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Alamofire

final class SerialRequest {
    var request: Request?

    func cancel() {
        request?.cancel()
    }
}
