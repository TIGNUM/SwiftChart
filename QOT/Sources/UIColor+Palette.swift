//
//  UIColor+Palette.swift
//  QOT
//
//  Created by karmic on 06.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

// MARK: - Randoms
var randomNumber: CGFloat {
    return (CGFloat(Float(arc4random()) / Float(UINT32_MAX)))
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: randomNumber, green: randomNumber, blue: randomNumber, alpha: 1.0)
    }

    var toHexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &alpha)
        return String(format: "#%02X%02X%02X%02X",
                      Int(round(r * 255)),
                      Int(round(g * 255)),
                      Int(round(b * 255)),
                      Int(round(alpha * 255)))
    }
}

// MARK: - Hex
extension UIColor {
    convenience init(hex: String) {
        let r, g, b, a: CGFloat
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            var hexColor = String(hex[start...])
            if hexColor.count == 6 {
                hexColor = hexColor + "FF"
            }
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt32 = 0
                if scanner.scanHexInt32(&hexNumber) {
                    r = CGFloat((hexNumber & 0xFF000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00FF0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000FF00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000FF) / 255
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        self.init(red: randomNumber, green: randomNumber, blue: randomNumber, alpha: 1)
        return
    }
}

extension UIColor {

    public class var lightGrey: UIColor {
        return UIColor(red: 156/255, green: 152/255, blue: 151/255, alpha: 1)
    }

    static var darkGrey: UIColor {
        return UIColor(red: 83/255, green: 83/255, blue: 83/255, alpha: 1)
    }

    static var tignumPink: UIColor {
        return UIColor(red: 255/255, green: 221/255, blue: 238/255, alpha: 1)
    }

    static var tignumPink10: UIColor {
        return UIColor(red: 255/255, green: 221/255, blue: 238/255, alpha: 0.1)
    }

    static var tignumPink40: UIColor {
        return UIColor(red: 255/255, green: 221/255, blue: 238/255, alpha: 0.4)
    }

    static var white10: UIColor {
           return UIColor.white.withAlphaComponent(0.1)
    }

    static var white15: UIColor {
        return UIColor.white.withAlphaComponent(0.15)
    }

    static var white20: UIColor {
        return UIColor.white.withAlphaComponent(0.2)
    }

    static var white40: UIColor {
        return UIColor.white.withAlphaComponent(0.4)
    }

    static var white50: UIColor {
        return UIColor.white.withAlphaComponent(0.5)
    }

    static var white70: UIColor {
        return UIColor.white.withAlphaComponent(0.7)
    }

    static var black10: UIColor {
        return UIColor.black.withAlphaComponent(0.1)
    }

    static var black20: UIColor {
        return UIColor.black.withAlphaComponent(0.2)
    }

    static var black30: UIColor {
        return UIColor.black.withAlphaComponent(0.3)
    }

    static var black60: UIColor {
        return UIColor.black.withAlphaComponent(0.6)
    }

    public class var redOrange40: UIColor {
        return UIColor(red: 238/255, green: 94/255, blue: 85/255, alpha: 0.4)
    }

    public class var redOrange70: UIColor {
        return UIColor(red: 238/255, green: 94/255, blue: 85/255, alpha: 0.7)
    }

    public class var redOrange: UIColor {
        return UIColor(red: 238/255, green: 94/255, blue: 85/255, alpha: 1)
    }

    public class var accent04: UIColor {
        return UIColor(red: 182/255, green: 155/255, blue: 134/255, alpha: 0.04)
    }

    public class var accent10: UIColor {
        return UIColor(red: 182/255, green: 155/255, blue: 134/255, alpha: 0.1)
    }

    public class var accent70: UIColor {
        return accent.withAlphaComponent(0.7)
    }

    public class var accent60: UIColor {
        return accent.withAlphaComponent(0.6)
    }

    public class var accent40: UIColor {
        return accent.withAlphaComponent(0.4)
    }

    public class var accent30: UIColor {
        return accent.withAlphaComponent(0.3)
    }

    public class var accent20: UIColor {
        return accent.withAlphaComponent(0.2)
    }

    public class var accent75: UIColor {
        return accent.withAlphaComponent(0.75)
    }

    /// UIColor(red: 182/255, green: 155/255, blue: 134/255, alpha: 1)
    public class var accent: UIColor {
        return UIColor(red: 182/255, green: 155/255, blue: 134/255, alpha: 1)
    }

    public class var sand08: UIColor {
        return UIColor(red: 235/255, green: 231/255, blue: 228/255, alpha: 0.08)
    }

    public class var sand03: UIColor {
        return UIColor.sand.withAlphaComponent(0.3)
    }

    public class var sand10: UIColor {
        return UIColor(red: 235/255, green: 231/255, blue: 228/255, alpha: 0.1)
    }

    public class var sand15: UIColor {
        return UIColor.sand.withAlphaComponent(0.15)
    }

    public class var sand20: UIColor {
        return UIColor(red: 235/255, green: 231/255, blue: 228/255, alpha: 0.2)
    }

    public class var sand30: UIColor {
        return UIColor(red: 235/255, green: 231/255, blue: 228/255, alpha: 0.3)
    }

    public class var sand40: UIColor {
        return sand.withAlphaComponent(0.4)
    }

    public class var sand60: UIColor {
        return UIColor(red: 235/255, green: 231/255, blue: 228/255, alpha: 0.6)
    }

    public class var sand70: UIColor {
        return UIColor(red: 235/255, green: 231/255, blue: 228/255, alpha: 0.7)
    }

    public class var sand: UIColor {
        return UIColor(red: 235/255, green: 231/255, blue: 228/255, alpha: 1)
    }

    public class var carbonDark20: UIColor {
        return carbonDark.withAlphaComponent(0.2)
    }

    public class var carbonDark30: UIColor {
        return carbonDark.withAlphaComponent(0.3)
    }

    public class var carbonDark08: UIColor {
        return carbonDark.withAlphaComponent(0.08)
    }

    public class var carbonDark: UIColor {
        return UIColor(red: 8/255, green: 8/255, blue: 7/255, alpha: 1)
    }

    public class var carbonDark80: UIColor {
        return UIColor(red: 8/255, green: 8/255, blue: 7/255, alpha: 0.8)
    }

    public class var carbonNew: UIColor {
        return UIColor(red: 10/255, green: 10/255, blue: 9/255, alpha: 1)
    }

    public class var carbon05: UIColor {
        return UIColor.carbon.withAlphaComponent(0.05)
    }

    public class var carbonNew08: UIColor {
        return carbonNew.withAlphaComponent(0.08)
    }

    public class var carbonNew30: UIColor {
        return carbonNew.withAlphaComponent(0.3)
    }

    public class var carbonNew80: UIColor {
        return carbonNew.withAlphaComponent(0.8)
    }

    public class var carbon30: UIColor {
        return carbon.withAlphaComponent(0.3)
    }

    public class var carbon40: UIColor {
        return carbon.withAlphaComponent(0.4)
    }

    public class var carbon60: UIColor {
        return carbon.withAlphaComponent(0.6)
    }

    public class var carbon70: UIColor {
        return carbon.withAlphaComponent(0.7)
    }

    public class var carbon80: UIColor {
        return carbon.withAlphaComponent(0.8)
    }

    public class var carbon90: UIColor {
        return carbon.withAlphaComponent(0.9)
    }

    public class var carbon: UIColor {
        return UIColor(red: 20/255, green: 19/255, blue: 18/255, alpha: 1)
    }

    /// UIColor(white: 255/255, alpha: 0.1)
    public class var whiteLight: UIColor {
        return UIColor(white: 255/255, alpha: 0.1)
    }

    /// UIColor(white: 91/255, alpha: 1)
    public class var brownishGrey: UIColor {
        return UIColor(white: 91/255, alpha: 1)
    }

    /// UIColor(white: 255/255, alpha: 0.6)
    public class var white60: UIColor {
        return UIColor(white: 255/255, alpha: 0.6)
    }

    /// UIColor(white: 255/255, alpha: 0.9)
    public class var white90: UIColor {
        return UIColor(white: 255/255, alpha: 0.9)
    }

    /// UIColor(red: 4/255, green: 8/255, blue: 20/255, alpha: 1)
    public class var darkIndigo: UIColor {
        return UIColor(red: 4/255, green: 8/255, blue: 20/255, alpha: 1)
    }

    /// UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 0.6)
    public class var blackTwo: UIColor {
        return UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 1)
    }

    /// UIColor(red: 230/255, green: 0, blue: 34/255, alpha: 1)
    public class var cherryRed: UIColor {
        return UIColor(red: 230/255, green: 0, blue: 34/255, alpha: 1)
    }

    /// UIColor(red: 230/255, green: 0, blue: 34/255, alpha: 0.9)
    public class var cherryRed90: UIColor {
        return UIColor(red: 230/255, green: 0, blue: 34/255, alpha: 0.9)
    }

    /// UIColor(red: 230/255, green: 0, blue: 34/255, alpha: 0.7)
    public class var cherryRed70: UIColor {
        return UIColor.cherryRed.withAlphaComponent(0.7)
    }

    /// UIColor(red: 230/255, green: 0, blue: 34/255, alpha: 0.6)
    public class var cherryRed60: UIColor {
        return UIColor.cherryRed.withAlphaComponent(0.6)
    }

    /// UIColor(red: 1, green: 0, blue: 34/255, alpha: 0.2)
    public class var cherryRed20: UIColor {
        return UIColor(red: 1, green: 0, blue: 34/255, alpha: 0.2)
    }

    /// UIColor(red: 255/255, green: 0, blue: 38/255, alpha: 1)
    public class var cherryRedTwo: UIColor {
        return UIColor(red: 1, green: 0, blue: 38/255, alpha: 1)
    }

    /// UIColor(red: 3/255, green: 6/255, blue: 15/255, alpha: 1)
    public class var darkIndigoTwo: UIColor {
        return UIColor(red: 3/255, green: 6/255, blue: 15/255, alpha: 1)
    }

    /// UIColor(red: 0, green: 225/255, blue: 0, alpha: 0.7)
    public class var green70: UIColor {
        return UIColor.green.withAlphaComponent(0.7)
    }
    /// UIColor(red: 203/255, green: 75/255, blue: 90/255, alpha: 1)
    public class var recoveryRed: UIColor {
        return UIColor(red: 203/255, green: 75/255, blue: 90/255, alpha: 1)
    }

    // UIColor(red: 212/255, green: 152/255, blue: 63/255, alpha: 1)
    public class var recoveryOrange: UIColor {
        return UIColor(red: 212/255, green: 152/255, blue: 63/255, alpha: 1)
    }

    /// UIColor(red: 143/255, green: 189/255, blue: 93/255, alpha: 1)
    public class var recoveryGreen: UIColor {
        return UIColor(red: 143/255, green: 189/255, blue: 93/255, alpha: 1)
    }
    /// UIColor(white: 1, alpha: 0.02)
    public class var whiteLight2: UIColor {
        return UIColor(white: 1, alpha: 0.062)
    }

    /// UIColor(white: 1, alpha: 0.06)
    public class var whiteLight6: UIColor {
        return UIColor(white: 1, alpha: 0.06)
    }

    /// UIColor(white: 1, alpha: 0.08)
    public class var whiteLight8: UIColor {
        return UIColor(white: 1, alpha: 0.08)
    }

    /// UIColor(white: 1, alpha: 0.12)
    public class var whiteLight12: UIColor {
        return UIColor(white: 1, alpha: 0.12)
    }

    /// UIColor(white: 1, alpha: 0.14)
    public class var whiteLight14: UIColor {
        return UIColor(white: 1, alpha: 0.14)
    }

    /// UIColor(white: 255/255, alpha: 0.3)
    public class var white30: UIColor {
        return UIColor(white: 1, alpha: 0.3)
    }

    /// UIColor(white: 255/255, alpha: 0.36)
    public class var white36: UIColor {
        return UIColor(white: 1, alpha: 0.36)
    }

    /// UIColor(white: 179/255, alpha: 0.2)
    public class var greyish20: UIColor {
        return UIColor(white: 179/255, alpha: 0.2)
    }

    /// UIColor(white: 255/255, alpha: 0)
    public class var white0: UIColor {
        return UIColor(white: 1, alpha: 0)
    }

    /// UIColor(red: 39/255, green: 41/255, blue: 57/255, alpha: 1)
    public class var dark: UIColor {
        return UIColor(red: 39/255, green: 41/255, blue: 57/255, alpha: 1)
    }

    /// UIColor(red: 5/255, green: 40/255, blue: 70/255, alpha: 1)
    public class var darkAzure: UIColor {
        return UIColor(red: 5/255, green: 40/255, blue: 70/255, alpha: 1)
    }

    /// UIColor(red: 1/255, green: 148/255, blue: 255/255, alpha: 1)
    public class var azure: UIColor {
        return UIColor(red: 1/255, green: 148/255, blue: 255/255, alpha: 1)
    }

    /// UIColor(red: 0/255, green: 149/255, blue: 255/255, alpha: 0.2)
    public class var azure20: UIColor {
        return UIColor(red: 0/255, green: 149/255, blue: 255/255, alpha: 0.2)
    }

    public class var azure40: UIColor {
        return UIColor(red: 0/255, green: 149/255, blue: 255/255, alpha: 0.4)
    }

    /// UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.08)
    public class var white8: UIColor {
        return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.08)
    }

