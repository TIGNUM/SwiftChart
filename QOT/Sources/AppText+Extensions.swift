//
//  AppText+Extensions.swift
//  QOT
//
//  Created by Srikanth Roopa on 08.10.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal
/* https://docs.google.com/spreadsheets/d/1WovNfItN4vnL8LXGHKsli-U-RKvU7kAhPstaYrStaGU/edit#gid=0
 Instructions to copy the keys from the spreadsheet
 1. Delete all lines below public extension until the end }
 2. Copy spreadsheet column 'O' into the public extension.
 3. Ignore the blank lines
 */

// swiftlint:disable vertical_whitespace
public extension AppTextKey {
    static let daily_brief_good_to_know_title = AppTextKey("daily_brief.good_to_know.title")









































    static let my_qot_my_profile_app_settings_synced_calendars_view_this_device_title = AppTextKey("my_qot.my_profile.app_settings.synced_calendars.view.this_device_title")
    static let my_qot_my_profile_app_settings_synced_calendars_view_other_devices_title = AppTextKey("my_qot.my_profile.app_settings.synced_calendars.view.other_devices_title")














    static let my_qot_tbv_view_title = AppTextKey("my_qot.tbv.view.title")
    static let my_qot_tbv_null_state_view_title = AppTextKey("my_qot.tbv.null_state.view.title")
    static let my_qot_tbv_navigation_bar_view_title = AppTextKey("my_qot.tbv.navigation_bar.view.title")
    static let my_qot_tbv_alert_update_alert_title = AppTextKey("my_qot.tbv.alert.update_alert_title")
    static let my_qot_tbv_alert_update_alert_body = AppTextKey("my_qot.tbv.alert.update_alert_body")
    static let my_qot_tbv_alert_edit_button = AppTextKey("my_qot.tbv.alert.edit_button")
    static let my_qot_tbv_alert_create_button = AppTextKey("my_qot.tbv.alert.create_button")
    static let my_qot_tbv_view_create_button = AppTextKey("my_qot.tbv.view.create_button")
    static let my_qot_account_settings_alert_logout_button = AppTextKey("my_qot.account_settings.alert.logout_button")
    static let my_qot_account_settings_view_logout_button = AppTextKey("my_qot.account_settings.view.logout_button")
    static let my_qot_profile_settings_view_logout_button = AppTextKey("my_qot.profile_settings.view.logout_button")
    static let payment_reminder_view_logout_button = AppTextKey("payment_reminder.view.logout_button")
    static let subscription_reminder_view_logout_button = AppTextKey("subscription_reminder.view.logout_button")













































































































































    static let startup_alert_database_error_title = AppTextKey("startup.alert.database_error_title")
    static let startup_alert_database_error_body = AppTextKey("startup.alert.database_error_body")
    static let my_qot_my_to_be_vision_alert_camera_not_available_title = AppTextKey("my_qot.my_to_be_vision.alert.camera_not_available_title")
    static let my_qot_my_to_be_vision_alert_camera_not_available_body = AppTextKey("my_qot.my_to_be_vision.alert.camera_not_available_body")







    static let alert_alert_no_network_connection_title = AppTextKey("alert.alert.no_network_connection_title")
    static let alert_alert_no_network_connection_message_title = AppTextKey("alert.alert.no_network_connection_message_title")
    static let alert_alert_no_network_connection_file = AppTextKey("alert.alert.no_network_connection_file")

    static let alert_alert_edit_preparation_name_title = AppTextKey("alert.alert.edit_preparation_name_title")
    static let alert_alert_unknown_title = AppTextKey("alert.alert.unknown_title")
    static let alert_alert_unknown_message_title = AppTextKey("alert.alert.unknown_message_title")
    static let alert_alert_unknown_message_type_title = AppTextKey("alert.alert.unknown_message_type_title")
    static let alert_alert_ok_button = AppTextKey("alert.alert.ok_button")
    static let alert_alert_cancel_button = AppTextKey("alert.alert.cancel_button")
    static let alert_alert_continue_button = AppTextKey("alert.alert.continue_button")
    static let alert_alert_save_button = AppTextKey("alert.alert.save_button")
    static let alert_alert_level5_saved_button = AppTextKey("alert.alert.level5_saved_button")
    static let alert_alert_level5_alert_title = AppTextKey("alert.alert.level5_alert_title")
    static let alert_alert_level5_alert_body = AppTextKey("alert.alert.level5_alert_body")
    static let alert_alert_copyright_text_title = AppTextKey("alert.alert.copyright_text_title")
    static let alert_alert_save_continue_button = AppTextKey("alert.alert.save_continue_button")
    static let alert_alert_settings_title = AppTextKey("alert.alert.settings_title")
    static let alert_alert_open_settings_title = AppTextKey("alert.alert.open_settings_title")




    static let alert_alert_email_not_found_title = AppTextKey("alert.alert.email_not_found_title")
    static let alert_alert_email_not_found_body = AppTextKey("alert.alert.email_not_found_body")
    static let alert_alert_camera_not_available_body = AppTextKey("alert.alert.camera_not_available_body")
    static let my_qot_my_to_be_vision_alert_camera_not_granted_body = AppTextKey("my_qot.my_to_be_vision.alert.camera_not_granted_body")
    static let my_qot_my_to_be_vision_alert_photo_not_granted_body = AppTextKey("my_qot.my_to_be_vision.alert.photo_not_granted_body")


    static let alert_alert_reset_password_title = AppTextKey("alert.alert.reset_password_title")
    static let alert_alert_reset_password_body = AppTextKey("alert.alert.reset_password_body")



    static let alert_alert_could_not_send_email_body = AppTextKey("alert.alert.could_not_send_email_body")
    static let alert_alert_patner_invite_title = AppTextKey("alert.alert.patner_invite_title")
    static let alert_alert_patner_invite_body = AppTextKey("alert.alert.patner_invite_body")




    static let alert_alert_edit_vision_button = AppTextKey("alert.alert.edit_vision_button")
    static let alert_alert_create_vision_button = AppTextKey("alert.alert.create_vision_button")
    static let my_qot_support_alert_email_not_setup_body = AppTextKey("my_qot.support.alert.email_not_setup_body")
    static let alert_alert_logout_body = AppTextKey("alert.alert.logout_body")
    static let alert_alert_change_permission_title = AppTextKey("alert.alert.change_permission_title")
    static let alert_alert_change_permission_body = AppTextKey("alert.alert.change_permission_body")
    static let alert_alert_calendar_not_synced_title = AppTextKey("alert.alert.calendar_not_synced_title")

