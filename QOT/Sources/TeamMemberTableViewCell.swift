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
    @IBOutlet private weak var joinedBorder: UIImageView!
    @IBOutlet private weak var pendingIcon: UIImageView!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var demoView: UIView!
    @IBOutlet private weak var demoJoinedIcon: UIImageView!
    @IBOutlet private weak var demoBorder: UIImageView!
    @IBOutlet private weak var demoEmailLabel: UILabel!
    @IBOutlet private weak var demoRemoveView: UIView!
    @IBOutlet private weak var demoInviteView: UIView!
    @IBOutlet private weak var pendingBorder: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundView = UIView(frame: bounds)
        self.selectedBackgroundView = UIView(frame: bounds)
        joinedIcon.tintColor = .white
        joinedBorder.tintColor = .white
        ThemeView.level2Selected.apply(selectedBackgroundView!)
        setDemoHidden(true)
    }

    func configure(memberEmail: String?, memberStatus: TeamMember.Status) {
        ThemeText.memberEmail.apply(memberEmail, to: emailLabel)
        ThemeText.memberEmail.apply(memberEmail, to: demoEmailLabel)
        ThemeView.level2.apply(backgroundView!)
        pendingIcon.isHidden = memberStatus == .joined
        joinedIcon.isHidden = memberStatus == .pending
        joinedBorder.isHidden = memberStatus == .pending
        pendingBorder.isHidden = memberStatus == .joined
    }
}

private extension TeamMemberTableViewCell {
    func setDemoHidden(_ isHidden: Bool) {
        demoView.isHidden = isHidden
        demoInviteView.isHidden = isHidden
        demoRemoveView.isHidden = isHidden
        demoJoinedIcon.isHidden = isHidden
        demoBorder.isHidden = isHidden
        demoEmailLabel.isHidden = isHidden
    }
}

extension TeamMemberTableViewCell {
    func showDemo() {
        guard UserDefault.showTableViewSwipeDemo.boolValue == false else { return }
        setDemoHidden(false)
        let demoOrigin = demoView.frame.origin
        let demoRemoveOrigin = demoRemoveView.frame.origin
        let demoInviteOrigin = demoInviteView.frame.origin

        UIView.animate(withDuration: 1.3,
                       delay: 0.4,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.5,
                       options: .allowAnimatedContent,
                       animations: {
                        self.demoView.frame.origin = CGPoint(x: demoOrigin.x - 180, y: 0)
                        self.demoRemoveView.frame.origin = CGPoint(x: demoRemoveOrigin.x - 80, y: 0)
                        self.demoInviteView.frame.origin = CGPoint(x: demoInviteOrigin.x - 180, y: 0)
                       }, completion: { _ in })

        UIView.animate(withDuration: 0.8,
                       delay: 3.0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.8,
                       options: .allowAnimatedContent,
                       animations: {
                        self.demoView.frame.origin = CGPoint(x: demoOrigin.x, y: 0)
                        self.demoRemoveView.frame.origin = CGPoint(x: demoRemoveOrigin.x, y: 0)
                        self.demoInviteView.frame.origin = CGPoint(x: demoInviteOrigin.x, y: 0)
                       }, completion: { _ in
                        self.demoView.removeFromSuperview()
                        self.demoInviteView.removeFromSuperview()
                        self.demoRemoveView.removeFromSuperview()
                        UserDefault.showTableViewSwipeDemo.setBoolValue(value: true)
                       })
    }
}
