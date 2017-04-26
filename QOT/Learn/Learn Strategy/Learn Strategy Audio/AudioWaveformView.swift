//
//  AudioWaveformView.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 4/24/17.
//  Copyright © 2017 tignum. All rights reserved.
//

import Foundation
import UIKit

class AudioWaveformView: UIView {

    var data: [CGFloat] = [] {
        didSet {
            redraw()
        }
    }

    private(set) var progress: CGFloat = 0.0
    private(set) var minColorBottom: UIColor = .red
    private(set) var minColorTop: UIColor = .purple
    private(set) var maxColorBottom: UIColor = .yellow
    private(set) var maxColorTop: UIColor = .green

    private var gradientLayers: [CAGradientLayer] = []

    override func layoutSubviews() {
        super.layoutSubviews()

        redraw()
    }

    func setProgress(value: CGFloat) {
        let new = min(max(0, value), 1)
        if new < progress {
            progress = new
            syncColors(forward: false)
        } else if new > progress {
            progress = new
            syncColors(forward: true)
        }
    }

    private func redraw() {
        removeExistingLayers()

        guard data.count > 0 else {
            return
        }

        drawLayers(data: processedData())
    }

    private func removeExistingLayers() {
        gradientLayers.forEach { $0.removeFromSuperlayer() }
        gradientLayers = []
    }

    private func processedData() -> [CGFloat: CGFloat] {
        let multiplier = (bounds.width / 2) / CGFloat(data.count)
        var dictionary: [CGFloat: CGFloat] = [:]
        for (index, value) in data.enumerated() {
            let x = round(CGFloat(index) * multiplier)
            if let stored = dictionary[x] {
                if stored >= value {
                    continue
                }
            }
            dictionary[x] = value
        }

        var final: [CGFloat: CGFloat] = [:]
        for (key, value) in dictionary {
            let x = key * 2
            final[x] = value
        }

        var last = final[0.0]!
        for i in 0..<Int(bounds.width / 2) + 1 {
            let x = CGFloat(i) * CGFloat(2)
            if let existing = final[x] {
                last = existing
            } else {
                final[x] = last
            }
        }

        return final
    }

    private func drawLayers(data: [CGFloat: CGFloat]) {
        let baseHeight: CGFloat = 5
        let topHeight = bounds.height - baseHeight

        for x in data.keys.sorted() {
            let value = data[x]!
            let height = topHeight * value + baseHeight
            addGradiantLayer(x: x, height: height)
        }

        syncColors()
    }

    private func addGradiantLayer(x: CGFloat, height: CGFloat) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor.black.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.1, 1.0]
        gradient.frame = CGRect(x: x, y: bounds.height - height, width: 1, height: height)
        gradientLayers.append(gradient)
        layer.addSublayer(gradient)
    }

    private func syncColors() {
        syncColors(forward: true)
        syncColors(forward: false)
    }

    private func syncColors(forward: Bool) {
        let index = Int(round(progress * bounds.width / 2))

        guard index >= 0 && index <= gradientLayers.count else {
            return
        }

        if forward {
            for i in 0..<index {
                gradientLayers[i].colors = [maxColorTop.cgColor, maxColorBottom.cgColor]
            }
        } else {
            for i in index..<gradientLayers.count {
                gradientLayers[i].colors = [minColorTop.cgColor, minColorBottom.cgColor]
            }
        }
    }
}
