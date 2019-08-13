//
//  ConfirmationModel.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 09.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

struct Confirmation {
    let title: String
    let description: String

    enum Kind {
        case mindsetShifter
        case recovery
        case solve
    }
}
