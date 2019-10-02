//
//  SprintChallengeTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import UIKit
import qot_dal

final class SprintChallengeTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    weak var delegate: DailyBriefViewControllerDelegate?
    @IBOutlet private weak var iconRead: UIImageView!
    @IBOutlet private weak var iconAudio: UIImageView!
    @IBOutlet private weak var iconVideo: UIImageView!
    @IBOutlet private weak var iconFiles: UIImageView!
    var selectedStrategyID: Int?
    var selectedToolID: Int?

    override func awakeFromNib() {
        super.awakeFromNib()
        iconRead.isHidden = true
        iconVideo.isHidden = true
        iconFiles.isHidden = true
        iconAudio.isHidden = true
        ThemeView.level2.apply(self)
    }

    func configure(title: String?, durationString: String?, remoteID: Int?, section: ContentSection?, format: ContentFormat?, numberOfItems: Int) {
        ThemeText.sprintTitle.apply((title ?? "").uppercased(), to: titleLabel)
        ThemeText.durationString.apply(durationString, to: durationLabel)
        var duration: String
        if numberOfItems > 1 {
            if format == .prepare {
                iconRead.isHidden = false
            } else { iconFiles.isHidden = false
            }
        } else {
            if format == .pdf || format == .paragraph || format == .prepare {
                iconRead.isHidden = false
            }
            iconVideo.isHidden = format != .video
            iconAudio.isHidden = format != .audio
        }

        if numberOfItems > 1 && section == .QOTLibrary {
            duration = String(numberOfItems) + " items"
        } else { duration = ( durationString ?? "")
        }
        ThemeText.durationString.apply(duration, to: durationLabel)
    }

    @objc func openStrategy(sender: UITapGestureRecognizer) {
        openStrategyFromSprint()
    }

    @objc func openTool(sender: UITapGestureRecognizer) {
         openToolFromSprint()
    }

    func openStrategyFromSprint() {
        delegate?.openStrategyFromSprint(strategyID: selectedStrategyID)
    }

    func openToolFromSprint() {
        delegate?.openToolFromSprint(toolID: selectedToolID)
    }
}
