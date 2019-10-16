//
//  DepartureBespokeFeastImageCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.10.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class DepartureBespokeFeastImageCell: UIView {

    @IBOutlet weak var copyrightButton: UIButton!
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var picture: UIImageView!
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
}