    static let alert_alert_calendar_not_synced_body = AppTextKey("alert.alert.calendar_not_synced_body")

    static let alert_alert_change_notifications_title = AppTextKey("alert.alert.change_notifications_title")
    static let alert_alert_change_notifications_body = AppTextKey("alert.alert.change_notifications_body")
    static let alert_alert_sign_in_missing_connection_body = AppTextKey("alert.alert.sign_in_missing_connection_body")
    static let alert_alert_use_mobile_data_title = AppTextKey("alert.alert.use_mobile_data_title")
    static let alert_alert_use_mobile_data_body = AppTextKey("alert.alert.use_mobile_data_body")
    static let alert_alert_title_ok_button = AppTextKey("alert.alert.title_ok_button")


    static let my_qot_my_to_be_vision_edit_take_a_picture_title = AppTextKey("my_qot.my_to_be_vision.edit.take_a_picture_title")
    static let my_qot_my_to_be_vision_edit_choose_picture_title = AppTextKey("my_qot.my_to_be_vision.edit.choose_picture_title")
    static let my_qot_my_to_be_vision_edit_delete_photo_title = AppTextKey("my_qot.my_to_be_vision.edit.delete_photo_title")
    static let my_qot_my_to_be_vision_edit_cancel_title = AppTextKey("my_qot.my_to_be_vision.edit.cancel_title")










    static let search_edit_all_title = AppTextKey("search.edit.all_title")
    static let search_edit_audio_title = AppTextKey("search.edit.audio_title")
    static let search_edit_video_title = AppTextKey("search.edit.video_title")
    static let search_edit_read_title = AppTextKey("search.edit.read_title")
    static let search_edit_listen_title = AppTextKey("search.edit.listen_title")
    static let search_edit_watch_title = AppTextKey("search.edit.watch_title")
    static let search_edit_tools_title = AppTextKey("search.edit.tools_title")
    static let search_view_placeholder_title = AppTextKey("search.view.placeholder_title")








    static let my_qot_my_plans_view_title = AppTextKey("my_qot.my_plans.view.title")











    static let my_qot_view_my_tbv_more_than_subtitle = AppTextKey("my_qot.view.my_tbv_more_than_subtitle")
    static let my_qot_view_my_tbv_more_months_since_subtitle = AppTextKey("my_qot.view.my_tbv_more_months_since_subtitle")
    static let my_qot_view_my_tbv_less_than_subtitle = AppTextKey("my_qot.view.my_tbv_less_than_subtitle")
    static let my_qot_view_my_tbv_no_vision_subtitle = AppTextKey("my_qot.view.my_tbv_no_vision_subtitle")
    static let my_qot_view_my_data_impact_subtitle = AppTextKey("my_qot.view.my_data_impact_subtitle")











    static let audio_view_download_button = AppTextKey("audio.view.download_button")
    static let audio_view_waiting_button = AppTextKey("audio.view.waiting_button")
    static let audio_view_downloading_button = AppTextKey("audio.view.downloading_button")
    static let audio_view_downloaded_button = AppTextKey("audio.view.downloaded_button")

    static let video_view_download_button = AppTextKey("video.view.download_button")
    static let video_view_downloading_button = AppTextKey("video.view.downloading_button")
    static let video_view_downloaded_button = AppTextKey("video.view.downloaded_button")










    static let daily_brief_daily_checkin_view_hours_subtitle = AppTextKey("daily_brief.daily_checkin.view.hours_subtitle")
    static let daily_brief_daily_checkin_vew_hours_more_subtitle = AppTextKey("daily_brief.daily_checkin.vew.hours_more_subtitle")



    static let my_qot_my_sprints_my_sprint_details_view_sprint_tasks_title = AppTextKey("my_qot.my_sprints.my_sprint_details.view.sprint_tasks_title")
    static let my_qot_my_sprints_my_sprint_details_view_my_plan_title = AppTextKey("my_qot.my_sprints.my_sprint_details.view.my_plan_title")
    static let my_qot_my_sprints_my_sprint_details_view_my_notes_title = AppTextKey("my_qot.my_sprints.my_sprint_details.view.my_notes_title")
    static let my_qot_my_sprints_my_sprint_details_view_highlights_title = AppTextKey("my_qot.my_sprints.my_sprint_details.view.highlights_title")
    static let my_qot_my_sprints_my_sprint_details_view_strategies_title = AppTextKey("my_qot.my_sprints.my_sprint_details.view.strategies_title")
    static let my_qot_my_sprints_my_sprint_details_view_benefits_title = AppTextKey("my_qot.my_sprints.my_sprint_details.view.benefits_title")
    static let my_qot_my_sprints_my_sprint_details_view_upcoming_body = AppTextKey("my_qot.my_sprints.my_sprint_details.view.upcoming_body")
    static let my_qot_my_sprints_my_sprint_details_view_active_body = AppTextKey("my_qot.my_sprints.my_sprint_details.view.active_body")
    static let my_qot_my_sprints_my_sprint_details_view_notes_body = AppTextKey("my_qot.my_sprints.my_sprint_details.view.notes_body")
    static let my_qot_my_sprints_my_sprint_details_view_takeaways_button = AppTextKey("my_qot.my_sprints.my_sprint_details.view.takeaways_button")


    static let my_qot_my_sprints_my_sprint_details_view_start_sprint_button = AppTextKey("my_qot.my_sprints.my_sprint_details.view.start_sprint_button")

















    static let daily_brief_daily_checkin_empty_start_your_dc_in_title = AppTextKey("daily_brief.daily_checkin.empty.start_your_dc_in_title")
    static let daily_brief_daily_checkin_view_explore_your_score_title = AppTextKey("daily_brief.daily_checkin.view.explore_your_score_title")





