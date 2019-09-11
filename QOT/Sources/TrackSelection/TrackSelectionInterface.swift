//
//  TrackSelectionInterface.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 15/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

/// Enum which defines appearance of `TrackSelectionViewController`
enum TrackSelectionControllerType {
    /// Controller is presented from 'Login' screen and will have top dash and title offset
    case login
    /// Controller is presented from 'Registration' screens and will not have top dash and title will be aligned
    /// to view's top
    case registration
}

enum SelectedTrackType {
    case fast
    case guided
}

protocol TrackSelectionViewControllerInterface: class {
    func setupView()
}

protocol TrackSelectionPresenterInterface {
    func setupView()
}

protocol TrackSelectionInteractorInterface: Interactor {
    var type: TrackSelectionControllerType { get }
    var title: String { get }
    var descriptionText: String { get }
    var fastTrackButton: String { get }
    var guidedTrackButton: String { get }

    func askNotificationPermissions()
    func didTapFastTrack()
    func didTapGuidedTrack()
}

protocol TrackSelectionRouterInterface {
    func openWalktrough(with trackType: SelectedTrackType)
    func showNotificationPersmission(type: AskPermission.Kind, completion: (() -> Void)?)
}
