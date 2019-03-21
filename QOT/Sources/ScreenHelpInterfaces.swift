//
//  HelpInterfaces.swift
//  QOT
//
//  Created by Lee Arromba on 14/12/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

protocol ScreenHelpRouterInterface {
    func dismiss()
    func showVideo(with url: URL?, contentItem: ContentItem?)
}

protocol ScreenHelpPresenterInterface {
    func load(_ helpItem: ScreenHelp.Item?)
    func shouldShowPlayButton(hasVideo: Bool)
}

protocol ScreenHelpInteractorInterface: Interactor {
    func didTapMinimiseButton()
    func didTapVideo(with url: URL?)
}

protocol ScreenHelpViewControllerInterface: class {
    var interactor: ScreenHelpInteractorInterface! { get set }
    func updateHelpItem(_ helpItem: ScreenHelp.Item?)
    func streamVideo(videoURL: URL?, contentItem: ContentItem?)
    func shouldShowPlayButton(hasVideo: Bool)
}
