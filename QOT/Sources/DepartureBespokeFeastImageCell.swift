//
//  DepartureBespokeFeastImageCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.10.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import SafariServices

final class DepartureBespokeFeastImageCell: UIView {

    @IBOutlet weak var copyrightButton: UIButton!
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var picture: UIImageView!
    private var imageURL: URL?
    var copyrightURL: String?
    weak var delegate: DailyBriefViewControllerDelegate?
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    //initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    @IBAction func copyrightTapped(_ sender: Any) {
        delegate?.presentCopyRight(copyrightURL: copyrightURL)
    }

    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("DepartureBespokeFeastImageCell", owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
    }

    func configure(imageURL: URL?) {
        self.imageURL = imageURL
        let tap = UITapGestureRecognizer(target: self, action: #selector(openLink))
        picture.addGestureRecognizer(tap)
        picture.isUserInteractionEnabled = true
    }

    @objc func openLink(sender: UITapGestureRecognizer) {
        guard let url = URL(string: self.copyrightURL ?? "") else { return }
        let safariVC = SFSafariViewController(url: url)
        delegate?.presentSafari(safariVC)
    }
}
