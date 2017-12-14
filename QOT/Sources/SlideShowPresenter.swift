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
        pages.append(.prompt(title: "Do you want to view more", showMoreButton: true))
        viewController?.setPages(pages)
    }

    func loadAllSlides(slides: [SlideShow.Slide]) {
        var pages = slides.map { SlideShow.Page(slide: $0) }
        pages.append(.prompt(title: "Do you want to view more", showMoreButton: false))
        viewController?.updatePages(pages)
    }
}

private extension SlideShow.Page {

    init(slide: SlideShow.Slide) {
        self = .slide(title: slide.title, subtitle: slide.subtitle, imageName: slide.imageName)
    }
}
