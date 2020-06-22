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

     required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
     }

    override func viewDidLoad() {
           super.viewDidLoad()
       }

    override func loadView() {
        super.loadView()
        self.setUpView()
     }

   func setUpView() {
       let viewFrame = CGRect(x: 0, y: 0, width: 150, height: 300)
       self.view = UIView(frame: viewFrame)
      self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)

       let width: CGFloat = UIScreen.main.bounds.size.width
       let height: CGFloat = UIScreen.main.bounds.size.height
       let newView = UIView(frame: CGRect(x: (width * 0.10), y: (height * 0.25), width: (width * 0.75), height: (height / 2)))
       newView.backgroundColor = UIColor.yellow
       self.view.addSubview(newView)
   }

}
