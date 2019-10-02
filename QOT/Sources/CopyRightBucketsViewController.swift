//
//  CopyRightBucketsViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import SafariServices

class CopyRightBucketsViewController: BaseViewController, ScreenZLevelOverlay {

    @IBOutlet weak var copyrightButton: UIButton!
    var copyrightURL: String?

    convenience init(copyrightURL: String?) {
        self.init()
        self.copyrightURL = copyrightURL
    }

    @IBAction func copyrightClicked(_ sender: Any) {
        showSafariVC(for: copyrightURL ?? "")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.hideCopyrightView))
        self.view.addGestureRecognizer(gesture)
    }

    override func viewDidAppear(_ animated: Bool) {
        copyrightButton.setTitle("Content Copyright \n" + (copyrightURL ?? ""), for: .normal)
    }
    
    @objc func hideCopyrightView() {
        self.dismiss(animated: true, completion: nil)
    }

    func showSafariVC(for url: String) {
        guard let url = URL(string: url) else {
            // show invalid url
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}
