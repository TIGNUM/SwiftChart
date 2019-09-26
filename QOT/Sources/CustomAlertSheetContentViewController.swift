//
//  CustomCancelAlertSheetContentViewController.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 26/09/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class CustomAlertSheetContentViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    private var titleText: String?
    private var isDestructive: Bool = false

    init(title: String, isDestructive: Bool) {
        super.init(nibName: R.nib.customAlertSheet.name, bundle: R.nib.customAlertSheet.bundle)
        self.titleText = title
        self.isDestructive = isDestructive
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeView.level1.apply(view)
        if isDestructive {
            ThemeText.customAlertDestructiveAction.apply(titleText, to: titleLabel)
        } else {
            ThemeText.customAlertAction.apply(titleText, to: titleLabel)
        }
    }
}
