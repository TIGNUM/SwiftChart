//
//  DownloadTableViewCell.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 05/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class DownloadTableViewCell: BaseMyLibraryTableViewCell, Dequeueable {
    @IBOutlet private weak var activityIcon: UIImageView!
    @IBOutlet private weak var activityView: GradientArcView!

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addTitle(contentTitle)
        skeletonManager.addSubtitle(infoText)
        skeletonManager.addOtherView(icon)
        skeletonManager.addOtherView(activityIcon)
    }

    func setStatus(_ status: MyLibraryCellViewModel.DownloadStatus) {
        super.configure()
        activityIcon.image = nil
        activityView.isHidden = true
        activityView.stopRotating()

        if status == .waiting {
            activityIcon.image = R.image.my_library_download()
        } else if status == .downloading {
            activityIcon.image = R.image.my_library_stop()
            activityView.isHidden = false
            activityView.startRotating()
        }
    }
}
