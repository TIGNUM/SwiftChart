//
//  LearnStrategyViewController.swift
//  QOT
//
//  Created by karmic on 29/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol LearnStrategyViewDelegate: class {
    func didTapClose(in viewController: PrepareContentViewController)
    func didTapShare(in viewController: PrepareContentViewController)
    func didTapVideo(with localID: String, from view: UIView, in viewController: PrepareContentViewController)
}

final class LearnStrategyViewController: UITableViewController {

}
