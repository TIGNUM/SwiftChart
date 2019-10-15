//
//  TutorialWorker.swift
//  QOT
//
//  Created by karmic on 16.11.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TutorialWorker {

}

// MARK: - Public

extension TutorialWorker {

    var numberOfSlides: Int {
        return TutorialModel.Slide.allSlides.count
    }

    func title(at index: Index) -> String? {
        return contentItem(at: index, and: .title)?.valueText
    }

    func subtitle(at index: Index) -> String? {
        return contentItem(at: index, and: .subtitle)?.valueText
    }

    func body(at index: Index) -> String? {
        return contentItem(at: index, and: .body)?.valueText
    }

    func imageURL(at index: Index) -> URL? {
        guard let imageURLString = contentItem(at: index, and: .image)?.valueImageURL else { return nil }
        return URL(string: imageURLString)
    }

    func attributedbuttonTitle(at index: Index, for origin: TutorialOrigin) -> NSAttributedString {
        let title = index == TutorialModel.Slide.allSlides.count - 1 ? AppTextService.get(AppTextKey.tutorial_view_button_start) : AppTextService.get(AppTextKey.tutorial_view_button_skip)
        return NSAttributedString(string: origin == .login ? title : AppTextService.get(AppTextKey.tutorial_view_title_morning_done),
                                  letterSpacing: 0,
                                  font: .ApercuBold14,
                                  textColor: .azure,
                                  alignment: .center)
    }
}

// MARK: - Private

private extension TutorialWorker {

    func contentItem(at index: Index, and type: TutorialModel.ItemType) -> QDMContentItem? {
        // CHANGE ME
        return nil
    }
}