    static let login_view_title = AppTextKey("login.view.title")
    static let login_view_your_email_title = AppTextKey("login.view.your_email_title")
    static let login_view_email_description_title = AppTextKey("login.view.email_description_title")
    static let login_view_email_error_title = AppTextKey("login.view.email_error_title")
    static let login_view_user_doesnt_exist_title = AppTextKey("login.view.user_doesnt_exist_title")
    static let login_view_generic_error_title = AppTextKey("login.view.generic_error_title")
    static let login_view_pre_code_title = AppTextKey("login.view.pre_code_title")
    static let login_view_code_description_title = AppTextKey("login.view.code_description_title")
    static let login_view_code_error_title = AppTextKey("login.view.code_error_title")
    static let login_view_button_gethelp = AppTextKey("login.view.button_gethelp")
    static let login_view_button_resend_code = AppTextKey("login.view.button_resend_code")

    static let create_info_view_button_create_account = AppTextKey("create_info.view.button_create_account")
    static let create_info_view_description_title = AppTextKey("create_info.view.description_title")

    static let create_account_email_verification_view_title = AppTextKey("create_account.email_verification.view.title")
    static let create_account_email_verification_view_email_placeholder_title = AppTextKey("create_account.email_verification.view.email_placeholder_title")
    static let create_account_email_verification_view_button_next = AppTextKey("create_account.email_verification.view.button_next")
    static let create_account_email_verification_view_email_error_title = AppTextKey("create_account.email_verification.view.email_error_title")
    static let create_account_email_verification_view_existing_email_error_title = AppTextKey("create_account.email_verification.view.existing_email_error_title")
    static let create_account_email_verification_view_existing_email_error_description = AppTextKey("create_account.email_verification.view.existing_email_error_description")
    static let create_account_email_verification_view_unable_to_register_error = AppTextKey("create_account.email_verification.view.unable_to_register_error")
    static let create_account_email_verification_view_button_yes = AppTextKey("create_account.email_verification.view.button_yes")
    static let create_account_email_verification_view_button_no = AppTextKey("create_account.email_verification.view.button_no")

    static let create_account_code_verification_view_title = AppTextKey("create_account.code_verification.view.title")
    static let create_account_code_verification_view_description_title = AppTextKey("create_account.code_verification.view.description_title")
    static let create_account_code_verification_view_code_title = AppTextKey("create_account.code_verification.view.code_title")
    static let create_account_code_verification_view_disclaimer_error_title = AppTextKey("create_account.code_verification.view.disclaimer_error_title")
    static let create_account_code_verification_view_disclaimer_title = AppTextKey("create_account.code_verification.view.disclaimer_title")
    static let create_account_code_verification_view_disclaimer_terms_placeholder_title = AppTextKey("create_account.code_verification.view.disclaimer_terms_placeholder_title")
    static let create_account_code_verification_view_disclaimer_privacy_placeholder_title = AppTextKey("create_account.code_verification.view.disclaimer_privacy_placeholder_title")
    static let create_account_code_verification_view_code_info_title = AppTextKey("create_account.code_verification.view.code_info_title")
    static let create_account_code_verification_view_change_email_title = AppTextKey("create_account.code_verification.view.change_email_title")
    static let create_account_code_verification_view_send_again_title = AppTextKey("create_account.code_verification.view.send_again_title")
    static let create_account_code_verification_view_help_title = AppTextKey("create_account.code_verification.view.help_title")
    static let create_account_code_verification_view_code_error_title = AppTextKey("create_account.code_verification.view.code_error_title")
    static let create_account_code_verification_view_send_code_error_title = AppTextKey("create_account.code_verification.view.send_code_error_title")

    static let create_account_user_name_view_title = AppTextKey("create_account.user_name.view.title")
    static let create_account_user_name_view_first_name_title = AppTextKey("create_account.user_name.view.first_name_title")
    static let create_account_user_name_view_last_name_title = AppTextKey("create_account.user_name.view.last_name_title")
    static let create_account_user_name_view_mandatory_title = AppTextKey("create_account.user_name.view.mandatory_title")
    static let create_account_user_name_view_next_title = AppTextKey("create_account.user_name.view.next_title")

    static let create_account_birth_year_view_title = AppTextKey("create_account.birth_year.view.title")
    static let create_account_birth_year_view_placeholder_title = AppTextKey("create_account.birth_year.view.placeholder_title")
    static let create_account_birth_year_view_description_title = AppTextKey("create_account.birth_year.view.description_title")
    static let create_account_birth_year_view_restriction_title = AppTextKey("create_account.birth_year.view.restriction_title")
    static let create_account_birth_year_view_next_title = AppTextKey("create_account.birth_year.view.next_title")
    static let create_account_birth_year_view_create_account_error = AppTextKey("create_account.birth_year.view.create_account_error")

    static let notification_permission_view_title = AppTextKey("notification_permission.view.title")
    static let notification_permission_view_description = AppTextKey("notification_permission.view.description")
    static let notification_permission_view_button_skip = AppTextKey("notification_permission.view.button_skip")
    static let notification_permission_view_button_allow = AppTextKey("notification_permission.view.button_allow")
    static let notification_permission_view_alert_message_title = AppTextKey("notification_permission.view.alert_message_title")
    static let notification_permission_view_alert_settings = AppTextKey("notification_permission.view.alert_settings")
    static let notification_permission_view_alert_skip = AppTextKey("notification_permission.view.alert_skip")

    static let track_info_view_title = AppTextKey("track_info.view.title")
    static let track_info_view_message_title = AppTextKey("track_info.view.message_title")
    static let track_info_view_button_fast_track_title = AppTextKey("track_info.view.button_fast_track_title")
    static let track_info_view_button_guided_track_title = AppTextKey("track_info.view.button_guided_track_title")

    static let know_view_title = AppTextKey("know.view.title")
    static let daily_brief_view_title = AppTextKey("daily_brief.view.title")
    static let my_qot_view_title = AppTextKey("my_qot.view.title")

    static let my_qot_my_preps_event_preps_view_subtitle = AppTextKey("my_qot.my_preps.event_preps.view.subtitle")
    static let my_qot_my_preps_event_preps_view_body = AppTextKey("my_qot.my_preps.event_preps.view.body")
    static let my_qot_my_preps_mindset_shifts_view_subtitle = AppTextKey("my_qot.my_preps.mindset_shifts.view.subtitle")
    static let my_qot_my_preps_mindset_shifts_view_body = AppTextKey("my_qot.my_preps.mindset_shifts.view.body")
    static let my_qot_my_preps_recovery_plans_view_subtitle = AppTextKey("my_qot.my_preps.recovery_plans.view.subtitle")
    static let my_qot_my_preps_recovery_plans_view_body = AppTextKey("my_qot.my_preps.recovery_plans.view.body")










