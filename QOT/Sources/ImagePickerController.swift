//
//  ImagePickerController.swift
//  QOT
//
//  Created by Lee Arromba on 19/10/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import qot_dal

protocol ImagePickerControllerDelegate: class {
    func imagePickerController(_ imagePickerController: ImagePickerController, selectedImage image: UIImage)
    func deleteImage()
    func cancelSelection()
}

extension ImagePickerControllerDelegate {
    func deleteImage() {
        // empty implementaion - it works as optional
    }
}

final class ImagePickerController {
    enum Option {
        case camera
        case photo
        case delete
    }

    let imageQuality: ImageQuality
    let imageSize: ImageSize
    let permissionsManager: PermissionsManager
    let imagePicker: ImagePicker
    var imageCropper: ImageCropper?
    let adapter: ImagePickerControllerAdapter?

    weak var viewController: UIViewController?
    weak var delegate: ImagePickerControllerDelegate?

    init(cropShape: ImageCropper.Shape,
         imageQuality: ImageQuality,
         imageSize: ImageSize,
         permissionsManager: PermissionsManager,
         adapter: ImagePickerControllerAdapter?) {
        self.adapter = adapter
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
         permissionsManager: PermissionsManager,
         adapter: ImagePickerControllerAdapter?) {
        self.adapter = adapter
        self.imageQuality = imageQuality
        self.imageSize = imageSize
        self.permissionsManager = permissionsManager
        imagePicker = ImagePicker()
        imagePicker.delegte = self
    }

    func show(in viewController: UIViewController?, deletable: Bool, completion: (() -> Void)? = nil) {
        self.viewController = viewController
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let photoAction = UIAlertAction(title: "",
                                        style: .default) { [unowned self] (alertAction: UIAlertAction) in
            self.handleOption(.photo)
        }

        let cameraAction = UIAlertAction(title: "",
                                         style: .default) { [unowned self] (alertAction: UIAlertAction) in
            self.handleOption(.camera)
        }

        let cancelAction = UIAlertAction(title: "",
                                         style: .cancel) { [unowned self] (alertAction: UIAlertAction) in
                                            self.adapter?.cancelSelectionEvent()
                                            self.delegate?.cancelSelection()
        }
         let cameraActionContentVC = CustomAlertSheetContentViewController.init(title: R.string.localized.imagePickerOptionsButtonCamera(),
                                                                                 isDestructive: false)
         let photoActionContentVC = CustomAlertSheetContentViewController.init(title: R.string.localized.imagePickerOptionsButtonPhoto(),
                                                                               isDestructive: false)
         let cancelActionContentVC = CustomAlertSheetContentViewController.init(title: ScreenTitleService.main.localizedString(for: .ButtonTitleCancel),
                                                                                isDestructive: false)

        cameraAction.setValue(cameraActionContentVC, forKey: "contentViewController")
        photoAction.setValue(photoActionContentVC, forKey: "contentViewController")
        cancelAction.setValue(cancelActionContentVC, forKey: "contentViewController")

        alertController.addAction(photoAction)
        alertController.addAction(cameraAction)
        if deletable == true {
            let deleteAction = UIAlertAction(title: "",
                                             style: .destructive) { [unowned self] (alertAction: UIAlertAction) in
                                                self.adapter?.deleteImageEvent()
                                                self.delegate?.deleteImage()
            }

            let deleteActionContentVC = CustomAlertSheetContentViewController.init(title: R.string.localized.imagePickerOptionsButtonDelete(),
                                                                                   isDestructive: true)
            deleteAction.setValue(deleteActionContentVC, forKey: "contentViewController")

            alertController.addAction(deleteAction)
        }
        alertController.addAction(cancelAction)
        alertController.view?.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .black

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
                adapter?.didPickFromGalleryEvent()
                try imagePicker.pickFromPhotos(in: viewController)
            } catch let error as ImagePicker.ImagePickerError {
                handleError(error, forOption: option)
            } catch {}
        case .camera:
            do {
                adapter?.didClickCameraEvent()
                try imagePicker.pickFromCamera(in: viewController)
            } catch let error as ImagePicker.ImagePickerError {
                handleError(error, forOption: option)
            } catch {}
        case .delete :
            break
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
        case .delete:
            self.handleOption(option)
            return
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
                    self.adapter?.cancelSelectionEvent()
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
            self.adapter?.cancelSelectionEvent()
            self.delegate?.cancelSelection()
        }
        self.adapter?.didPickFromGalleryEvent()
        delegate?.imagePickerController(self, selectedImage: image)
    }

    func imageCropperDidPressCancel(_ imageCropper: ImageCropper) {
        imageCropper.dismiss {
            self.finish()
            self.adapter?.cancelSelectionEvent()
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
                self.adapter?.didPickFromGalleryEvent()
                self.delegate?.imagePickerController(self, selectedImage: image)
            }
        }
    }

    func imagePickerDidPressCancel(_ imagePicker: ImagePicker) {
        imagePicker.dismiss {
            self.finish()
            self.adapter?.cancelSelectionEvent()
            self.delegate?.cancelSelection()
        }
    }
}
