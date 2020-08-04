//
//  TeamInvitationCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 03.08.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class TeamInvitationCell: BaseDailyBriefCell {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet private weak var invitationLabel: UILabel!
    @IBOutlet private weak var declineButton: AnimatedButton!
    @IBOutlet private weak var joinButton: AnimatedButton!
    @IBOutlet private weak var seePendingButton: UIButton!
    private var baseHeaderView: QOTBaseHeaderView?

    override func awakeFromNib() {
        super.awakeFromNib()
        joinButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        declineButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        seePendingButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(invitationLabel)
        skeletonManager.addOtherView(declineButton)
        skeletonManager.addOtherView(joinButton)
        skeletonManager.addOtherView(seePendingButton)
    }

    func configure(model: TeamInvitationModel?) {
        let joinCta = AppTextService.get(.daily_brief_team_invitation_join_cta)
        joinButton.setTitle(joinCta, for: .normal)
        let declineCta = AppTextService.get(.daily_brief_team_invitation_decline_cta)
        let pendingCta = AppTextService.get(.daily_brief_team_invitation_see_pending_cta)
        declineButton.setTitle(declineCta, for: .normal)
        seePendingButton.setTitle(pendingCta, for: .normal)
        seePendingButton.isHidden = model?.teamNames.count == 1
        guard let count = model?.teamNames.count else { return }
        if count > 1 {
            joinButton.isHidden = true
            declineButton.isHidden = true
        } 
    }

}
