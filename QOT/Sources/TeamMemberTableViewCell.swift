//
//  TeamMemberTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 10.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamMemberTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var joinedIcon: UIImageView!
    @IBOutlet private weak var pendingIcon: UIImageView!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var demoView: UIView!
    @IBOutlet private weak var demoJoinedIcon: UIImageView!
    @IBOutlet private weak var demoEmailLabel: UILabel!
    @IBOutlet private weak var demoRemoveView: UIView!
    @IBOutlet private weak var demoInviteView: UIView!

    @IBOutlet private weak var demoViewLeadingContraint: NSLayoutConstraint!
    @IBOutlet private weak var demoViewTrailingContraint: NSLayoutConstraint!
    @IBOutlet private weak var demoRemoveViewTrailingContraint: NSLayoutConstraint!
    @IBOutlet private weak var demoInviteViewTrailingContraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundView = UIView(frame: bounds)
        self.selectedBackgroundView = UIView(frame: bounds)
        ThemeView.level2Selected.apply(selectedBackgroundView!)
        setDemoHidden(true)
    }

    func configure(memberEmail: String?, memberStatus: TeamMember.Status) {
        ThemeText.memberEmail.apply(memberEmail, to: emailLabel)
        ThemeText.memberEmail.apply(memberEmail, to: demoEmailLabel)
        ThemeView.level2.apply(backgroundView!)
        pendingIcon.isHidden = memberStatus == .joined
        joinedIcon.isHidden = memberStatus == .pending
    }
}

private extension TeamMemberTableViewCell {
    func setDemoHidden(_ isHidden: Bool) {
        demoView.isHidden = isHidden
        demoInviteView.isHidden = isHidden
        demoRemoveView.isHidden = isHidden
        demoJoinedIcon.isHidden = isHidden
        demoEmailLabel.isHidden = isHidden
    }
}

extension TeamMemberTableViewCell {
    func showDemo() {
        guard UserDefault.showTableViewSwipeDemo.boolValue == false else { return }
        setDemoHidden(false)
        let demoFrame = demoView.frame
        let demoRemoveFrame = demoRemoveView.frame
        let demoInviteFrame = demoInviteView.frame
        UIView.animate(withDuration: 1.3,
                       delay: 0.4,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.5,
                       options: .allowAnimatedContent,
                       animations: {
                        self.demoView.frame = CGRect(x: demoFrame.origin.x - 180,
                                                     y: 0,
                                                     width: demoFrame.width,
                                                     height: demoFrame.height)
                        self.demoRemoveView.frame = CGRect(x: demoRemoveFrame.origin.x - 80,
                                                           y: 0,
                                                           width: demoRemoveFrame.width,
                                                           height: demoRemoveFrame.height)
                        self.demoInviteView.frame = CGRect(x: demoInviteFrame.origin.x - 180,
                                                           y: 0,
                                                           width: demoInviteFrame.width,
                                                           height: demoInviteFrame.height)
        }) { (done) in
            UIView.animate(withDuration: 1.3,
                           delay: 3.0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 0.5,
                           options: .allowAnimatedContent,
                           animations: {
                            self.demoView.frame = CGRect(x: demoFrame.origin.x,
                                                         y: 0,
                                                         width: demoFrame.width,
                                                         height: demoFrame.height)
                            self.demoRemoveView.frame = CGRect(x: demoRemoveFrame.origin.x,
                                                               y: 0,
                                                               width: demoRemoveFrame.width,
                                                               height: demoRemoveFrame.height)
                            self.demoInviteView.frame = CGRect(x: demoInviteFrame.origin.x,
                                                               y: 0,
                                                               width: demoInviteFrame.width,
                                                               height: demoInviteFrame.height)
            }) { (done) in
                self.demoView.removeFromSuperview()
                self.demoInviteView.removeFromSuperview()
                self.demoRemoveView.removeFromSuperview()
                UserDefault.showTableViewSwipeDemo.setBoolValue(value: true)
            }
        }
    }
}
