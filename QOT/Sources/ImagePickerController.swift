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
}

final class ImagePickerController {
    enum Option {
        case camera
        case photo
    }

    let imageQuality: ImageQuality
    let imageSize: ImageSize
    let permissionHandler: PermissionHandler
    let imagePicker: ImagePicker
    let imageCropper: ImageCropper
    weak var viewController: UIViewController?
    weak var delegate: ImagePickerControllerDelegate?
    
    init(cropShape: ImageCropper.Shape, imageQuality: ImageQuality, imageSize: ImageSize, permissionHandler: PermissionHandler) {
        self.imageQuality = imageQuality
        self.imageSize = imageSize
        self.permissionHandler = permissionHandler
        
        imagePicker = ImagePicker()
        imageCropper = ImageCropper(shape: cropShape)
        imagePicker.delegte = self
        imageCropper.delegate = self
    }
    
    func show(in viewController: UIViewController, completion: (() -> Void)? = nil) {
        self.viewController = viewController
        self.viewController?.showAlert(type: .imagePicker, handler: {
            self.handleOption(.photo)
        }, handlerDestructive: {
            self.handleOption(.camera)
        })
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
        switch option {
        case .camera:
            permissionHandler.askPermissionForCamera(completion: { (granted: Bool) in
                guard granted else {
                    self.viewController?.showAlert(type: .permissionNotGranted) {
                        self.finish()
                    }
                    return
                }
                self.handleOption(option)
            })
        case .photo:
            permissionHandler.askPermissionForPhotos(completion: { (granted: Bool) in
                guard granted else {
                    self.viewController?.showAlert(type: .permissionNotGranted) {
                        self.finish()
                    }
                    return
                }
                self.handleOption(option)
            })
        }
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
        }
        delegate?.imagePickerController(self, selectedImage: image)
    }
    
    func imageCropperDidPressCancel(_ imageCropper: ImageCropper) {
        imageCropper.dismiss {
            self.finish()
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
            self.imageCropper.crop(compressedImage, in: viewController)
        }
    }

    func imagePickerDidPressCancel(_ imagePicker: ImagePicker) {
        imagePicker.dismiss {
            self.finish()
        }
    }
}
