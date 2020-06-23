//
//  containerShareViewController.swift
//  ShareExtension
//
//  Created by Anais Plancoulaine on 24.06.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit
import MobileCoreServices
import Social


@objc(ContainerShareViewController)

final class ContainerShareViewController: UIViewController {


    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height)
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.view.transform = CGAffineTransform.identity
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        let customizedViewController: UIViewController = UIStoryboard(name: "MainInterface", bundle: nil).instantiateViewController(withIdentifier: "CustomizedShareViewController") as UIViewController
        let navigationController = UINavigationController(rootViewController: customizedViewController)
        navigationController.navigationBar.barTintColor = .black
        addChild(navigationController)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/2),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        navigationController.view.frame = containerView.bounds
        containerView.addSubview(navigationController.view)
        navigationController.didMove(toParent: self)
    }


}
