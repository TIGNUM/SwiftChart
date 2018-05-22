//
//  PartnerEditInterface.swift
//  QOT
//
//  Created by karmic on 12.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

protocol PartnerEditViewControllerInterface: class {
    func setupView(partner: Partners.Partner)
    func reload(partner: Partners.Partner)
}

protocol PartnerEditPresenterInterface {
    func setupView(partner: Partners.Partner)
    func reload(partner: Partners.Partner)
}

protocol PartnerEditInteractorInterface: Interactor {
    func didTapCancel()
    func didTapSave(partner: Partners.Partner?, image: UIImage?)
    func showImagePicker()
    func update(partner: Partners.Partner?)    
}

protocol PartnerEditRouterInterface {
    func dismiss()
    func showAlert(_ alert: AlertType)
    func showImagePicker()
}