    static let my_qot_my_library_notes_view_add_button = AppTextKey("my_qot.my_library.notes.view.add_button")
    static let my_qot_my_library_all_view_title = AppTextKey("my_qot.my_library.all.view.title")
    static let my_qot_my_library_bookmarks_view_title = AppTextKey("my_qot.my_library.bookmarks.view.title")
    static let my_qot_my_library_downloads_view_title = AppTextKey("my_qot.my_library.downloads.view.title")
    static let my_qot_my_library_links_view_title = AppTextKey("my_qot.my_library.links.view.title")
    static let my_qot_my_library_notes_view_title = AppTextKey("my_qot.my_library.notes.view.title")
    static let my_qot_my_library_all_edit_title = AppTextKey("my_qot.my_library.all.edit.title")
    static let my_qot_my_library_bookmarks_edit_tille = AppTextKey("my_qot.my_library.bookmarks.edit.tille")
    static let my_qot_my_library_downloads_edit_title = AppTextKey("my_qot.my_library.downloads.edit.title")
    static let my_qot_my_library_links_edit_title = AppTextKey("my_qot.my_library.links.edit.title")
    static let my_qot_my_library_notes_edit_title = AppTextKey("my_qot.my_library.notes.edit.title")



    static let my_qot_my_library_all_alert_title = AppTextKey("my_qot.my_library.all.alert.title")
    static let my_qot_my_library_bookmarks_alert_title = AppTextKey("my_qot.my_library.bookmarks.alert.title")
    static let my_qot_my_library_downloads_alert_title = AppTextKey("my_qot.my_library.downloads.alert.title")
    static let my_qot_my_library_links_alert_title = AppTextKey("my_qot.my_library.links.alert.title")
    static let my_qot_my_library_notes_alert_title = AppTextKey("my_qot.my_library.notes.alert.title")
    static let my_qot_my_library_all_alert_subtitle = AppTextKey("my_qot.my_library.all.alert.subtitle")
    static let my_qot_my_library_bookmarks_alert_subtitle = AppTextKey("my_qot.my_library.bookmarks.alert.subtitle")
    static let my_qot_my_library_downloads_alert_subtitle = AppTextKey("my_qot.my_library.downloads.alert.subtitle")
    static let my_qot_my_library_links_alert_subtitle = AppTextKey("my_qot.my_library.links.alert.subtitle")
    static let my_qot_my_library_notes_alert_subtitle = AppTextKey("my_qot.my_library.notes.alert.subtitle")
    static let my_qot_my_library_notes_view_subtitle2 = AppTextKey("my_qot.my_library.notes.view.subtitle2")
    static let my_qot_my_library_media_view_downloading_title = AppTextKey("my_qot.my_library_media.view.downloading_title")
    static let my_qot_my_library_media_view_waiting_title = AppTextKey("my_qot.my_library_media.view.waiting_title")




    static let my_qot_my_library_notes_edit_button = AppTextKey("my_qot.my_library.notes.edit.button")
    static let my_qot_my_library_notes_add_view_alert_title = AppTextKey("my_qot.my_library.notes.add.view.alert_title")
    static let my_qot_my_library_notes_add_view_alert_subtitle = AppTextKey("my_qot.my_library.notes.add.view.alert_subtitle")
    static let my_qot_my_library_notes_add_view_alert_button1 = AppTextKey("my_qot.my_library.notes.add.view.alert_button1")
    static let my_qot_my_library_notes_add_view_alert_button2 = AppTextKey("my_qot.my_library.notes.add.view.alert_button2")
    static let my_qot_my_library_notes_edit_alert_title = AppTextKey("my_qot.my_library.notes.edit.alert_title")
    static let my_qot_my_library_notes_edit_alert_message = AppTextKey("my_qot.my_library.notes.edit.alert_message")
    static let my_qot_my_library_notes_edit_alert_cancel = AppTextKey("my_qot.my_library.notes.edit.alert_cancel")
    static let my_qot_my_library_notes_edit_alert_remove = AppTextKey("my_qot.my_library.notes.edit.alert_remove")

    static let my_qot_my_sprints_empty_title = AppTextKey("my_qot.my_sprints.empty.title")
    static let my_qot_my_sprints_edit_title = AppTextKey("my_qot.my_sprints.edit.title")
    static let my_qot_my_sprints_view_sprint_plan_title = AppTextKey("my_qot.my_sprints.view.sprint_plan_title")
    static let my_qot_my_sprints_view_complete_title = AppTextKey("my_qot.my_sprints.view.complete_title")


    static let my_qot_my_sprints_empty_subtitle = AppTextKey("my_qot.my_sprints.empty.subtitle")
    static let my_qot_my_sprints_empty_body = AppTextKey("my_qot.my_sprints.empty.body")
    static let my_qot_my_sprints_view_active_title = AppTextKey("my_qot.my_sprints.view.active_title")
    static let my_qot_my_sprints_view_upcoming_title = AppTextKey("my_qot.my_sprints.view.upcoming_title")
    static let my_qot_my_sprints_view_paused_title = AppTextKey("my_qot.my_sprints.view.paused_title")
    static let my_qot_my_sprints_view_completed_at_title = AppTextKey("my_qot.my_sprints.view.completed_at_title")


    static let my_qot_tbv_empty_auto_generate_button = AppTextKey("my_qot.tbv.empty.auto_generate_button")
    static let my_qot_tbv_empty_write_button = AppTextKey("my_qot.tbv.empty.write_button")
    static let my_qot_tbv_view_updated_comment_subtitle = AppTextKey("my_qot.tbv.view.updated_comment_subtitle")
    static let my_qot_tbv_view_rated_comment_subtitle = AppTextKey("my_qot.tbv.view.rated_comment_subtitle")




    static let my_qot_tbv_tbv_tracker_view_your_last_rating_title = AppTextKey("my_qot.tbv.tbv_tracker.view.your_last_rating_title")























































































