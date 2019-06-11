//
//  ImageCropper.swift
//  QOT
//
//  Created by Lee Arromba on 19/10/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RSKImageCropper

protocol ImageCropperDelegate: class {
    func imageCropper(_ imageCropper: ImageCropper, croppedImage image: UIImage)
    func imageCropperDidPressCancel(_ imageCropper: ImageCropper)
}

class ImageCropper: NSObject {
    enum Shape {
        case circle
        case hexagon
        case rectangle
        case square

        var size: CGFloat {
            return 250.0
        }
    }

    weak var delegate: ImageCropperDelegate?
    weak var viewController: UIViewController?
    var imageCropper: RSKImageCropViewController?
    var shape: Shape

    init(shape: Shape) {
        self.shape = shape
    }

    func crop(_ image: UIImage, in viewController: UIViewController) {
        self.viewController = viewController

        let imageCropper = RSKImageCropViewController(image: image)
        imageCropper.delegate = self
        imageCropper.dataSource = self
        imageCropper.cropMode = .custom
        viewController.present(imageCropper, animated: true, completion: nil)
        self.imageCropper = imageCropper
    }

    func dismiss(completion: (() -> Void)? = nil) {
        imageCropper?.dismiss(animated: true, completion: {
            completion?()
            self.finish()
        })
    }

    // MARK: - private

    private func finish() {
        viewController = nil
    }
}

// MARK: - RSKImageCropViewControllerDelegate

extension ImageCropper: RSKImageCropViewControllerDelegate {

    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        delegate?.imageCropperDidPressCancel(self)
    }

    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        delegate?.imageCropper(self, croppedImage: croppedImage)
    }
}

// MARK: - RSKImageCropViewControllerDataSource

extension ImageCropper: RSKImageCropViewControllerDataSource {

    func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
         guard let view = viewController?.view else {
            return .zero
        }
        return CGRect(
            x: (view.frame.width - shape.size) * 0.5,
            y: (view.frame.height - shape.size) * 0.5,
            width: shape.size,
            height: shape.size
        )
    }

    func imageCropViewControllerCustomMovementRect(_ controller: RSKImageCropViewController) -> CGRect {
        return controller.maskRect
    }

    func imageCropViewControllerCustomMaskPath(_ controller: RSKImageCropViewController) -> UIBezierPath {
        guard let view = viewController?.view else {
            return UIBezierPath()
        }
        switch shape {
        case .circle: return UIBezierPath.circlePath(center: view.center, radius: view.bounds.width / 4)
        case .hexagon: return UIBezierPath.hexagonPath(forRect: controller.maskRect)
        case .rectangle: return UIBezierPath.init(rect: CGRect(x: 0,
                                                               y: controller.maskRect.origin.y,
                                                               width: controller.view.frame.width,
                                                               height: controller.view.frame.width * Layout.multiplier_053))
        case .square: return UIBezierPath.init(rect: CGRect(x: 25,
                                                               y: controller.maskRect.origin.y,
                                                               width: controller.view.frame.width - Layout.padding_50,
                                                               height: controller.view.frame.width - Layout.padding_50))
        }
    }
}
