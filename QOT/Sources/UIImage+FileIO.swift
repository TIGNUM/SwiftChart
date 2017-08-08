//
//  UIImage+FileIO.swift
//  QOT
//
//  Created by Lee Arromba on 03/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

extension UIImage {
    enum ImageError: Error {
        case directoryNotFound
        case imageConvertionError
    }
    
    /// Saves image to ...(lib)/image directory
    func save(withName name: String) throws -> URL {
        let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        guard let directory = paths.first else {
            log("couldn't find directory")
            throw ImageError.directoryNotFound
        }
        guard let data = UIImageJPEGRepresentation(self, 0.3) else {
            log("problem converting image data")
            throw ImageError.imageConvertionError
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
            log(error)
            throw error
        }
    }
}