    static let my_qot_my_data_view_ir_title = AppTextKey("my_qot.my_data.view.ir_title")
    static let my_qot_my_data_view_heatmap_title = AppTextKey("my_qot.my_data.view.heatmap_title")
    static let my_qot_my_data_view_ir_body = AppTextKey("my_qot.my_data.view.ir_body")
    static let my_qot_my_data_view_heatmap_body = AppTextKey("my_qot.my_data.view.heatmap_body")
    static let my_qot_my_data_view_ir_button = AppTextKey("my_qot.my_data.view.ir_button")
    static let my_qot_my_data_view_ir_5_day_button = AppTextKey("my_qot.my_data.view.ir_5_day_button")
    static let my_qot_my_data_view_ir_average_title = AppTextKey("my_qot.my_data.view.ir_average_title")

    static let my_qot_my_data_view_heatmap_high_title = AppTextKey("my_qot.my_data.view.heatmap_high_title")
    static let my_qot_my_data_view_heatmap_low_title = AppTextKey("my_qot.my_data.view.heatmap_low_title")



    static let my_qot_my_data_edit_sql_title = AppTextKey("my_qot.my_data.edit.sql_title")
    static let my_qot_my_data_edit_sqn_title = AppTextKey("my_qot.my_data.edit.sqn_title")
    static let my_qot_my_data_edit_ten_dl_title = AppTextKey("my_qot.my_data.edit.ten_dl_title")
    static let my_qot_my_data_edit_five_drr_title = AppTextKey("my_qot.my_data.edit.five_drr_title")
    static let my_qot_my_data_edit_five_drl_title = AppTextKey("my_qot.my_data.edit.five_drl_title")
    static let my_qot_my_data_edit_five_dir_title = AppTextKey("my_qot.my_data.edit.five_dir_title")
    static let my_qot_my_data_edit_ir_title = AppTextKey("my_qot.my_data.edit.ir_title")

    static let my_qot_my_data_info_sql_title = AppTextKey("my_qot.my_data.info.sql_title")
    static let my_qot_my_data_info_sqn_title = AppTextKey("my_qot.my_data.info.sqn_title")
    static let my_qot_my_data_info_ten_dl_title = AppTextKey("my_qot.my_data.info.ten_dl_title")
    static let my_qot_my_data_info_five_drr_title = AppTextKey("my_qot.my_data.info.five_drr_title")
    static let my_qot_my_data_info_five_drl_title = AppTextKey("my_qot.my_data.info.five_drl_title")
    static let my_qot_my_data_info_five_dir_title = AppTextKey("my_qot.my_data.info.five_dir_title")
    static let my_qot_my_data_info_ir_title = AppTextKey("my_qot.my_data.info.ir_title")

    static let my_qot_my_data_info_sql_subtitle = AppTextKey("my_qot.my_data.info.sql_subtitle")
    static let my_qot_my_data_info_sqn_subtitle = AppTextKey("my_qot.my_data.info.sqn_subtitle")
    static let my_qot_my_data_info_ten_dl_subtitle = AppTextKey("my_qot.my_data.info.ten_dl_subtitle")
    static let my_qot_my_data_info_five_drr_subtitle = AppTextKey("my_qot.my_data.info.five_drr_subtitle")
    static let my_qot_my_data_info_five_drl_subtitle = AppTextKey("my_qot.my_data.info.five_drl_subtitle")
    static let my_qot_my_data_info_five_dir_subtitle = AppTextKey("my_qot.my_data.info.five_dir_subtitle")
    static let my_qot_my_data_info_ir_subtitle = AppTextKey("my_qot.my_data.info.ir_subtitle")








    static let search_view_self_image_subtitle = AppTextKey("search.view.self_image_subtitle")
    static let search_view_daily_prep_subtitle = AppTextKey("search.view.daily_prep_subtitle")
    static let search_view_no_excuse_subtitle = AppTextKey("search.view.no_excuse_subtitle")
    static let search_view_build_capacity_subtitle = AppTextKey("search.view.build_capacity_subtitle")
    static let search_view_sleep_ritual_subtitle = AppTextKey("search.view.sleep_ritual_subtitle")
    static let search_view_power_nap_subtitle = AppTextKey("search.view.power_nap_subtitle")
    static let search_view_mindset_shifter_subtitle = AppTextKey("search.view.mindset_shifter_subtitle")
    static let search_view_reframe_subtitle = AppTextKey("search.view.reframe_subtitle")
    static let search_view_breathing_subtitle = AppTextKey("search.view.breathing_subtitle")
    static let search_view_hp_snacks_subtitle = AppTextKey("search.view.hp_snacks_subtitle")
    static let search_view_brain_performance_subtitle = AppTextKey("search.view.brain_performance_subtitle")
    static let search_view_work_to_home_subtitle = AppTextKey("search.view.work_to_home_subtitle")
    static let search_view_travel_subtitle = AppTextKey("search.view.travel_subtitle")
    static let search_view_suggestion_subtitle = AppTextKey("search.view.suggestion_subtitle")
    static let search_view_foundation_subtitle = AppTextKey("search.view.foundation_subtitle")

    static let my_qot_my_profile_app_settings_synced_calendar_view_title = AppTextKey("my_qot.my_profile.app_settings.synced_calendar.view.title")









































































































