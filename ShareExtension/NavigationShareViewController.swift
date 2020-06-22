//
//  NavigationShareViewController.swift
//  ShareExtension
//
//  Created by Anais Plancoulaine on 19.06.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import UIKit

@objc(NavigationShareViewController)

class NavigationShareViewController: UINavigationController {

    init() {
        let viewController: UIViewController = UIStoryboard(name: "MainInterface", bundle: nil).instantiateViewController(withIdentifier: "CustomizedShareViewController") as UIViewController
        super.init(rootViewController: viewController)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar.barTintColor = .black
        self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height/2)
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.view.transform = CGAffineTransform.identity
        })
    }
}
