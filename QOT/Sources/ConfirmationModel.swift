//
//  ConfirmationModel.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 09.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

enum ConfirmationType {
    case mindsetShifter
    case solve
}

enum ConfirmationButtonType {
    case yes
    case no
}

struct ConfirmationModel {
    let title: String
    let description: String
    let buttons: [ConfirmationButton]

    struct ConfirmationButton {
        let type: ConfirmationButtonType
        let title: String
    }
}
