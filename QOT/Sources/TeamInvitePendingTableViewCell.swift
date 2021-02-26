//
//  TeamInvitePendingTableViewCell.swift
//  QOT
//
//  Created by karmic on 14.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamInvitePendingTableViewCell: UITableViewCell, Dequeueable {
    @IBOutlet private weak var teamNameLabel: UILabel!
    @IBOutlet private weak var inviteInfoLabel: UILabel!
    @IBOutlet private weak var maxTeamCountInfoLabel: UILabel!
    @IBOutlet private weak var declineButton: RoundedButton!
    @IBOutlet private weak var joinButton: RoundedButton!
    @IBOutlet private weak var infoLabelHeightConstriant: NSLayoutConstraint!
    private lazy var keyJoin: AppTextKey = .team_invite_cta_join
    private lazy var keyDecline: AppTextKey = .team_invite_cta_decline
    private var pendingInvite: TeamInvite.Pending?

    override func awakeFromNib() {
        super.awakeFromNib()
        NewThemeView.dark.apply(self)
        layoutButton(declineButton, keyDecline, true)
        layoutButton(joinButton, keyJoin, true)
    }

    func configure(pendingInvite: TeamInvite.Pending) {
        self.pendingInvite = pendingInvite
        let qdmInvite = pendingInvite.qdmInvite
        let team = qdmInvite.team
        setupTeamLabel(team?.name ?? "", team?.teamColor ?? "")
        setupInfoLabel(qdmInvite.invitedDate ?? Date(), qdmInvite.sender ?? "", team?.memberCount ?? .zero)
        setActive(pendingInvite.canJoin, pendingInvite.warning)
    }
}

// MARK: - Private
private extension TeamInvitePendingTableViewCell {
    func layoutButton(_ button: RoundedButton, _ key: AppTextKey, _ canJoin: Bool) {
        ThemableButton.darkButton.apply(button, title: AppTextService.get(key))
        button.isEnabled = canJoin
    }

    func setupInfoLabel(_ date: Date, _ sender: String, _ memberCount: Int) {
        let dateString = "\n" + DateFormatter.teamInvite.string(from: date)
        let suffix = memberCount > 1 ? "s" : ""
        let info = String(format: AppTextService.get(.team_invite_details_text), sender, dateString, memberCount)
        ThemeText.MediumBodySand.apply(info + suffix, to: inviteInfoLabel)
    }

    func setupTeamLabel(_ name: String, _ color: String) {
        teamNameLabel.textColor = UIColor(hex: color)
        teamNameLabel.text = name
    }

    func setActive(_ canJoin: Bool, _ warning: String?) {
        maxTeamCountInfoLabel.text = canJoin ? "" : warning
        infoLabelHeightConstriant.constant = canJoin ?.zero : 21
        layoutButton(joinButton, keyJoin, canJoin)
        updateConstraintsIfNeeded()
    }
}

// MARK: - Actions
extension TeamInvitePendingTableViewCell {
    @IBAction func didTabDecline() {
        trackUserEvent(.DECLINE_TEAM_INVITATION, value: pendingInvite?.qdmInvite.team?.remoteID ?? .zero)
        NotificationCenter.default.post(name: .didSelectTeamInviteDecline, object: pendingInvite?.qdmInvite)
    }

    @IBAction func didTabJoin() {
        trackUserEvent(.ACCEPT_TEAM_INVITATION, value: pendingInvite?.qdmInvite.team?.remoteID ?? .zero)
        NotificationCenter.default.post(name: .didSelectTeamInviteJoin, object: pendingInvite?.qdmInvite)
    }

    func trackUserEvent(_ name: QDMUserEventTracking.Name,
                        value: Int? = nil,
                        stringValue: String? = nil,
                        valueType: QDMUserEventTracking.ValueType? = nil) {
        var userEventTrack = QDMUserEventTracking()
        userEventTrack.name = name
        userEventTrack.value = value
        userEventTrack.stringValue = stringValue
        userEventTrack.valueType = valueType
        userEventTrack.action = .TAP
        NotificationCenter.default.post(name: .reportUserEvent, object: userEventTrack)
    }
}
