//
//  SigningInfoWorker.swift
//  QOT
//
//  Created by karmic on 28.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningInfoWorker {

    // MARK: - Properties

    private let model: SigningInfoModel

    // MARK: - Init

    init(model: SigningInfoModel) {
        self.model = model
    }
}

// MARK: - Public

extension SigningInfoWorker {

    var numberOfSlides: Int {
        return SigningInfoModel.Slide.allSlides.count
    }

    func title(at item: Int) -> String {
        return SigningInfoModel.Slide.allSlides[item].title
    }

    func body(at item: Int) -> String {
        return SigningInfoModel.Slide.allSlides[item].body
    }
}
