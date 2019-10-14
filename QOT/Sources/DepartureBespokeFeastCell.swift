//
//  DepartureBespokeFeastCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.10.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class DepartureBespokeFeastCell: BaseDailyBriefCell {

    @IBOutlet private weak var bucketTitle: UILabel!
    @IBOutlet private weak var departureBespokeText: UILabel!
//    @IBOutlet private weak var departureImage: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    weak var delegate: DailyBriefViewControllerDelegate?
    private var departureBespokeFeastModel: DepartureBespokeFeastModel?
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var copyrightButton: UIButton!
    @IBOutlet weak var pictureWithCopyright: UIView!

    @IBOutlet weak var stackViewWidth: NSLayoutConstraint!
    @IBOutlet private weak var copyrightLabel: UIButton!
    @IBOutlet private weak var labelToTop: NSLayoutConstraint!
    @IBOutlet private weak var copyrightButtonHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addTitle(bucketTitle)
        skeletonManager.addSubtitle(departureBespokeText)
//        skeletonManager.addOtherView(departureImage)
        let urls: [URL?] = [URL(string: "https://image.shutterstock.com/image-photo/red-apple-on-white-background-600w-158989157.jpg"),
                           URL(string: "https://images-na.ssl-images-amazon.com/images/I/71EZa%2BhnqnL._AC_SL1225_.jpg"),
                           URL(string: "https://image.shutterstock.com/image-photo/carrot-isolated-on-white-background-600w-795704785.jpg")]
        var totalWidth: CGFloat = 0
        for url in urls {
            let addedView = DepartureBespokeFeastImageCell()
            addedView.picture.setImage(url: url) { (actualImage) in
                let width = (200 * (actualImage?.size.width ?? 1)) / ( actualImage?.size.height ?? 1 )
                addedView.imageWidth.constant = width
                totalWidth = totalWidth + width
                addedView.needsUpdateConstraints()
                self.stackViewWidth.constant = totalWidth
            }
            stackView.addArrangedSubview(addedView)
        }

    }

    func configure(with viewModel: DepartureBespokeFeastModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: bucketTitle)
        self.departureBespokeFeastModel = model
//        skeletonManager.addOtherView(departureImage)
        ThemeText.dailyBriefSubtitle.apply(model.text, to: departureBespokeText)
    }

    @IBAction func copyrightButtonPressed(_ sender: Any) {
        delegate?.presentCopyRight(copyrightURL: departureBespokeFeastModel?.copyright)
    }
}
