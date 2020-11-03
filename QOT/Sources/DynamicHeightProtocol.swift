//
//  DynamicHeightProtocol.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 03/11/2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

protocol DynamicHeightProtocol {
    func height(forWidth: CGFloat) -> CGFloat
}

func calculateHeighest<T: DynamicHeightProtocol>(with viewModels: [T], forWidth width: CGFloat) -> T? {
    var largestViewModel = viewModels.first
    var largestHeight: CGFloat = 0

    for viewModel in viewModels {
        let height = viewModel.height(forWidth: width)

        if height > largestHeight {
            largestHeight =  height
            largestViewModel = viewModel
        }
    }

    return largestViewModel
}
