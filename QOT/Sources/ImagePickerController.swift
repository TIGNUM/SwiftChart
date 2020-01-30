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
    let imagePicker: ImagePicker
    var imageCropper: ImageCropper?
    let adapter: ImagePickerControllerAdapter?
    let permissionsManager: PermissionsManager? = AppCoordinator.permissionsManager

    weak var viewController: UIViewController?
    weak var delegate: ImagePickerControllerDelegate?

    init(cropShape: ImageCropper.Shape,
         imageQuality: ImageQuality,
         imageSize: ImageSize,
         adapter: ImagePickerControllerAdapter?) {
        self.adapter = adapter
        self.imageQuality = imageQuality
        self.imageSize = imageSize
        imagePicker = ImagePicker()
        let imageCropper = ImageCropper(shape: cropShape)
        imagePicker.delegte = self
        imageCropper.delegate = self
        self.imageCropper = imageCropper
    }

    init(imageQuality: ImageQuality,
         imageSize: ImageSize,
         adapter: ImagePickerControllerAdapter?) {
        self.adapter = adapter
        self.imageQuality = imageQuality
        self.imageSize = imageSize
        imagePicker = ImagePicker()
        imagePicker.delegte = self
    }

    func show(in viewController: UIViewController?, deletable: Bool, completion: (() -> Void)? = nil) {
        UIVisualEffectView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).effect = UIBlurEffect(style: .dark)

        self.viewController = viewController
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let photoAction = UIAlertAction(title: AppTextService.get(.my_qot_my_tbv_alert_edit_photo_button_choose_picture),
                                        style: .default) { [weak self] (alertAction: UIAlertAction) in
                                            self?.handleOption(.photo)
                                            self?.resetAlertViewAppearance()
        }
        let cameraAction = UIAlertAction(title: AppTextService.get(.my_qot_my_tbv_alert_edit_photo_button_take_a_picture),
                                         style: .default) { [weak self] (alertAction: UIAlertAction) in
                                            self?.handleOption(.camera)
                                            self?.resetAlertViewAppearance()
        }
        let deleteAction = UIAlertAction(title: AppTextService.get(.my_qot_my_tbv_alert_edit_photo_button_delete_photo),
                                         style: .destructive) { [weak self] (alertAction: UIAlertAction) in
                                            self?.adapter?.deleteImageEvent()
                                            self?.delegate?.deleteImage()
                                            self?.resetAlertViewAppearance()
        }
        let cancelAction = UIAlertAction(title: AppTextService.get(.generic_view_button_cancel),
                                         style: .default) { [weak self] (alertAction: UIAlertAction) in
                                            self?.adapter?.cancelSelectionEvent()
                                            self?.delegate?.cancelSelection()
                                            self?.resetAlertViewAppearance()
        }

        alertController.addAction(photoAction)
        alertController.addAction(cameraAction)
        if deletable == true {
            alertController.addAction(deleteAction)
        }
        alertController.addAction(cancelAction)
        alertController.view.tintColor = .accent
        self.viewController?.present(alertController, animated: true)
    }

    // MARK: - private

    private func resetAlertViewAppearance() {
        UIVisualEffectView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).effect = UIBlurEffect(style: .extraLight)
    }

    private func handleOption(_ option: Option) {
        guard let viewController = viewController else {
            return
        }
        DispatchQueue.main.async {
            switch option {
            case .photo:
                do {
                    self.adapter?.didPickFromGalleryEvent()
                    try self.imagePicker.pickFromPhotos(in: viewController)
                } catch let error as ImagePicker.ImagePickerError {
                    self.handleError(error, forOption: option)
                } catch {}
            case .camera:
                do {
                    self.adapter?.didClickCameraEvent()
                    try self.imagePicker.pickFromCamera(in: viewController)
                } catch let error as ImagePicker.ImagePickerError {
                    self.handleError(error, forOption: option)
                } catch {}
            case .delete :
                break
            }
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

        permissionsManager?.askPermission(for: identifier, completion: { [unowned self] status in
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
            case .restricted:
                self.permissionsManager?.updateAskStatus(.canAsk, for: identifier)
                self.handleAuthorizationForOption(option)
            default:
                break
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
