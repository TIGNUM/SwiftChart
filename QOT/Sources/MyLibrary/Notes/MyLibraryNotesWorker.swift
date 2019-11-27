//
//  MyLibraryNotesWorker.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 11/07/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyLibraryNotesWorker {

    enum NotesError: Swift.Error {
        case missingNote
    }

    // MARK: - Properties

    private let service = UserStorageService.main
    private let noteId: String?
    private var note: QDMUserStorage?
    private var noteCompletion: ((String?) -> Void)?

    // MARK: - Init

    init(noteId: String?) {
        self.noteId = noteId
        if let noteId = noteId {
            service.getUserStorages(for: .NOTE) { [weak self] (storages, _, _) in
                self?.note = storages?.first(where: { $0.qotId == noteId })
                if let completion = self?.noteCompletion {
                    completion(self?.note?.note)
                    self?.noteCompletion = nil
                }
            }
        }
    }

    lazy var placeholderText: String = {
        return AppTextService.get(AppTextKey.my_qot_my_library_notes_note_section_body_placeholder)
    }()

    // Cannot be lazy as note fetching sometimes happens after `viewDidLoad`
    var text: String? {
        return note?.note
    }

    lazy var saveTitle: String = {
        return AppTextService.get(AppTextKey.my_qot_my_library_notes_note_section_footer_button_save)
    }()

    lazy var dismissAlertTitle: String = {
        return AppTextService.get(AppTextKey.my_qot_my_library_notes_note_alert_continue_without_saving_title)
    }()

    lazy var dismissAlertMessage: String = {
        return AppTextService.get(AppTextKey.my_qot_my_library_notes_note_alert_continue_without_saving_body)
    }()

    lazy var cancelTitle: String = {
       return AppTextService.get(AppTextKey.my_qot_my_library_notes_note_alert_continue_without_saving_button_cancel)
    }()

    lazy var leaveButtonTitle: String = {
        return AppTextService.get(AppTextKey.my_qot_my_library_notes_note_alert_continue_without_saving_button_continue)
    }()

    lazy var removeAlertTitle: String = {
       return AppTextService.get(AppTextKey.my_qot_my_library_notes_alert_delete_note_title)
    }()

    lazy var removeAlertMessage: String = {
        return AppTextService.get(AppTextKey.my_qot_my_library_notes_alert_delete_note_body)
    }()

    lazy var removeButtonTitle: String = {
        return AppTextService.get(AppTextKey.my_qot_my_library_notes_alert_delete_note_button_continue)
    }()

    lazy var isExistingNote: Bool = {
        return noteId != nil
    }()

    func getText(_ completion: @escaping ((String?) -> Void)) {
        if noteId == nil {
            completion(nil)
        } else if let note = note {
            completion(note.note)
        } else {
            noteCompletion = completion
        }
    }

    func saveText(_ text: String?, completion: @escaping (QDMUserStorage?, Error?) -> Void) {
        if var note = note {
            note.note = text
            service.updateUserStorage(note, completion)
        } else {
            service.addNote(text, completion)
        }
    }

    func deleteNote(completion: @escaping (Error?) -> Void) {
        guard let note = note else {
            completion(NotesError.missingNote)
            return
        }
        service.deleteUserStorage(note, completion)
    }
}
