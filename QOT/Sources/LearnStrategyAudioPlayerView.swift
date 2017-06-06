//
//  LearnStrategyAudioPlayerView.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 4/26/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol AudioPlayerViewSliderDelegate: class {
    func value(at layout: Float, in view: LearnStrategyAudioPlayerView)
}

final class LearnStrategyAudioPlayerView: UIView {

    // MARK: - Properties

    @IBOutlet weak var currentPositionLabel: UILabel!
    @IBOutlet weak var trackDurationLabel: UILabel!
    @IBOutlet weak var timerBackgroundView: UIView!
    @IBOutlet weak var audioWaveformView: AudioWaveformView!
    @IBOutlet weak var audioSlider: UISlider!
    weak var delegate: AudioPlayerViewSliderDelegate?
    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        timerBackgroundView.layer.cornerRadius = 18
        timerBackgroundView.layer.borderWidth = 1
        timerBackgroundView.layer.borderColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1).cgColor
        trackDurationLabel.font = UIFont.simpleFont(ofSize: 14)
        currentPositionLabel.font = UIFont.simpleFont(ofSize: 14)
        audioSlider.addTarget(self, action: #selector(LearnStrategyAudioPlayerView.sliderValueDidChange(_:)), for: .valueChanged)

        let image = getImage(size: CGSize(width: 10, height: audioWaveformView.bounds.height))
        audioSlider.setThumbImage(image, for: .normal)
        audioSlider.setThumbImage(image, for: .highlighted)
        audioSlider.setThumbImage(image, for: .focused)
    }

    static func instatiateFromNib() -> LearnStrategyAudioPlayerView {
        guard let view = Bundle.main.loadNibNamed("LearnStrategyAudioPlayerView", owner: nil, options: nil)?.first as? LearnStrategyAudioPlayerView else {
            fatalError("Cannont instantiate LearnStrategyAudioPlayerView")
        }

        return view
    }

    @objc private func sliderValueDidChange(_ sender: UISlider) {
        delegate?.value(at: sender.value, in: self)
    }

    private func getImage(size: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width, height: size.height))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.withAlphaComponent(0).setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}
