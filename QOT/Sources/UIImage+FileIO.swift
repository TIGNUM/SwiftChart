//
//  UIImage+FileIO.swift
//  QOT
//
//  Created by Lee Arromba on 03/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

extension UIImage {
    enum Format {
        case png
        case jpg(compressionQuality: CGFloat)

        var pathExtension: String {
            switch self {
            case .png:
                return "png"
            case .jpg:
                return "jpg"
            }
        }
    }

    enum ImageError: Error {
        case imageConvertionError
    }

    func data(format: Format) throws -> Data {
        let data: Data?
        switch format {
        case .png:
            data = UIImagePNGRepresentation(self)
        case .jpg(let compressionQuality):
            data = UIImageJPEGRepresentation(self, compressionQuality)
        }
        if let data = data {
            return data
        } else {
            log("problem converting image data", level: .error)
            throw ImageError.imageConvertionError
        }
    }

    /**
     Saves image to `URL.imageDirectory`.
     - returns: The image name including path extension.
    */
    func save(withName name: String, format: Format = .jpg(compressionQuality: 0.5)) throws -> URL {
        try FileManager.default.createDirectory(at: URL.imageDirectory, withIntermediateDirectories: true)
        let path = "\(name).\(format.pathExtension)"
        let url = URL(fileURLWithPath: path, relativeTo: URL.imageDirectory)
        log("save image to URL : \(url)", level: .debug)
        try data(format: format).write(to: url, options: [])
        return url
    }
}
