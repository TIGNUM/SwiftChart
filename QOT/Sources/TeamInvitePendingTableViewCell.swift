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
    @IBOutlet private weak var declineButton: UIButton!
    @IBOutlet private weak var joinButton: UIButton!
    @IBOutlet private weak var infoLabelHeightConstriant: NSLayoutConstraint!
    private lazy var keyJoin: AppTextKey = .team_invite_cta_join
    private lazy var keyDecline: AppTextKey = .team_invite_cta_decline
    private var pendingInvite: TeamInvite.Pending?

    override func awakeFromNib() {
        super.awakeFromNib()
        layoutButton(declineButton, keyDecline, true)
        layoutButton(joinButton, keyJoin, true)
    }

    func configure(pendingInvite: TeamInvite.Pending) {
        self.pendingInvite = pendingInvite
        let qdmInvite = pendingInvite.qdmInvite
        let team = qdmInvite.team
        setupTeamLabel(team?.name ?? "", team?.teamColor ?? "")
        setupInfoLabel(qdmInvite.invitedDate ?? Date(), qdmInvite.sender ?? "", team?.memberCount ?? 0)
        setActive(pendingInvite.canJoin, pendingInvite.warning)
    }
}

// MARK: - Private
private extension TeamInvitePendingTableViewCell {
    func layoutButton(_ button: UIButton, _ key: AppTextKey, _ canJoin: Bool) {
        button.corner(radius: 20, borderColor: canJoin ? .accent40 : .sand10, borderWidth: canJoin ? 1 : 0)
        button.setTitleColor(canJoin ? .accent : .sand40, for: .normal)
        button.setTitle(AppTextService.get(key), for: .normal)
        button.backgroundColor = canJoin ? .carbon90 : .sand10
        button.isEnabled = canJoin
    }

    func setupInfoLabel(_ date: Date, _ sender: String, _ memberCount: Int) {
        let dateString = DateFormatter.teamInvite.string(from: date)
        let suffix = memberCount > 1 ? "s" : ""
        inviteInfoLabel.text = String(format: AppTextService.get(.team_invite_details_text),
                                      sender + "\n",
                                      dateString,
                                      memberCount) + suffix
    }

    func setupTeamLabel(_ name: String, _ color: String) {
        teamNameLabel.textColor = UIColor(hex: color)
        teamNameLabel.text = name
    }

    func setActive(_ canJoin: Bool, _ warning: String?) {
        maxTeamCountInfoLabel.text = canJoin ? "" : warning
        infoLabelHeightConstriant.constant = canJoin ? 0 : 21
        layoutButton(joinButton, keyJoin, canJoin)
        updateConstraintsIfNeeded()
    }
}

// MARK: - Actions
extension TeamInvitePendingTableViewCell {
    @IBAction func didTabDecline() {
        NotificationCenter.default.post(name: .didSelectTeamInviteDecline, object: pendingInvite)
    }

    @IBAction func didTabJoin() {
        NotificationCenter.default.post(name: .didSelectTeamInviteJoin, object: pendingInvite)
    }
}
