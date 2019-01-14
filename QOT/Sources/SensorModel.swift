//
//  SensorModel.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 17/07/2018.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

struct SensorModel {
    let state: User.FitbitState
    let sensor: Sensor

    enum Sensor {
        case fitbit
        case requestDevice

        var image: UIImage {
            switch self {
            case .fitbit: return R.image.fitbitLogo()!
            case .requestDevice: return UIColor.gray.image(size: CGSize(width: 116, height: 116))
            }
        }

        var title: String {
            switch self {
            case .fitbit: return R.string.localized.sidebarSensorsMenuFitbit()
            case .requestDevice: return R.string.localized.sidebarSensorsMenuRequestSensor()
            }
        }
    }
}

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
