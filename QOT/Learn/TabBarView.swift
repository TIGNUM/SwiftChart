//
//  TabBarView.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 4/3/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage
class TabBarView: UIView {
    
    var titles: [String] = ["Full", "Short"]
    
    fileprivate lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        return view
    }()
    
    fileprivate lazy var buttons: [UIButton] = {
        return self.titles.enumerated().map { (index, title) in
            let button = UIButton(type: .custom)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = Font.TabBarController.buttonTitle
            button.backgroundColor = .clear
            button.setTitleColor(UIColor.white.withAlphaComponent(0.4), for: .normal)
            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            button.tag = index
            return button
        }
    }()
    
    override func awakeFromNib() {
        self.backgroundColor = .red
       print("hello")
        setupHierachy()
        setupLayout()
    }
    
    @objc private func buttonPressed(_:UIButton) {
        
    }
}

private extension TabBarView {
    
    func setupHierachy() {
        addSubview(stackView)
    }
    
    func setupLayout() {
        stackView.topAnchor == topAnchor
        stackView.bottomAnchor == bottomAnchor
        stackView.leftAnchor == leftAnchor
        stackView.rightAnchor == rightAnchor
        
        heightAnchor == 64
    }
}