    static let my_qot_my_sprint_detail_info_title = AppTextKey("my_qot.my_sprint.detail.info_title")
    static let my_qot_my_sprint_detail_info_body_title = AppTextKey("my_qot.my_sprint.detail.info_body_title")
    static let my_qot_my_sprint_detail_sprint_tasks_title = AppTextKey("my_qot.my_sprint.detail.sprint_tasks_title")
    static let my_qot_my_sprint_detail_my_plan_title = AppTextKey("my_qot.my_sprint.detail.my_plan_title")
    static let my_qot_my_sprint_detail_my_notes_title = AppTextKey("my_qot.my_sprint.detail.my_notes_title")
    static let my_qot_my_sprint_detail_highlights_title = AppTextKey("my_qot.my_sprint.detail.highlights_title")
    static let my_qot_my_sprint_detail_strategies_title = AppTextKey("my_qot.my_sprint.detail.strategies_title")
    static let my_qot_my_sprint_detail_benefits_title = AppTextKey("my_qot.my_sprint.detail.benefits_title")
    static let my_qot_my_sprint_detail_upcoming_title = AppTextKey("my_qot.my_sprint.detail.upcoming_title")
    static let my_qot_my_sprint_detail_active_title = AppTextKey("my_qot.my_sprint.detail.active_title")
    static let my_qot_my_sprint_detail_notes_title = AppTextKey("my_qot.my_sprint.detail.notes_title")
    static let my_qot_my_sprint_detail_button_takeaways_title = AppTextKey("my_qot.my_sprint.detail.button_takeaways_title")
    static let my_qot_my_sprint_detail_button_cancel_title = AppTextKey("my_qot.my_sprint.detail.button_cancel_title")
    static let my_qot_my_sprint_detail_button_continue_title = AppTextKey("my_qot.my_sprint.detail.button_continue_title")
    static let my_qot_my_sprint_detail_button_start_sprint_title = AppTextKey("my_qot.my_sprint.detail.button_start_sprint_title")
    static let my_qot_my_sprint_detail_button_pause_sprint_title = AppTextKey("my_qot.my_sprint.detail.button_pause_sprint_title")
    static let my_qot_my_sprint_detail_button_yes_pause_title = AppTextKey("my_qot.my_sprint.detail.button_yes_pause_title")
    static let my_qot_my_sprint_detail_button_continue_sprint_title = AppTextKey("my_qot.my_sprint.detail.button_continue_sprint_title")
    static let my_qot_my_sprint_detail_button_restart_sprint_title = AppTextKey("my_qot.my_sprint.detail.button_restart_sprint_title")
    static let my_qot_my_sprint_detail_pause_sprint_title = AppTextKey("my_qot.my_sprint.detail.pause_sprint_title")
    static let my_qot_my_sprint_detail_replan_sprint_title = AppTextKey("my_qot.my_sprint.detail.replan_sprint_title")
    static let my_qot_my_sprint_detail_sprint_in_process_title = AppTextKey("my_qot.my_sprint.detail.sprint_in_process_title")
    static let my_qot_my_sprint_detail_message_pause_sprint_title = AppTextKey("my_qot.my_sprint.detail.message_pause_sprint_title")
    static let my_qot_my_sprint_detail_message_replan_sprint_title = AppTextKey("my_qot.my_sprint.detail.message_replan_sprint_title")
    static let my_qot_my_sprint_detail_message_sprint_in_progress_title = AppTextKey("my_qot.my_sprint.detail.message_sprint_in_progress_title")
    static let my_qot_my_sprint_detail_button_save_title = AppTextKey("my_qot.my_sprint.detail.button_save_title")
    static let my_qot_my_sprint_detail_button_leave_title = AppTextKey("my_qot.my_sprint.detail.button_leave_title")
    static let my_qot_my_sprint_detail_title_leave_title = AppTextKey("my_qot.my_sprint.detail.title_leave_title")
    static let my_qot_my_sprint_detail_message_leave_title = AppTextKey("my_qot.my_sprint.detail.message_leave_title")



























































    static let my_qot_my_profile_about_tignum_view_qot_benefits_title = AppTextKey("my_qot.my_profile.about_tignum.view.qot_benefits_title")
    static let my_qot_my_profile_about_tignum_view_about_tignum_title = AppTextKey("my_qot.my_profile.about_tignum.view.about_tignum_title")
    static let my_qot_my_profile_about_tignum_view_privacy_title = AppTextKey("my_qot.my_profile.about_tignum.view.privacy_title")
    static let my_qot_my_profile_about_tignum_view_conditions_title = AppTextKey("my_qot.my_profile.about_tignum.view.conditions_title")
    static let my_qot_my_profile_about_tignum_view_copyright_title = AppTextKey("my_qot.my_profile.about_tignum.view.copyright_title")

    static let my_qot_my_profile_account_settings_view_title = AppTextKey("my_qot.my_profile.account_settings.view.title")

    static let my_qot_my_profile_account_settings_view_email_title = AppTextKey("my_qot.my_profile.account_settings.view.email_title")
    static let my_qot_my_profile_account_settings_view_company_title = AppTextKey("my_qot.my_profile.account_settings.view.company_title")


    static let my_qot_my_profile_account_settings_view_year_of_birth_title = AppTextKey("my_qot.my_profile.account_settings.view.year_of_birth_title")






    static let my_qot_my_profile_account_settings_view_logout_title = AppTextKey("my_qot.my_profile.account_settings.view.logout_title")
    static let my_qot_my_profile_account_settings_view_logout_subtitle = AppTextKey("my_qot.my_profile.account_settings.view.logout_subtitle")

    static let my_qot_my_profile_app_settings_view_title = AppTextKey("my_qot.my_profile.app_settings.view.title")
    static let my_qot_my_profile_app_settings_view_general_title = AppTextKey("my_qot.my_profile.app_settings.view.general_title")
    static let my_qot_my_profile_app_settings_view_custom_title = AppTextKey("my_qot.my_profile.app_settings.view.custom_title")
    static let my_qot_my_profile_app_settings_view_notification_title = AppTextKey("my_qot.my_profile.app_settings.view.notification_title")
    static let my_qot_my_profile_app_settings_view_notification_subtitle = AppTextKey("my_qot.my_profile.app_settings.view.notification_subtitle")
    static let my_qot_my_profile_app_settings_view_permission_title = AppTextKey("my_qot.my_profile.app_settings.view.permission_title")
    static let my_qot_my_profile_app_settings_view_permission_subttile = AppTextKey("my_qot.my_profile.app_settings.view.permission_subttile")
    static let my_qot_my_profile_app_settings_view_sync_calendar_title = AppTextKey("my_qot.my_profile.app_settings.view.sync_calendar_title")
    static let my_qot_my_profile_app_settings_view_sync_calendar_subtitle = AppTextKey("my_qot.my_profile.app_settings.view.sync_calendar_subtitle")
    static let my_qot_my_profile_app_settings_view_activity_trackers_title = AppTextKey("my_qot.my_profile.app_settings.view.activity_trackers_title")
    static let my_qot_my_profile_app_settings_view_activity_trackers_subtitle = AppTextKey("my_qot.my_profile.app_settings.view.activity_trackers_subtitle")
    static let my_qot_my_profile_app_settings_view_siri_title = AppTextKey("my_qot.my_profile.app_settings.view.siri_title")
    static let my_qot_my_profile_app_settings_view_siri_subtitle = AppTextKey("my_qot.my_profile.app_settings.view.siri_subtitle")







