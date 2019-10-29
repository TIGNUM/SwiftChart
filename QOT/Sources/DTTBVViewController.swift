//
//  DTTBVViewController.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTTBVViewController: DTViewController {

    // MARK: - Properties
    var tbvInteractor: DTTBVInteractorInterface?
    var tbvRouter: DTTBVRouter?
    private lazy var imagePickerController: ImagePickerController? = {
        return ImagePickerController(cropShape: .square,
                                     imageQuality: .medium,
                                     imageSize: .medium,
                                     adapter: ImagePickerControllerAdapter(self))
    }()

    // MARK: - Init
    init(configure: Configurator<DTTBVViewController>) {
        super.init(nibName: R.nib.dtViewController.name, bundle: R.nib.dtViewController.bundle)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - DTViewController
    override func didTapBinarySelection(_ answer: DTViewModel.Answer) {
        setSelectedAnswer(answer)
        if viewModel?.question.key == TBV.QuestionKey.Picture && answer.keys.contains(TBV.AnswerKey.UploadImage) {
            showImageSelectionAlert()
        } else {
            loadNextQuestion()
        }
    }

    override func didTapNext() {
        switch viewModel?.question.key {
        case TBV.QuestionKey.Home?:
            generateTBV()
        case TBV.QuestionKey.Review?:
            tbvRouter?.dismiss()
        default:
            //multi-select and OK buttons call the same 'setAnswerNeedsSelection' method, this always selects answer[0]
            setAnswerNeedsSelectionIfNoOtherAnswersAreSelectedAlready()
            loadNextQuestion()
        }
    }

    override func didTapClose() {
        super.didTapClose()
        RestartHelper.clearRestartRouteInfo()
    }

    override func didSelectAnswer(_ answer: DTViewModel.Answer) {
        setSelectedAnswer(answer)
        switch viewModel?.question.key {
        case TBV.QuestionKey.Instructions?:
            if let contentId = answer.targetId(.content) {
                router?.presentContent(contentId)
            }
            if let contentItemId = answer.targetId(.contentItem) {
                router?.playMediaItem(contentItemId)
            }
        default:
            break
        }
    }
}

// MARK: - Private
private extension DTTBVViewController {
    func generateTBV() {
        var selectedAnswers = interactor?.getSelectedAnswers() ?? []
        let answers = viewModel?.selectedAnswers ?? []
        let update = SelectedAnswer(question: viewModel?.question, answers: answers)
        selectedAnswers.append(update)
        tbvInteractor?.generateTBV(selectedAnswers: selectedAnswers,
                                   questionKeyWork: TBV.QuestionKey.Work,
                                   questionKeyHome: TBV.QuestionKey.Home) { [weak self] _ in
                                    self?.loadNextQuestion()
        }
    }

    func showImageSelectionAlert() {
        imagePickerController?.delegate = self
        imagePickerController?.show(in: self, deletable: false)
        RestartHelper.setRestartURLScheme(.toBeVision, options: [.edit: "image"])
    }
}

// MARK: - DTTBVViewControllerInterface
extension DTTBVViewController: DTTBVViewControllerInterface {}

// MARK: - ImagePickerControllerAdapterProtocol
extension DTTBVViewController: ImagePickerControllerAdapterProtocol {}

extension DTTBVViewController: ImagePickerControllerDelegate {
    func imagePickerController(_ imagePickerController: ImagePickerController, selectedImage image: UIImage) {
        loadNextQuestion()
        tbvInteractor?.saveTBVImage(image)
        self.imagePickerController = nil
        RestartHelper.clearRestartRouteInfo()
    }

    func cancelSelection() {
        RestartHelper.clearRestartRouteInfo()
    }
}
