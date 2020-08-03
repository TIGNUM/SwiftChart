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
    @IBOutlet private weak var declineButton: UIButton!
    @IBOutlet private weak var joinButton: UIButton!
    private var baseHeaderView: QOTBaseHeaderView?

    override func awakeFromNib() {
        super.awakeFromNib()
        joinButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        declineButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(invitationLabel)
        skeletonManager.addOtherView(declineButton)
        skeletonManager.addOtherView(joinButton)
    }

    func configure(model: TeamInvitationModel?) {
        
    }

}
