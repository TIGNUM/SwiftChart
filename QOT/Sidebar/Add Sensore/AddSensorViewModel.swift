//
//  AddSensorViewModel.swift
//  QOT
//
//  Created by Sam Wyndham on 17.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import LoremIpsum

final class AddSensorViewModel {

    enum Sensor {
        case apple
        case fitbit
        case requestDevice

        var image: UIImage {
            let size = CGSize(width: 164, height: 207)
            switch self {
            case .apple:
                return UIColor.red.image(size: size)
            case .fitbit:
                return UIColor.blue.image(size: size)
            case .requestDevice:
                return UIColor.gray.image(size: size)
            }
        }
    }

    private let sensors: [Sensor] = [.apple, .fitbit, .requestDevice]

    let heading = mockHeading()
    let text = mockText()

    var itemCount: Int {
        return sensors.count
    }

    func item(at index: Index) -> Sensor {
        return sensors[index]
    }
}

// MARK: Mock data

private extension UIColor {
    func image(size: CGSize) -> UIImage {
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(frame.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(cgColor)
        context.fill(frame)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

private func mockHeading() -> String {
    return "Header for review devices"
}

private func mockText() -> String {
    return LoremIpsum.paragraphs(withNumber: 10)
}
