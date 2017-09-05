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
            let size = CGSize(width: 116, height: 116)
            switch self {
            case .apple:
                return UIColor.red.image(size: size)
            case .fitbit:
                return UIImage(named: "fitbitLogo")!
            case .requestDevice:
                return UIColor.gray.image(size: size)
            }
        }

        var title: String {
            switch self {
            case .apple:
                return "##APPLE"
            case .fitbit:
                return R.string.localized.sidebarSensorsMenuFitbit()
            case .requestDevice:
                return R.string.localized.sidebarSensorsMenuRequestSensor()
            }
        }

    }

    private let sensors: [Sensor] = [.fitbit, .requestDevice]

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
    return "SYNC YOUR WEARABLE"
}

private func mockText() -> String {
    return "Connecting a wearable to QOT® will help enhance your awareness of how your current habits impact your Sustainable High Performance. We integrate your sleep quantity/quality, movement, and recovery data with subjective feedback that you provide to help you identify the habits and learnings you can leverage most to be at your best when you need to be. We recommend wearing the device during sprints (critical or predetermined periods). Using your wearable during these sprints will allow you to focus your awareness and limit your long-term dependence on your wearable. Your data is used for one purpose: maximizing your QOT®. Data security is our top priority. We will never share, sell, or license your personal information or data with third-parties, including your employer, marketers, consumer groups, etc. At QOT®, you Rule your Data."
}
