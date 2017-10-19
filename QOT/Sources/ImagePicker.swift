//
//  ImagePicker.swift
//  QOT
//
//  Created by Lee Arromba on 18/10/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

protocol ImagePickerDelegate: class {
    func imagePicker(_ imagePicker: ImagePicker, didSelectImage image: UIImage)
    func imagePickerDidPressCancel(_ imagePicker: ImagePicker)
}

class ImagePicker: NSObject {
    enum ImagePickerError: Error {
        case sourceNotAvailable
        case notAuthorized
    }
    
    weak var delegte: ImagePickerDelegate?
    weak var viewController: UIViewController?
    var imagePickerController: UIImagePickerController?
    
    func pickFromPhotos(in viewController: UIViewController, completion: (() -> Void)? = nil) throws {
        guard PHPhotoLibrary.authorizationStatus() == .authorized else {
            throw ImagePickerError.notAuthorized
        }
        try show(in: viewController, for: .photoLibrary, completion: completion)
    }
    
    func pickFromCamera(in viewController: UIViewController, completion: (() -> Void)? = nil) throws {
        guard AVCaptureDevice.authorizationStatus(for: .video) == .authorized else {
            throw ImagePickerError.notAuthorized
        }
        try show(in: viewController, for: .camera, completion: completion)
    }
    
    func dismiss(completion: (() -> Void)? = nil) {
        imagePickerController?.dismiss(animated: true, completion: {
            completion?()
            self.finish()
        })
    }
    
    // MARK: - private
    
    private func show(in viewController: UIViewController, for type: UIImagePickerControllerSourceType, completion: (() -> Void)?) throws {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            throw ImagePickerError.sourceNotAvailable
        }
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = type
        imagePickerController.navigationBar.isTranslucent = false
        imagePickerController.navigationBar.barTintColor = .black
        imagePickerController.navigationBar.tintColor = .white
        imagePickerController.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        viewController.present(imagePickerController, animated: true, completion: completion)
        self.viewController = viewController
        self.imagePickerController = imagePickerController
    }
    
    private func finish() {
        imagePickerController = nil
        viewController = nil
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ImagePicker: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegte?.imagePickerDidPressCancel(self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        delegte?.imagePicker(self, didSelectImage: image)
    }
}

// MARK: - UINavigationControllerDelegate

extension ImagePicker: UINavigationControllerDelegate {
}