    ///  UIColor(red: 255/255, green: 0/255, blue: 38/255, alpha: 0.3)
    public class var cherryRedTwo30: UIColor {
        return UIColor(red: 255/255, green: 0/255, blue: 38/255, alpha: 0.3)
    }

    ///  UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3)
    public class var whiteLight40: UIColor {
        return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
    }

    ///  UIColor(red: 7/255, green: 24/255, blue: 37/255, alpha: 1)
    public class var pineGreen: UIColor {
        return UIColor(red: 7/255, green: 24/255, blue: 37/255, alpha: 1)
    }

    /// UIColor(red: 67/255, green: 68/255, blue: 73/255, alpha: 1)
    public class var charcoalGrey: UIColor {
        return UIColor(red: 67/255, green: 68/255, blue: 73/255, alpha: 1)
    }

    /// UIColor(red: 53/255, green: 55/255, blue: 61/255, alpha: 1)
    public class var charcoalGreyDark: UIColor {
        return UIColor(red: 53/255, green: 55/255, blue: 61/255, alpha: 1)
    }

    /// UIColor(red: 85/255, green: 90/255, blue: 94/255, alpha: 1)
    public class var charcoalGreyMedium: UIColor {
        return UIColor(red: 85/255, green: 90/255, blue: 94/255, alpha: 1)
    }

