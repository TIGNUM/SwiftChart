//
//  TrackSelectionInterface.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 15/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

/// Enum which defines appearance of `TrackSelectionViewController`
enum TrackSelectionType {
    /// Controller is presented from 'Login' screen and will have top dash and title offset
    case login
    /// Controller is presented from 'Registration' screens and will not have top dash and title will be aligned
    /// to view's top
    case registration
}

protocol TrackSelectionViewControllerInterface: class {
    func setupView()
}

protocol TrackSelectionPresenterInterface {
    func setupView()
}

protocol TrackSelectionInteractorInterface: Interactor {
    var type: TrackSelectionType { get }
    var title: String { get }
    var descriptionText: String { get }
    var fastTrackButton: String { get }
    var guidedTrackButton: String { get }

    func didTapFastTrack()
    func didTapGuidedTrack()
}

protocol TrackSelectionRouterInterface {
    func showFastTrask()
    func showGuidedTrack()
}
