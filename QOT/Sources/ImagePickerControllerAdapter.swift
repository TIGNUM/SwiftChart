//
//  ImagePickerControllerAdapter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 21.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol ImagePickerControllerAdapterProtocol: class {
    func deleteImageEvent()
    func cancelSelectionEvent()
    func didPickFromGalleryEvent()
    func didClickCameraEvent()
}

extension ImagePickerControllerAdapterProtocol {

    private func trackUserEvent(_ name: QDMUserEventTracking.Name,
                                value: Int? = nil,
                                valueType: QDMUserEventTracking.ValueType? = nil,
                                action: QDMUserEventTracking.Action) {
        var userEventTrack = QDMUserEventTracking()
        userEventTrack.name = name
        userEventTrack.value = value
        userEventTrack.valueType = valueType
        userEventTrack.action = action
        NotificationCenter.default.post(name: .reportUserEvent, object: userEventTrack)
    }

    func deleteImageEvent() {
        trackUserEvent(.REMOVE, valueType: "Image", action: .TAP)
    }

    func cancelSelectionEvent() {
        trackUserEvent(.CLOSE, valueType: "CameraOptions", action: .TAP)
    }

    func didPickFromGalleryEvent() {
        trackUserEvent(.OPEN, valueType: "ImageGallery", action: .TAP)
    }

    func didClickCameraEvent() {
        trackUserEvent(.OPEN, valueType: "Camera", action: .TAP)
    }
}

final class ImagePickerControllerAdapter {
    weak var delegate: ImagePickerControllerAdapterProtocol?

    init(_ delegate: ImagePickerControllerAdapterProtocol?) {
        self.delegate = delegate
    }

    func deleteImageEvent() {
        delegate?.deleteImageEvent()
    }

    func cancelSelectionEvent() {
        delegate?.cancelSelectionEvent()
    }

    func didPickFromGalleryEvent() {
        delegate?.didPickFromGalleryEvent()
    }

    func didClickCameraEvent() {
        delegate?.didClickCameraEvent()
    }
}
