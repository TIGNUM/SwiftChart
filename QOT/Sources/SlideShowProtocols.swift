//
//  SlideShowProtocols.swift
//  QOT
//
//  Created by Sam Wyndham on 14.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

protocol SlideShowViewControllerInterface: class {
    func setPages(_ pages: [SlideShow.Page])
    func updatePages(_ pages: [SlideShow.Page])
}

protocol SlideShowPresenterInterface {
    func loadBasicSlides(slides: [SlideShow.Slide])
    func loadAllSlides(slides: [SlideShow.Slide])
}

protocol SlideShowInteractorInterface: Interactor {
    func didTapLoadMore()
    func didTapDone()
}

protocol SlideShowRouterInterface {
    func dismissSlideShow()
}
