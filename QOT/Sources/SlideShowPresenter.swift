//
//  SlideShowPresenter.swift
//  QOT
//
//  Created by Sam Wyndham on 07.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class SlideShowPresenter {

    private weak var viewController: SlideShowViewControllerInterface?

    init(viewController: SlideShowViewControllerInterface) {
        self.viewController = viewController
    }
}

extension SlideShowPresenter: SlideShowPresenterInterface {

    func loadBasicSlides(slides: [SlideShow.Slide]) {
        var pages = slides.map { SlideShow.Page(slide: $0) }
        pages.append(.morePrompt)
        viewController?.setPages(pages)
    }

    func loadAllSlides(slides: [SlideShow.Slide]) {
        var pages = slides.map { SlideShow.Page(slide: $0) }
        pages.append(.completePrompt)
        viewController?.updatePages(pages)
    }
}

private extension SlideShow.Page {

    init(slide: SlideShow.Slide) {
        if let subtitle = slide.subtitle {
            self = .titleSubtitleSlide(title: slide.title, subtitle: subtitle, imageName: slide.imageName)
        } else {
            self = .titleSlide(title: slide.title, imageName: slide.imageName)
        }
    }
}
