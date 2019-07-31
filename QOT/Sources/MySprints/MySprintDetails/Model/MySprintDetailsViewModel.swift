//
//  MySprintDetailsViewModel.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

struct MySprintDetailsViewModel {
    var title: String?
    var description: String?
    var progress: String?
    var items = [MySprintDetailsItem]()

    var infoViewModel: MySprintsInfoAlertViewModel?
    var showDismissButton: Bool = true
    var rightButtons: [SprintButtonParameters]?
}
