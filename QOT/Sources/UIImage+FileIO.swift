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
        case jpg
    }

    enum ImageError: Error {
        case directoryNotFound
        case imageConvertionError
    }

    /// Saves image to ...(lib)/image directory
    func save(withName name: String, format: Format = .jpg) throws -> URL {
        let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        guard let directory = paths.first else {
            log("couldn't find directory", level: .error)
            throw ImageError.directoryNotFound
        }
        let data: Data
        switch format {
        case .png:
            guard let pngData = UIImagePNGRepresentation(self) else {
                log("problem converting image data", level: .error)
                throw ImageError.imageConvertionError
            }
            data = pngData
        case .jpg:
            guard let jpgData = UIImageJPEGRepresentation(self, 1.0) else {
                log("problem converting image data", level: .error)
                throw ImageError.imageConvertionError
            }
            data = jpgData
        }

        var path = directory.appending("/images")
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: nil)
            } catch {
                throw error
            }
        }

        path = path.appendingFormat("/%@.jpg", name)
        let url = URL(fileURLWithPath: path)
        do {
            try data.write(to: url)
            return url
        } catch {
            log(error, level: .error)
            throw error
        }
    }
}
