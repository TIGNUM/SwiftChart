//
//  ExpertThoughtsTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 27.04.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class ExpertThoughtsTableViewCell: BaseDailyBriefCell {

    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet private weak var audioButton: UIButton!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var headerView: UIView!

    private var mediaURL: URL?
    private var duration: Double?
    private var remoteID: Int?
    weak var delegate: DailyBriefViewControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        audioButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(descriptionLabel)
        skeletonManager.addOtherView(audioButton)
    }

    func configure(with viewModel: ExpertThoughtsCellViewModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        baseHeaderView?.configure(title: (model.title ?? "").uppercased(),
                                  subtitle: "")
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 0
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: baseHeaderView?.titleLabel)
        ThemeText.dailyBriefSubtitle.apply("blablavlavlablablablab ablab hauhsaudhas hdufhaeu huidfh jhefuwe bcudhu bdhfej bhfjewfhuew cbhjewfjwefw hjefwhfewj", to: descriptionLabel)

        descriptionLabel.isHidden = model.description == nil
        duration = model.audioDuration
        remoteID = model.remoteID
        let mediaDescription = String(format: "%02i:%02i", Int(duration ?? 0) / 60 % 60, Int(duration ?? 0) % 60)
        audioButton.setTitle(mediaDescription, for: .normal)
    }

    @IBAction func audioAction(_ sender: Any) {
        let media = MediaPlayerModel(title: "",
                                     subtitle: "",
                                     url: mediaURL,
                                     totalDuration: duration ?? 0, progress: 0,
                                     currentTime: 0,
                                     mediaRemoteId: remoteID ?? 0)
        NotificationCenter.default.post(name: .playPauseAudio, object: media)
    }

    @IBAction func videoAction(_ sender: Any) {
        delegate?.videoAction(sender, videoURL: mediaURL, contentItem: nil)
    }
}

// MARK: - Private

private extension ExpertThoughtsTableViewCell {

    func setAudioAsCompleteIfNeeded(remoteID: Int) {
        audioButton.backgroundColor = .carbon
        if let items = UserDefault.finishedAudioItems.object as? [Int], items.contains(obj: remoteID) == true {
            audioButton.backgroundColor = .accent40
        }
    }
}
