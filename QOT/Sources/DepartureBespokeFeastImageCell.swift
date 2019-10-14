//
//  DepartureBespokeFeastImageCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.10.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class DepartureBespokeFeastImageCell: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var picture: UIImageView!
    var copyrightURL: String?
    @IBOutlet weak var copyrightButton: UIButton!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    //initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
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

    func configure(pictureURL: URL?, copyrightURL: URL?) {
        picture.setImage(url: pictureURL) { (actualImage) in
            let width = (200 * (actualImage?.size.width ?? 1)) / ( actualImage?.size.height ?? 1 )
            self.imageWidth.constant = width
            self.needsUpdateConstraints()
        }
    }
}
