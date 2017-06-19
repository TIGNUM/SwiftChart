//
//  AudioWaveformView.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 4/24/17.
//  Copyright © 2017 tignum. All rights reserved.
//

import Foundation
import UIKit

final  class AudioWaveformView: UIView {

    // MARK: - Properties

    var data: [Float] = [] {
        didSet {
            redraw()
        }
    }

    private(set) var progress: Float = 0.0
    private(set) var minColorBottom: UIColor = .black
    private(set) var minColorTop: UIColor = .lightGray
    private(set) var maxColorBottom: UIColor = .blue
    private(set) var maxColorTop: UIColor = .blue
    private var gradientLayers: [CAGradientLayer] = []

    override func layoutSubviews() {
        super.layoutSubviews()

        redraw()
    }

    func setProgress(value: Float) {
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

    private func processedData() -> [Float: Float] {
        let multiplier = Float(bounds.width / 2) / Float(data.count)
        var dictionary: [Float: Float] = [:]
        for (index, value) in data.enumerated() {
            let x = round(Float(index) * multiplier)
            if let stored = dictionary[x] {
                if stored >= value {
                    continue
                }
            }
            dictionary[x] = value
        }

        var final: [Float: Float] = [:]
        for (key, value) in dictionary {
            let x = key * 2
            final[x] = value
        }

        var last = final[0.0]!
        for i in 0..<Int(bounds.width / 2) + 1 {
            let x = Float(i) * Float(2)
            if let existing = final[x] {
                last = existing
            } else {
                final[x] = last
            }
        }

        return final
    }

    private func drawLayers(data: [Float: Float]) {
        let baseHeight: Float = 5
        let topHeight = Float(bounds.height) - baseHeight

        for x in data.keys.sorted() {
            let value = data[x]!
            let height = topHeight * value + baseHeight
            addGradiantLayer(x: x, height: height)
        }

        syncColors()
    }

    private func addGradiantLayer(x: Float, height: Float) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor.black.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.1, 1.0]
        gradient.frame = CGRect(x: CGFloat(x), y: bounds.height - CGFloat(height), width: 1, height: CGFloat(height))
        gradientLayers.append(gradient)
        layer.addSublayer(gradient)
    }

    private func syncColors() {
        syncColors(forward: true)
        syncColors(forward: false)
    }

    private func syncColors(forward: Bool) {
        let index = Int(round(CGFloat(progress) * bounds.width / 2))

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
