//
//  ImagePickerController.swift
//  QOT
//
//  Created by Lee Arromba on 19/10/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol ImagePickerControllerDelegate: class {

    func imagePickerController(_ imagePickerController: ImagePickerController, selectedImage image: UIImage)

    func cancelSelection()
}

final class ImagePickerController {
    enum Option {
        case camera
        case photo
    }

    let imageQuality: ImageQuality
    let imageSize: ImageSize
    let permissionsManager: PermissionsManager
    let imagePicker: ImagePicker
    var imageCropper: ImageCropper?
    weak var viewController: UIViewController?
    weak var delegate: ImagePickerControllerDelegate?

    init(cropShape: ImageCropper.Shape,
         imageQuality: ImageQuality,
         imageSize: ImageSize,
         permissionsManager: PermissionsManager) {
        self.imageQuality = imageQuality
        self.imageSize = imageSize
        self.permissionsManager = permissionsManager
        imagePicker = ImagePicker()
        let imageCropper = ImageCropper(shape: cropShape)
        imagePicker.delegte = self
        imageCropper.delegate = self
        self.imageCropper = imageCropper
    }

    init(imageQuality: ImageQuality,
         imageSize: ImageSize,
         permissionsManager: PermissionsManager) {
        self.imageQuality = imageQuality
        self.imageSize = imageSize
        self.permissionsManager = permissionsManager
        imagePicker = ImagePicker()
        imagePicker.delegte = self
    }

    func show(in viewController: UIViewController, completion: (() -> Void)? = nil) {
        self.viewController = viewController
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let photoAction = UIAlertAction(title: R.string.localized.imagePickerOptionsButtonPhoto(),
                                        style: .default) { [unowned self] (alertAction: UIAlertAction) in
            self.handleOption(.photo)
        }

        let cameraAction = UIAlertAction(title: R.string.localized.imagePickerOptionsButtonCamera(),
                                         style: .default) { [unowned self] (alertAction: UIAlertAction) in
            self.handleOption(.camera)
        }

        let cancelAction = UIAlertAction(title: R.string.localized.alertButtonTitleCancel(),
                                         style: .cancel) { [unowned self] (alertAction: UIAlertAction) in
                                            self.delegate?.cancelSelection()
        }

        alertController.addAction(photoAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        self.viewController?.present(alertController, animated: true, completion: nil)
    }

    // MARK: - private

    private func handleOption(_ option: Option) {
        guard let viewController = viewController else {
            return
        }
        switch option {
        case .photo:
            do {
                try imagePicker.pickFromPhotos(in: viewController)
            } catch let error as ImagePicker.ImagePickerError {
                handleError(error, forOption: option)
            } catch {}
        case .camera:
            do {
                try imagePicker.pickFromCamera(in: viewController)
            } catch let error as ImagePicker.ImagePickerError {
                handleError(error, forOption: option)
            } catch {}
        }
    }

    private func handleError(_ error: ImagePicker.ImagePickerError, forOption option: Option) {
        switch error {
        case .sourceNotAvailable:
            viewController?.showAlert(type: .cameraNotAvailable) {
                self.finish()
            }
        case .notAuthorized:
            handleAuthorizationForOption(option)
        }
    }

    private func handleAuthorizationForOption(_ option: Option) {
        let identifier: PermissionsManager.Permission.Identifier
        switch option {
        case .camera:
            identifier = .camera
        case .photo:
            identifier = .photos
        }

        permissionsManager.askPermission(for: [identifier], completion: { [unowned self] status in
            guard let status = status[identifier] else { return }
            switch status {
            case .granted:
                self.handleOption(option)
            case .denied:
                let type: AlertType = (identifier == .camera) ? .cameraPermissionNotAuthorized : .photosPermissionNotAuthorized
                self.viewController?.showAlert(type: type, handler: {
                    UIApplication.openAppSettings()
                }, handlerDestructive: {
                    self.finish()
                    self.delegate?.cancelSelection()
                })
            case .later:
                self.permissionsManager.updateAskStatus(.canAsk, for: identifier)
                self.handleAuthorizationForOption(option)
            }
        })
    }

    private func finish() {
        viewController = nil
    }
}

// MARK: - ImageCropperDelegate

extension ImagePickerController: ImageCropperDelegate {

    func imageCropper(_ imageCropper: ImageCropper, croppedImage image: UIImage) {
        imageCropper.dismiss {
            self.finish()
            self.delegate?.cancelSelection()
        }
        delegate?.imagePickerController(self, selectedImage: image)
    }

    func imageCropperDidPressCancel(_ imageCropper: ImageCropper) {
        imageCropper.dismiss {
            self.finish()
            self.delegate?.cancelSelection()
        }
    }
}

// MARK: - ImagePickerDelegate

extension ImagePickerController: ImagePickerDelegate {

    func imagePicker(_ imagePicker: ImagePicker, didSelectImage image: UIImage) {
        imagePicker.dismiss {
            guard
                let viewController = self.viewController,
                let compressedImage = image.withQuality(self.imageQuality, size: self.imageSize) else {
                return
            }

            if let imageCropper = self.imageCropper {
                imageCropper.crop(compressedImage, in: viewController)
            } else {
                self.delegate?.imagePickerController(self, selectedImage: image)
            }
        }
    }

    func imagePickerDidPressCancel(_ imagePicker: ImagePicker) {
        imagePicker.dismiss {
            self.finish()
            self.delegate?.cancelSelection()
        }
    }
}