    /// UIColor(red: 102/255, green: 116/255, blue: 129/255, alpha: 0.3)
    public class var battleshipGrey30: UIColor {
        return UIColor(red: 102/255, green: 116/255, blue: 129/255, alpha: 0.3)
    }

    /// UIColor(red: 102/255, green: 116/255, blue: 129/255, alpha: 1)
    public class var battleshipGrey: UIColor {
        return UIColor(red: 34/255, green: 39/255, blue: 48/255, alpha: 1)
    }

    /// UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1)
    public class var charcoal: UIColor {
        return UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1)
    }

    /// UIColor(red: 255/255, green: 83/255, blue: 73/255, alpha: 1)
    public class var coral: UIColor {
        return UIColor(red: 255/255, green: 83/255, blue: 73/255, alpha: 1)
    }

    /// UIColor(red: 255/255, green: 73/255, blue: 81/255, alpha: 1)
    public class var batchRed: UIColor {
        return UIColor(red: 255/255, green: 73/255, blue: 81/255, alpha: 1)
    }

    /// UIColor(red: 80/255, green: 277/255, blue: 194/255, alpha: 1)
    public class var aquaMarine: UIColor {
        return UIColor(red: 80/255, green: 227/255, blue: 194/255, alpha: 1)
    }

    public class var guideCardToDoBackground: UIColor {
        return UIColor(red: 31/255, green: 62/255, blue: 87/255, alpha: 1)
    }

    public class var guideCardToDoBackground70: UIColor {
        return UIColor(red: 31/255, green: 62/255, blue: 87/255, alpha: 0.7)
    }

    public class var guideCardDoneBackground: UIColor {
        return UIColor(red: 33/255, green: 43/255, blue: 53/255, alpha: 0.7)
    }

    public class var guideCardTypeGray: UIColor {
        return UIColor(red: 166/255, green: 169/255, blue: 173/255, alpha: 1)
    }

    public class var addSensorConnectGray: UIColor {
        return UIColor(red: 2/255, green: 149/255, blue: 208/255, alpha: 1)
    }

    public class var dailyPrepNullStateGray: UIColor {
        return UIColor(red: 92/255, green: 109/255, blue: 122/255, alpha: 0.7)
    }

    public class var nightModeSubFont: UIColor {
        return Date().isNight ? .white : .black30
    }

    public class var nightModeBlack: UIColor {
        return Date().isNight ? .white : .black
    }

    public class var nightModeBlack30: UIColor {
        return Date().isNight ? .white70 : .black30
    }

    public class var nightModeBlack40: UIColor {
        return Date().isNight ? .white : .white40
    }

    public class var nightModeBlackTwo: UIColor {
        return Date().isNight ? .white : .blackTwo
    }

    public class var nightModeBlue: UIColor {
        return Date().isNight ? .azure : .blue
    }

    public class var guideProgressTintColor: UIColor {
        return UIColor(red: 0.11, green: 0.22, blue: 0.31, alpha: 1.0)
    }

    public class var blueGray: UIColor {
        return UIColor(red: 142.0 / 255.0, green: 142.0 / 255.0, blue: 147.0 / 255.0, alpha: 1.0)
    }

    public class var grapefruit: UIColor {
        return UIColor(red: 244.0 / 255.0, green: 96.0 / 255.0, blue: 96.0 / 255.0, alpha: 1.0)
    }

    public class var heatMapBrightRed: UIColor {
        return UIColor(red: 223.0 / 255.0, green: 80.0 / 255.0, blue: 56.0 / 255.0, alpha: 1.0)
    }

    public class var heatMapRed: UIColor {
        return UIColor(red: 203.0 / 255.0, green: 42.0 / 255.0, blue: 15.0 / 255.0, alpha: 1.0)
    }

    public class var heatMapDarkRed: UIColor {
        return UIColor(red: 165.0 / 255.0, green: 30.0 / 255.0, blue: 8.0 / 255.0, alpha: 1.0)
    }

    public class var heatMapBlue: UIColor {
        return UIColor(red: 56.0 / 255.0, green: 81.0 / 255.0, blue: 99.0 / 255.0, alpha: 1.0)
    }

    public class var heatMapDarkBlue: UIColor {
        return UIColor(red: 20.0 / 255.0, green: 54.0 / 255.0, blue: 79.0 / 255.0, alpha: 1.0)
    }

    public class var sleepQuality: UIColor {
        return UIColor(red: 90.0 / 255.0, green: 123.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }

    public class var sleepQuantity: UIColor {
        return UIColor(red: 157.0 / 255.0, green: 117.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
    }

    public class var tenDayLoad: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 123.0 / 255.0, blue: 127.0 / 255.0, alpha: 1.0)
    }

    public class var fiveDayRecovery: UIColor {
        return UIColor(red: 41.0 / 255.0, green: 200.0 / 255.0, blue: 156.0 / 255.0, alpha: 1.0)
    }

    public class var fiveDayLoad: UIColor {
        return UIColor(red: 60.0 / 255.0, green: 208.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
    }

    public class var fiveDayImpactReadiness: UIColor {
        return UIColor(red: 180.0 / 255.0, green: 201.0 / 255.0, blue: 206.0 / 255.0, alpha: 1.0)
    }

    public class var actionBlue: UIColor {
        return UIColor(red: 0 / 255.0, green: 98.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }

    public class var actionBlue75: UIColor {
        return UIColor(red: 0 / 255.0, green: 98.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.75)
    }

    public class var mindsetShifterGreen: UIColor {
        return UIColor(red: 0.604, green: 0.851, blue: 0.514, alpha: 1.0)
    }

    public class var mindsetShifterRed: UIColor {
        return UIColor(red: 0.816, green: 0.408, blue: 0.306, alpha: 1.0)
    }
    //Solid Colors

    public class var skeletonTitleColor: UIColor {
        return UIColor(red: (24.0 / 255.0) * UIColor.skeletonIntensityFactor,
                       green: (24.0 / 255.0) * UIColor.skeletonIntensityFactor,
                       blue: (24.0 / 255.0) * UIColor.skeletonIntensityFactor,
                       alpha: 1.0)
    }

    public class var skeletonSubtitleColor: UIColor {
        return UIColor(red: (24.0 / 255.0) * UIColor.skeletonIntensityFactor,
                       green: (24.0 / 255.0) * UIColor.skeletonIntensityFactor,
                       blue: (24.0 / 255.0) * UIColor.skeletonIntensityFactor,
                       alpha: 1.0)
    }

    public class var skeletonOtherViewsColor: UIColor {
        return UIColor(red: (24.0 / 255.0) * UIColor.skeletonIntensityFactor,
                       green: (24.0 / 255.0) * UIColor.skeletonIntensityFactor,
                       blue: (24.0 / 255.0) * UIColor.skeletonIntensityFactor,
                       alpha: 1.0)
    }

    static let skeletonIntensityFactor: CGFloat = 1

    func isLightColor() -> Bool {
        var grayscale: CGFloat = 0
        var alpha: CGFloat = 0
        _ = self.getWhite(&grayscale, alpha: &alpha)
        return grayscale > 0.5
    }
}
