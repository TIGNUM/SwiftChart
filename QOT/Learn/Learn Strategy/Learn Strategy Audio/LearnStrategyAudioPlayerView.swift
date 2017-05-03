//
//  LearnStrategyAudioPlayerView.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 4/26/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LearnStrategyAudioPlayerView: UIView {

    @IBOutlet weak var currentPositionLabel: UILabel!
    @IBOutlet weak var trackDurationLabel: UILabel!
    @IBOutlet weak var timerBackgroundView: UIView!
    @IBOutlet weak var audioWaveformView: AudioWaveformView!

    override func awakeFromNib() {
        super.awakeFromNib()
        timerBackgroundView.layer.cornerRadius = 18
        timerBackgroundView.layer.borderWidth = 1
        timerBackgroundView.layer.borderColor = UIColor.init(red: 151/255, green: 151/255, blue: 151/255, alpha: 1).cgColor
        trackDurationLabel.font = UIFont.simpleFont(ofSize: 14)
        currentPositionLabel.font = UIFont.simpleFont(ofSize: 14)
    }

    static func instatiateFromNib() -> LearnStrategyAudioPlayerView {
        guard let view = Bundle.main.loadNibNamed("LearnStrategyAudioPlayerView", owner: nil, options: nil)?.first as? LearnStrategyAudioPlayerView else {
            fatalError("Cannont instantiate LearnStrategyAudioPlayerView")
        }
        return view
    }
}