    static let my_qot_my_profile_account_settings_edit_title = AppTextKey("my_qot.my_profile.account_settings.edit.title")

    static let my_qot_my_profile_account_settings_edit_contact_title = AppTextKey("my_qot.my_profile.account_settings.edit.contact_title")
    static let my_qot_my_profile_account_settings_edit_name_title = AppTextKey("my_qot.my_profile.account_settings.edit.name_title")
    static let my_qot_my_profile_account_settings_edit_surname_title = AppTextKey("my_qot.my_profile.account_settings.edit.surname_title")

    static let my_qot_my_profile_account_settings_edit_dob_title = AppTextKey("my_qot.my_profile.account_settings.edit.dob_title")


    static let my_qot_my_profile_account_settings_edit_company_title = AppTextKey("my_qot.my_profile.account_settings.edit.company_title")

    static let my_qot_my_profile_account_settings_edit_email_title = AppTextKey("my_qot.my_profile.account_settings.edit.email_title")





















    static let my_qot_my_profile_app_settings_activity_trackers_view_title = AppTextKey("my_qot.my_profile.app_settings.activity_trackers.view.title")
    static let my_qot_my_profile_app_settings_activity_trackers_view_sensor_title = AppTextKey("my_qot.my_profile.app_settings.activity_trackers.view.sensor_title")



    static let my_qot_my_profile_app_settings_siri_shortcuts_view_tobevision_title = AppTextKey("my_qot.my_profile.app_settings.siri_shortcuts.view.tobevision_title")
    static let my_qot_my_profile_app_settings_siri_shortcuts_view_upcoming_evemt_title = AppTextKey("my_qot.my_profile.app_settings.siri_shortcuts.view.upcoming_evemt_title")
    static let my_qot_my_profile_app_settings_siri_shortcuts_view_whatshot_title = AppTextKey("my_qot.my_profile.app_settings.siri_shortcuts.view.whatshot_title")
    static let my_qot_my_profile_app_settings_siri_shortcuts_view_daily_prep_title = AppTextKey("my_qot.my_profile.app_settings.siri_shortcuts.view.daily_prep_title")





    static let my_qot_my_profile_support_view_suport_title = AppTextKey("my_qot.my_profile.support.view.suport_title")
    static let my_qot_my_profile_support_view_support_subtitle = AppTextKey("my_qot.my_profile.support.view.support_subtitle")
    static let my_qot_my_profile_support_view_feature_subtitle = AppTextKey("my_qot.my_profile.support.view.feature_subtitle")
    static let my_qot_my_profile_support_view_tutorial_subtitle = AppTextKey("my_qot.my_profile.support.view.tutorial_subtitle")
    static let my_qot_my_profile_support_view_faq_subtitle = AppTextKey("my_qot.my_profile.support.view.faq_subtitle")
    static let my_qot_my_profile_support_view_feature_title = AppTextKey("my_qot.my_profile.support.view.feature_title")
    static let my_qot_my_profile_support_view_tutorial_title = AppTextKey("my_qot.my_profile.support.view.tutorial_title")
    static let my_qot_my_profile_support_view_contact_support_title = AppTextKey("my_qot.my_profile.support.view.contact_support_title")
    static let my_qot_my_profile_support_view_faq_title = AppTextKey("my_qot.my_profile.support.view.faq_title")

































