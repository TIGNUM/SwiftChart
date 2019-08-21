//
//  MyDataScreenInteractor.swift
//  
//
//  Created by Simu Voicu-Mircea on 19/08/2019.
//  Copyright (c) 2019 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

final class MyDataScreenInteractor {

    // MARK: - Properties
    private let worker: MyDataScreenWorker
    private let presenter: MyDataScreenPresenterInterface

    // MARK: - Init
    init(worker: MyDataScreenWorker, presenter: MyDataScreenPresenterInterface) {
        self.worker = worker
        self.presenter = presenter        
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.present(for: worker.myDataSections())
        presenter.setupView()
    }
}

// MARK: - MyDataScreenInteractorInterface
extension MyDataScreenInteractor: MyDataScreenInteractorInterface {
    func presentMyDataExplanation() {
        
    }
    
    func presentMyDataSelection() {
        
    }
    
}
