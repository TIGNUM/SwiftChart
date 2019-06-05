//
//  BottomNavigationBarView.swift
//  QOT
//
//  Created by Ashish Maheshwari on 16.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol BottomNavigationBarViewProtocol: class {
    func willNavigateBack()
}

final class BottomNavigationBarView: UIView, NibLoadable {

    @objc enum NavigationType: Int {
        case push
        case modal
    }

    var navigationType: NavigationType = .push {
        didSet {
            setImage(for: navigationType)
        }
    }

    @IBOutlet private weak var button: UIButton!
    weak var delegate: BottomNavigationBarViewProtocol?

    // MARK: - Lifecycle

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setImage(for: navigationType)
        button.corner(radius: button.frame.width/2, borderColor: .accent30)
    }

    private func setImage(for value: NavigationType) {
        let image = value == .push ? R.image.arrowBack() : R.image.close()
        button.setImage(image, for: .normal)
    }

    @IBAction func navigationButtonAction(_ sender: Any) {
        delegate?.willNavigateBack()
    }
}