    static let ARTICLE_DETAIL = AppTextKey("ARTICLE_DETAIL")
    static let ASKPERMISSION_CALENDAR = AppTextKey("ASKPERMISSION_CALENDAR")
    static let ASKPERMISSION_CALENDAR_SETTINGS = AppTextKey("ASKPERMISSION_CALENDAR_SETTINGS")
    static let ASKPERMISSION_NOTIFICATION = AppTextKey("ASKPERMISSION_NOTIFICATION")
    static let ASKPERMISSION_NOTIFICATION_SETTINGS = AppTextKey("ASKPERMISSION_NOTIFICATION_SETTINGS")
    static let COACH_MAIN = AppTextKey("COACH_MAIN")
    static let COACH_TOOLS = AppTextKey("COACH_TOOLS")
    static let COACH_TOOLS_LIST = AppTextKey("COACH_TOOLS_LIST")
    static let COACH_TOOLS_ITEM_DETAIL = AppTextKey("COACH_TOOLS_ITEM_DETAIL")
    static let DAILY_BRIEF = AppTextKey("DAILY_BRIEF")
    static let DAILY_BRIEF_CONTENT_COPYRIGHT = AppTextKey("DAILY_BRIEF_CONTENT_COPYRIGHT")
    static let DAILYCHECKIN_QUESTIONS = AppTextKey("DAILYCHECKIN_QUESTIONS")
    static let DAILYCHECKIN_START = AppTextKey("DAILYCHECKIN_START")
    static let DECISIONTREE_3DRECOVERY = AppTextKey("DECISIONTREE_3DRECOVERY")
    static let DECISIONTREE_MINDSETSHIFTER = AppTextKey("DECISIONTREE_MINDSETSHIFTER")
    static let DECISIONTREE_MINDSETSHIFTER_PREPARE = AppTextKey("DECISIONTREE_MINDSETSHIFTER_PREPARE")
    static let DECISIONTREE_MINDSETSHIFTER_RESULTS = AppTextKey("DECISIONTREE_MINDSETSHIFTER_RESULTS")
    static let DECISIONTREE_ONBOARDING_TOBEVISIONGENERATOR = AppTextKey("DECISIONTREE_ONBOARDING_TOBEVISIONGENERATOR")
    static let DECISIONTREE_PREPARE = AppTextKey("DECISIONTREE_PREPARE")
    static let DECISIONTREE_PREPARE_EDIT_BENEFITS = AppTextKey("DECISIONTREE_PREPARE_EDIT_BENEFITS")
    static let DECISIONTREE_PREPARE_EDIT_INTENTIONS_KNOW = AppTextKey("DECISIONTREE_PREPARE_EDIT_INTENTIONS_KNOW")
    static let DECISIONTREE_PREPARE_EDIT_INTENTIONS_PERCEIVED = AppTextKey("DECISIONTREE_PREPARE_EDIT_INTENTIONS_PERCEIVED")
    static let DECISIONTREE_PREPARE_TOBEVISIONGENERATOR = AppTextKey("DECISIONTREE_PREPARE_TOBEVISIONGENERATOR")
    static let DECISIONTREE_SOLVE = AppTextKey("DECISIONTREE_SOLVE")
    static let DECISIONTREE_SPRINT = AppTextKey("DECISIONTREE_SPRINT")
    static let DECISIONTREE_TOBEVISIONGENERATOR = AppTextKey("DECISIONTREE_TOBEVISIONGENERATOR")
    static let FULLSCREEN_AUDIOPLAYER = AppTextKey("FULLSCREEN_AUDIOPLAYER")
    static let FULLSCREEN_VIDEOPLAYER = AppTextKey("FULLSCREEN_VIDEOPLAYER")
    static let KNOW_FEED = AppTextKey("KNOW_FEED")
    static let KNOW_FEED_STRATEGY = AppTextKey("KNOW_FEED_STRATEGY")
    static let LANDINGPAGE = AppTextKey("LANDINGPAGE")
    static let MYLIBRARY = AppTextKey("MYLIBRARY")
    static let MYLIBRARY_ALL = AppTextKey("MYLIBRARY_ALL")
    static let MYLIBRARY_BOOKMARKS = AppTextKey("MYLIBRARY_BOOKMARKS")
    static let MYLIBRARY_DOWNLOADS = AppTextKey("MYLIBRARY_DOWNLOADS")
    static let MYLIBRARY_LINKS = AppTextKey("MYLIBRARY_LINKS")
    static let MYLIBRARY_NOTES = AppTextKey("MYLIBRARY_NOTES")
    static let MYLIBRARY_NOTES_NEWNOTE = AppTextKey("MYLIBRARY_NOTES_NEWNOTE")
    static let MYLIBRARY_NOTES_SAVEDNOTE = AppTextKey("MYLIBRARY_NOTES_SAVEDNOTE")
    static let MYPROFILE_ABOUTUS = AppTextKey("MYPROFILE_ABOUTUS")
    static let MYPROFILE_ACCOUNTSETTINGS = AppTextKey("MYPROFILE_ACCOUNTSETTINGS")
    static let MYPROFILE_ACCOUNTSETTINGS_EDIT = AppTextKey("MYPROFILE_ACCOUNTSETTINGS_EDIT")
    static let MYPROFILE_APPSETTINGS = AppTextKey("MYPROFILE_APPSETTINGS")
    static let MYPROFILE_APPSETTINGS_ACTIVITYTRACKERS = AppTextKey("MYPROFILE_APPSETTINGS_ACTIVITYTRACKERS")
    static let MYPROFILE_APPSETTINGS_SIRISHORTCUTS = AppTextKey("MYPROFILE_APPSETTINGS_SIRISHORTCUTS")
    static let MYPROFILE_APPSETTINGS_SYNCEDCALENDARS = AppTextKey("MYPROFILE_APPSETTINGS_SYNCEDCALENDARS")
    static let MYPROFILE_HOME = AppTextKey("MYPROFILE_HOME")
    static let MYPROFILE_SUPPORT = AppTextKey("MYPROFILE_SUPPORT")
    static let MYPROFILE_SUPPORT_FAQ = AppTextKey("MYPROFILE_SUPPORT_FAQ")
    static let MYPROFILE_SUPPORT_TUTORIAL = AppTextKey("MYPROFILE_SUPPORT_TUTORIAL")
    static let MYQOT_MAIN = AppTextKey("MYQOT_MAIN")
    static let MYQOT_MYDATA = AppTextKey("MYQOT_MYDATA")
    static let MYQOT_MYDATA_HEATMAP_INFO = AppTextKey("MYQOT_MYDATA_HEATMAP_INFO")
    static let MYQOT_MYDATA_IMPACT_INFO = AppTextKey("MYQOT_MYDATA_IMPACT_INFO")
    static let MYQOT_MYDATA_LINESELECTION = AppTextKey("MYQOT_MYDATA_LINESELECTION")
    static let MYQOT_MYPREPS = AppTextKey("MYQOT_MYPREPS")
    static let MYQOT_MYSPRINTS = AppTextKey("MYQOT_MYSPRINTS")
    static let MYQOT_MYSPRINTS_SPRINT_DETAIL = AppTextKey("MYQOT_MYSPRINTS_SPRINT_DETAIL")
    static let ONBOARDING_CREATEACCOUNT = AppTextKey("ONBOARDING_CREATEACCOUNT")
    static let ONBOARDING_CREATEACCOUNT_ACTIVATIONCODE = AppTextKey("ONBOARDING_CREATEACCOUNT_ACTIVATIONCODE")
    static let ONBOARDING_CREATEACCOUNT_BIRTHDATE = AppTextKey("ONBOARDING_CREATEACCOUNT_BIRTHDATE")
    static let ONBOARDING_CREATEACCOUNT_EMAIL = AppTextKey("ONBOARDING_CREATEACCOUNT_EMAIL")
    static let ONBOARDING_CREATEACCOUNT_NAME = AppTextKey("ONBOARDING_CREATEACCOUNT_NAME")
    static let ONBOARDING_CREATEACCOUNT_WELCOME = AppTextKey("ONBOARDING_CREATEACCOUNT_WELCOME")
    static let PREPARE_RESULT_ADD_REMOVE_STRATEGIES = AppTextKey("PREPARE_RESULT_ADD_REMOVE_STRATEGIES")
    static let PREPARE_RESULTS = AppTextKey("PREPARE_RESULTS")
    static let SEARCH_MAIN = AppTextKey("SEARCH_MAIN")
    static let SOLVE_RESULTS = AppTextKey("SOLVE_RESULTS")
    static let TOBEVISION = AppTextKey("TOBEVISION")
    static let TOBEVISION_EDIT = AppTextKey("TOBEVISION_EDIT")
    static let TOBEVISION_TRACKER_RESULTS = AppTextKey("TOBEVISION_TRACKER_RESULTS")
    static let TOBEVISION_TRACKER_TBVTRACKER = AppTextKey("TOBEVISION_TRACKER_TBVTRACKER")































































































































































































































































































































































































































































































































































































































































































































































































































































































































































}
// swiftlint:enable vertical_whitespace
