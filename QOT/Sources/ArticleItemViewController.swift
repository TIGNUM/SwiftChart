//
//  ArticleItemViewController.swift
//  QOT
//
//  Created by karmic on 22.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Rswift

protocol ArticleItemViewControllerDelegate: class {
    func didTapClose(in viewController: UIViewController)
    func didTapPDFLink(_ title: String?, _ itemID: Int, _ url: URL, in viewController: UIViewController)
    func didTapLink(_ url: URL, in viewController: UIViewController)
    func didTapMedia(withURL url: URL, in viewController: UIViewController)
}
