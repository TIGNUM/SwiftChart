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

 To validate the keys:
 1. Load AppText+Extensions.swift and extract all keys.
 2. Find all references to the AppTextKey.* in all other .swift files.
 3. Report
    a. Keys in AppText+Extensions.swift that have not been used.
    b. Keys that are referenced more than once.
 */

public extension AppTextKey {
    //Static lets
    static let daily_brief_good_to_know_title = AppTextKey("daily_brief.good_to_know.title")
    static let my_qot_my_profile_app_settings_view_general_title = AppTextKey("my_qot.my_profile.app_settings.view.general_title")
    static let my_qot_my_profile_app_settings_view_notifications_title = AppTextKey("my_qot.my_profile.app_settings.view.notifications_title")
    static let my_qot_my_profile_app_settings_view_security_title = AppTextKey("my_qot.my_profile.app_settings.view.security_title")
    static let my_qot_my_profile_account_settings_view_company_title = AppTextKey("my_qot.my_profile.account_settings.view.company_title")
    static let my_qot_my_profile_account_settings_view_email_title = AppTextKey("my_qot.my_profile.account_settings.view.email_title")
    static let my_qot_my_profile_account_settings_view_first_name_title = AppTextKey("my_qot.my_profile.account_settings.view.first_name_title")
    static let my_qot_my_profile_account_settings_view_last_name_title = AppTextKey("my_qot.my_profile.account_settings.view.last_name_title")
    static let my_qot_my_profile_account_settings_view_dob_title = AppTextKey("my_qot.my_profile.account_settings.view.dob_title")
    static let my_qot_my_profile_account_settings_edit_company_title = AppTextKey("my_qot.my_profile.account_settings.edit.company_title")
    static let my_qot_my_profile_account_settings_edit_email_title = AppTextKey("my_qot.my_profile.account_settings.edit.email_title")
    static let my_qot_my_profile_account_settings_edit_dob_title = AppTextKey("my_qot.my_profile.account_settings.edit.dob_title")
    static let notifications_view_strategies_title = AppTextKey("notifications.view.strategies_title")
    static let notifications_view_daily_prep_title = AppTextKey("notifications.view.daily_prep_title")
    static let notifications_view_weekly_choices_title = AppTextKey("notifications.view.weekly_choices_title")
    static let my_qot_my_profile_account_settings_view_security_password_title = AppTextKey("my_qot.my_profile.account_settings.view.security_password_title")
    static let my_qot_my_profile_account_settings_view_security_confirm_title = AppTextKey("my_qot.my_profile.account_settings.view.security_confirm_title")
    static let my_qot_my_profile_account_settings_view_terms_title = AppTextKey("my_qot.my_profile.account_settings.view.terms_title")
    static let my_qot_my_profile_account_settings_view_copyright_title = AppTextKey("my_qot.my_profile.account_settings.view.copyright_title")
    static let my_qot_my_profile_account_settings_view_privacy_title = AppTextKey("my_qot.my_profile.account_settings.view.privacy_title")
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
    static let tutorial_view_title = AppTextKey("tutorial.view.title")
    static let tutorial_view_skip_button = AppTextKey("tutorial.view.skip_button")
    static let tutorial_view_start_button = AppTextKey("tutorial.view.start_button")
    static let prepare_view_read_more_title = AppTextKey("prepare.view.read_more_title")
    static let prepare_choice_view_title = AppTextKey("prepare.choice.view.title")
    static let article_view_to_read_title = AppTextKey("article.view.to_read_title")
    static let article_pdf_view_to_read_title = AppTextKey("article.pdf.view.to_read_title")
    static let article_view_next_up_title = AppTextKey("article.view.next_up_title")
    static let article_view_related_content_title = AppTextKey("article.view.related_content_title")
    static let pdf_list_duration_title = AppTextKey("pdf.list.duration_title")
    static let video_list_duration_title = AppTextKey("video.list.duration_title")
    static let audio_list_duration_title = AppTextKey("audio.list.duration_title")
    static let my_qot_sensors_menu_no_data_title = AppTextKey("my_qot.sensors.menu.no_data_title")
    static let my_qot_sensors_menu_disconnected_title = AppTextKey("my_qot.sensors.menu.disconnected_title")
    static let my_qot_sensors_menu_connected_title = AppTextKey("my_qot.sensors.menu.connected_title")
    static let my_qot_sensors_menu_oura_title = AppTextKey("my_qot.sensors.menu.oura_title")
    static let my_qot_sensors_menu_health_kit_title = AppTextKey("my_qot.sensors.menu.health_kit_title")
    static let my_qot_sensors_menu_tracker_title = AppTextKey("my_qot.sensors.menu.tracker_title")
    static let article_view_invalid_content_title = AppTextKey("article.view.invalid_content_title")
    static let startup_alert_database_error_title = AppTextKey("startup.alert.database_error_title")
    static let startup_alert_database_error_body = AppTextKey("startup.alert.database_error_body")
    static let my_qot_my_to_be_vision_alert_camera_not_available_title = AppTextKey("my_qot.my_to_be_vision.alert.camera_not_available_title")
    static let my_qot_my_to_be_vision_alert_camera_not_available_body = AppTextKey("my_qot.my_to_be_vision.alert.camera_not_available_body")
    static let search_alert_no_content_title = AppTextKey("search.alert.no_content_title")
    static let generic_alert_custom_title = AppTextKey("generic_alert_custom_title")
    static let generic_alert_no_network_connection_title = AppTextKey("generic.alert.no_network_connection_title")
    static let generic_alert_no_network_connection_message_title = AppTextKey("generic.alert.no_network_connection_message_title")
    static let generic_alert_no_network_connection_file = AppTextKey("generic.alert.no_network_connection_file")
    static let generic_alert_unknown_title = AppTextKey("generic.alert.unknown_title")
    static let generic_alert_unknown_message_title = AppTextKey("generic.alert.unknown_message_title")
    static let generic_alert_unknown_message_custom_body = AppTextKey("generic.alert.unknown_message_custom_body")
    static let generic_alert_ok_button = AppTextKey("generic.alert.ok_button")
    static let video_alert_continue_button = AppTextKey("video.alert.continue_button")
    static let audio_alert_continue_button = AppTextKey("audio.alert.continue_button")
    static let prepare_alert_continue_button = AppTextKey("prepare.alert.continue_button")
    static let my_qot_my_library_alert_continue_button = AppTextKey("my_qot.my_library.alert.continue_button")
    static let my_qot_my_sprints_alert_continue_button = AppTextKey("my_qot.my_sprints.alert.continue_button")
    static let my_qot_profile_settings_alert_save_button = AppTextKey("my_qot.profile_settings.alert.save_button")
    static let coach_prepare_alert_save_button = AppTextKey("coach.prepare.alert.save_button")
    static let my_qot_my_sprints_alert_save_button = AppTextKey("my_qot.my_sprints.alert.save_button")
    static let coach_solve_results_alert_save_button = AppTextKey("coach.solve.results.alert.save_button")
    static let daily_brief_alert_copyright_text_title = AppTextKey("daily_brief.alert.copyright_text_title")
    static let my_qot_my_to_be_vision_alert_settings_title = AppTextKey("my_qot.my_to_be_vision.alert.settings_title")
    static let my_qot_my_profile_app_settings_notifications_alert_open_settings_title = AppTextKey("my_qot.my_profile.app_settings.notifications.alert.open_settings_title")
    static let login_alert_email_not_found_title = AppTextKey("login.alert.email_not_found_title")
    static let login_alert_email_not_found_body = AppTextKey("login.alert.email_not_found_body")
    static let my_qot_my_profile_support_alert_email_try_again = AppTextKey("my_qot.my_profile.support.alert.email_try_again")
    static let my_qot_my_profile_support_article_alert_email_try_again = AppTextKey("my_qot.my_profile.support.article.alert.email_try_again")
    static let my_qot_my_to_be_vision_alert_camera_not_granted_body = AppTextKey("my_qot.my_to_be_vision.alert.camera_not_granted_body")
    static let my_qot_my_to_be_vision_alert_photo_not_granted_body = AppTextKey("my_qot.my_to_be_vision.alert.photo_not_granted_body")
    static let my_qot_account_settings_alert_logout_body = AppTextKey("my_qot.account_settings.alert.logout_body")
    static let payment_reminder_alert_logout_body = AppTextKey("payment_reminder.alert.logout_body")
    static let subscription_reminder_alert_logout_body = AppTextKey("subscription_reminder.alert.logout_body")
    static let my_qot_my_profile_account_settings_alert_logout_body = AppTextKey("my_qot.my_profile.account_settings.alert.logout_body")
    static let coach_prepare_alert_calendar_not_synced_title = AppTextKey("coach.prepare.alert.calendar_not_synced_title")
    static let my_qot_my_profile_app_settings_notifications_alert_change_notifications_title = AppTextKey("my_qot.my_profile.app_settings.notifications.alert.change_notifications_title")
    static let my_qot_my_profile_app_settings_notifications_alert_change_notifications_body = AppTextKey("my_qot.my_profile.app_settings.notifications.alert.change_notifications_body")
    static let video_alert_use_mobile_data_title = AppTextKey("video.alert.use_mobile_data_title")
    static let video_alert_use_mobile_data_body = AppTextKey("video.alert.use_mobile_data_body")
    static let audio_alert_use_mobile_data_title = AppTextKey("audio.alert.use_mobile_data_title")
    static let audio_alert_use_mobile_data_body = AppTextKey("audio.alert.use_mobile_data_body")
    static let my_qot_my_library_alert_use_mobile_data_title = AppTextKey("my_qot.my_library.alert.use_mobile_data_title")
    static let my_qot_my_library_alert_use_mobile_data_body = AppTextKey("my_qot.my_library.alert.use_mobile_data_body")
    static let my_qot_my_to_be_vision_edit_take_a_picture_title = AppTextKey("my_qot.my_to_be_vision.edit.take_a_picture_title")
    static let my_qot_my_to_be_vision_edit_choose_picture_title = AppTextKey("my_qot.my_to_be_vision.edit.choose_picture_title")
    static let my_qot_my_to_be_vision_edit_delete_photo_title = AppTextKey("my_qot.my_to_be_vision.edit.delete_photo_title")
    static let my_qot_my_profile_app_settings_view_year_select_title = AppTextKey("my_qot.my_profile.app_settings.view.year_select_title")
    static let create_account_view_year_select_title = AppTextKey("create_account.view.year_select_title")
    static let tutorial_view_morning_done_title = AppTextKey("tutorial.view.morning_done_title")
    static let login_alert_failed_title = AppTextKey("login.alert.failed_title")
    static let search_edit_all_title = AppTextKey("search.edit.all_title")
    static let search_edit_read_title = AppTextKey("search.edit.read_title")
    static let search_edit_listen_title = AppTextKey("search.edit.listen_title")
    static let search_edit_watch_title = AppTextKey("search.edit.watch_title")
    static let search_edit_tools_title = AppTextKey("search.edit.tools_title")
    static let search_view_placeholder_title = AppTextKey("search.view.placeholder_title")
    static let home_view_whats_hot_article_title = AppTextKey("home.view.whats_hot_article_title")
    static let home_view_tools_title = AppTextKey("home.view.tools_title")
    static let home_view_review_my_data_title = AppTextKey("home.view.review_my_data_title")
    static let my_qot_view_my_plans_title = AppTextKey("my_qot.view.my_plans_title")
    static let my_qot_my_plans_view_title = AppTextKey("my_qot.my_plans.view.title")
    static let coach_solve_results_view_header_title_exclusive = AppTextKey("coach.solve.results.view.header_title_exclusive")
    static let coach_solve_results_view_header_title_strategies = AppTextKey("coach.solve.results.view.header_title_strategies")
    static let coach_solve_results_view_header_related_items_title_suggested = AppTextKey("coach.solve.results.view.header_related_items_title_suggested")
    static let coach_solve_results_view_header_strategy_items_title_suggested = AppTextKey("coach.solve.results.view.header_strategy_items_title_suggested")
    static let decision_tree_view_fatigue_symptom_cognitive_title = AppTextKey("decision_tree.view.fatigue_symptom_cognitive_title")
    static let decision_tree_view_fatigue_symptom_emotional_title = AppTextKey("decision_tree.view.fatigue_symptom_emotional_title")
    static let decision_tree_view_fatigue_symptom_physical_title = AppTextKey("decision_tree.view.fatigue_symptom_physical_title")
    static let decision_tree_view_fatigue_symptom_general_title = AppTextKey("decision_tree.view.fatigue_symptom_general_title")
    static let my_qot_view_my_tbv_more_than_subtitle = AppTextKey("my_qot.view.my_tbv_more_than_subtitle")
    static let my_qot_view_my_tbv_more_months_since_subtitle = AppTextKey("my_qot.view.my_tbv_more_months_since_subtitle")
    static let my_qot_view_my_tbv_less_than_subtitle = AppTextKey("my_qot.view.my_tbv_less_than_subtitle")
    static let my_qot_view_my_data_impact_subtitle = AppTextKey("my_qot.view.my_data_impact_subtitle")
    static let navigation_bar_view_save_changes_button_title = AppTextKey("navigation_bar.view.save_changes_button_title")
    static let generic_view_delete_button_title = AppTextKey("generic.view.delete_button_title")
    static let generic_view_cancel_button_title = AppTextKey("generic.view.cancel_button_title")
    static let my_qot_my_plans_view_yes_continue_button_title = AppTextKey("my_qot.my_plans.view.yes_continue_button_title")
    static let navigation_bar_view_leave_button = AppTextKey("navigation_bar.view.leave_button")
    static let audio_view_download_button = AppTextKey("audio.view.download_button")
    static let audio_view_waiting_button = AppTextKey("audio.view.waiting_button")
    static let audio_view_downloading_button = AppTextKey("audio.view.downloading_button")
    static let audio_view_downloaded_button = AppTextKey("audio.view.downloaded_button")
    static let video_view_download_button = AppTextKey("video.view.download_button")
    static let video_view_downloading_button = AppTextKey("video.view.downloading_button")
    static let video_view_downloaded_button = AppTextKey("video.view.downloaded_button")
    static let my_qot_to_be_vision_rate_view_done_button_title = AppTextKey("my_qot.to_be_vision.rate.view.done_button_title")
    static let my_qot_to_be_vision_rate_view_rate_button_title = AppTextKey("my_qot.to_be_vision.rate.view.rate_button_title")
    static let my_qot_to_be_vision_view_done_button_title = AppTextKey("my_qot.to_be_vision.view.done_button_title")
    static let my_qot_to_be_vision_view_next_duration_button_title = AppTextKey("my_qot.to_be_vision.view.next_duration_button_title")
    static let daily_brief_daily_checkin_view_done_button_title = AppTextKey("daily_brief.daily_checkin.view.done_button_title")
    static let daily_brief_daily_checkin_view_hours_subtitle = AppTextKey("daily_brief.daily_checkin.view.hours_subtitle")
    static let daily_brief_daily_checkin_vew_hours_more_subtitle = AppTextKey("daily_brief.daily_checkin.vew.hours_more_subtitle")
    static let decision_tree_view_info_body_in_progress = AppTextKey("decision_tree.view.info_body_in_progress")
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
    static let my_qot_my_sprints_my_sprint_details_view_continue_button = AppTextKey("my_qot.my_sprints.my_sprint_details.view.continue_button")
    static let my_qot_my_sprints_my_sprint_details_view_start_sprint_button = AppTextKey("my_qot.my_sprints.my_sprint_details.view.start_sprint_button")
    static let my_qot_my_sprints_my_sprint_details_view_pause_sprint_button = AppTextKey("my_qot.my_sprints.my_sprint_details.view.pause_sprint_button")
    static let my_qot_my_sprints_my_sprint_details_view_yes_pause_button = AppTextKey("my_qot.my_sprints.my_sprint_details.view.yes_pause_button")
    static let my_qot_my_sprints_my_sprint_details_view_continue_sprint_button = AppTextKey("my_qot.my_sprints.my_sprint_details.view.continue_sprint_button")
    static let my_qot_my_sprints_my_sprint_details_view_restart_sprint_button = AppTextKey("my_qot.my_sprints.my_sprint_details.view.restart_sprint_button")
    static let my_qot_my_sprints_my_sprint_details_view_pause_sprint_title = AppTextKey("my_qot.my_sprints.my_sprint_details.view.pause_sprint_title")
    static let my_qot_my_sprints_my_sprint_details_view_replan_sprint_title = AppTextKey("my_qot.my_sprints.my_sprint_details.view.replan_sprint_title")
    static let my_qot_my_sprints_my_sprint_details_view_sprint_in_progress_title = AppTextKey("my_qot.my_sprints.my_sprint_details.view.sprint_in_progress_title")
    static let my_qot_my_sprints_my_sprint_details_view_pause_sprint_info_title = AppTextKey("my_qot.my_sprints.my_sprint_details.view.pause_sprint_info_title")
    static let my_qot_my_sprints_my_sprint_details_view_replan_sprint_info_title = AppTextKey("my_qot.my_sprints.my_sprint_details.view.replan_sprint_info_title")
    static let my_qot_my_sprints_my_sprint_details_view_sprint_in_progress_info_title = AppTextKey("my_qot.my_sprints.my_sprint_details.view.sprint_in_progress_info_title")
    static let my_qot_my_sprints_my_sprint_details_view_save_button = AppTextKey("my_qot.my_sprints.my_sprint_details.view.save_button")
    static let my_qot_my_sprints_my_sprint_details_view_cancel_button = AppTextKey("my_qot.my_sprints.my_sprint_details.view.cancel_button")
    static let my_qot_my_sprints_my_sprint_details_view_leave_button = AppTextKey("my_qot.my_sprints.my_sprint_details.view.leave_button")
    static let my_qot_my_sprints_my_sprint_details_view_leave_title = AppTextKey("my_qot.my_sprints.my_sprint_details.view.leave_title")
    static let my_qot_my_sprints_my_sprint_details_view_leave_body = AppTextKey("my_qot.my_sprints.my_sprint_details.view.leave_body")
    static let daily_brief_daily_checkin_empty_start_your_dc_in_title = AppTextKey("daily_brief.daily_checkin.empty.start_your_dc_in_title")
    static let daily_brief_daily_checkin_view_explore_your_score_title = AppTextKey("daily_brief.daily_checkin.view.explore_your_score_title")
    static let daily_brief_customize_view_sleep_intro_title = AppTextKey("daily_brief.customize.view.sleep_intro_title")
    static let daily_brief_customize_view_sleep_question_title = AppTextKey("daily_brief.customize.view.sleep_question_title")
    static let create_account_email_verification_view_general_error_title = AppTextKey("create_account.email_verification.view.general_error_title")
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
    static let my_qot_my_preps_alert_delete_title = AppTextKey("my_qot.my_preps.alert.delete_title")
    static let my_qot_my_preps_alert_delete_body = AppTextKey("my_qot.my_preps.alert.delete_body")
    static let coach_solve_alert_leave_title = AppTextKey("coach.solve.alert.leave_title")
    static let coach_solve_alert_leave_body = AppTextKey("coach.solve.alert.leave_body")
    static let coach_solve_alert_button_continue = AppTextKey("coach.solve.alert.button_continue")
    static let coach_solve_alert_button_activate = AppTextKey("coach.solve.alert.button_activate")
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
    static let my_qot_my_library_items_alert_delete_title = AppTextKey("my_qot.my_library.items.alert.delete_title")
    static let my_qot_my_library_items_alert_delete_body = AppTextKey("my_qot.my_library.items.alert.delete_body")
    static let my_qot_my_library_items_view_button_download = AppTextKey("my_qot.my_library.items.view.button_download")
    static let my_qot_my_library_all_alert_title = AppTextKey("my_qot.my_library.all.alert.title")
    static let my_qot_my_library_bookmarks_alert_title = AppTextKey("my_qot.my_library.bookmarks.alert.title")
    static let my_qot_my_library_downloads_alert_title = AppTextKey("my_qot.my_library.downloads.alert.title")
    static let my_qot_my_library_links_alert_title = AppTextKey("my_qot.my_library.links.alert.title")
    static let my_qot_my_library_notes_alert_title = AppTextKey("my_qot.my_library.notes.alert.title")
    static let my_qot_my_library_all_alert_subtitle = AppTextKey("my_qot.my_library.all.alert.subtitle")
    static let my_qot_my_library_bookmarks_alert_subtitle = AppTextKey("my_qot.my_library.bookmarks.alert.subtitle")
    static let my_qot_my_library_downloads_alert_subtitle = AppTextKey("my_qot.my_library.downloads.alert.subtitle")
    static let my_qot_my_library_links_alert_subtitle = AppTextKey("my_qot.my_library.links.alert.subtitle")
    static let my_qot_my_library_notes_view_subtitle2 = AppTextKey("my_qot.my_library.notes.view.subtitle2")
    static let my_qot_my_library_media_view_downloading_title = AppTextKey("my_qot.my_library_media.view.downloading_title")
    static let my_qot_my_library_media_view_waiting_title = AppTextKey("my_qot.my_library_media.view.waiting_title")
    static let my_qot_my_library_items_view_read_title = AppTextKey("my_qot.my_library.items.view.read_title")
    static let my_qot_my_library_items_view_watch_title = AppTextKey("my_qot.my_library.items.view.watch_title")
    static let my_qot_my_library_items_view_listen_title = AppTextKey("my_qot.my_library.items.view.listen_title")
    static let my_qot_my_library_notes_view_placeholder = AppTextKey("my_qot.my_library.notes.view.placeholder")
    static let my_qot_my_library_notes_edit_button = AppTextKey("my_qot.my_library.notes.edit.button")
    static let my_qot_my_library_notes_add_view_alert_title = AppTextKey("my_qot.my_library.notes.add.view.alert_title")
    static let my_qot_my_library_notes_add_view_alert_subtitle = AppTextKey("my_qot.my_library.notes.add.view.alert_subtitle")
    static let my_qot_my_library_notes_add_view_alert_button1 = AppTextKey("my_qot.my_library.notes.add.view.alert_button1")
    static let my_qot_my_library_notes_add_view_alert_button2 = AppTextKey("my_qot.my_library.notes.add.view.alert_button2")
    static let my_qot_my_library_notes_edit_alert_title = AppTextKey("my_qot.my_library.notes.edit.alert_title")
    static let my_qot_my_library_notes_edit_alert_message = AppTextKey("my_qot.my_library.notes.edit.alert_message")
    static let my_qot_my_library_notes_edit_alert_remove = AppTextKey("my_qot.my_library.notes.edit.alert_remove")
    static let my_qot_my_library_notes_edit_alert_cancel = AppTextKey("my_qot.my_library.notes.edit.alert_cancel")
    static let my_qot_my_sprints_empty_title = AppTextKey("my_qot.my_sprints.empty.title")
    static let my_qot_my_sprints_edit_title = AppTextKey("my_qot.my_sprints.edit.title")
    static let my_qot_my_sprints_view_sprint_plan_title = AppTextKey("my_qot.my_sprints.view.sprint_plan_title")
    static let my_qot_my_sprints_alert_remove_title = AppTextKey("my_qot.my_sprints.alert.remove_title")
    static let my_qot_my_sprints_alert_remove_body = AppTextKey("my_qot.my_sprints.alert.remove_body")
    static let my_qot_my_sprints_empty_subtitle = AppTextKey("my_qot.my_sprints.empty.subtitle")
    static let my_qot_my_sprints_empty_body = AppTextKey("my_qot.my_sprints.empty.body")
    static let my_qot_my_sprints_view_active_title = AppTextKey("my_qot.my_sprints.view.active_title")
    static let my_qot_my_sprints_view_upcoming_title = AppTextKey("my_qot.my_sprints.view.upcoming_title")
    static let my_qot_my_sprints_view_paused_title = AppTextKey("my_qot.my_sprints.view.paused_title")
    static let my_qot_my_sprints_view_completed_at_title = AppTextKey("my_qot.my_sprints.view.completed_at_title")
    static let my_qot_tbv_view_button_title_my_tbv_data = AppTextKey("my_qot.tbv.view.button_title_my_tbv_data")
    static let my_qot_tbv_empty_auto_generate_button = AppTextKey("my_qot.tbv.empty.auto_generate_button")
    static let my_qot_tbv_empty_write_button = AppTextKey("my_qot.tbv.empty.write_button")
    static let my_qot_tbv_view_updated_comment_subtitle = AppTextKey("my_qot.tbv.view.updated_comment_subtitle")
    static let my_qot_tbv_view_rated_comment_subtitle = AppTextKey("my_qot.tbv.view.rated_comment_subtitle")
    static let my_qot_tbv_tbv_tracker_view_your_last_rating_title = AppTextKey("my_qot.tbv.tbv_tracker.view.your_last_rating_title")
    static let my_qot_tbv_questionaire_view_customize_title = AppTextKey("my_qot.tbv.questionaire.view.customize_title")
    static let my_qot_tbv_questionaire_view_customize_body = AppTextKey("my_qot.tbv.questionaire.view.customize_body")
    static let my_qot_tbv_questionaire_view_rate_yourself_body = AppTextKey("my_qot.tbv.questionaire.view.rate_yourself_body")
    static let my_qot_tbv_questionaire_view_rate_never_title = AppTextKey("my_qot.tbv.questionaire.view.rate_never_title")
    static let my_qot_tbv_questionaire_view_rate_sometimes_title = AppTextKey("my_qot.tbv.questionaire.view.rate_sometimes_title")
    static let my_qot_tbv_questionaire_view_rate_always_title = AppTextKey("my_qot.tbv.questionaire.view.rate_always_title")
    static let know_strategy_view_performance_title = AppTextKey("know.strategy.view.performance_title")
    static let know_article_view_mark_as_read_title = AppTextKey("know.article.view.mark_as_read_title")
    static let know_article_view_mark_as_unread_title = AppTextKey("know.article.view.mark_as_unread_title")
    static let coach_prepare_alert_calendar_not_synced_body = AppTextKey("coach.prepare.alert.calendar_not_synced_body")
    static let coach_solve_results_view_solution_title = AppTextKey("coach.solve.results.view.solution_title")
    static let coach_solve_results_view_answers_title = AppTextKey("coach.solve.results.view.answers_title")
    static let coach_solve_results_view_fatigue_title = AppTextKey("coach.solve.results.view.fatigue_title")
    static let coach_solve_results_view_cause_title = AppTextKey("coach.solve.results.view.cause_title")
    static let my_qot_calendars_view_button_skip = AppTextKey("my_qot.calendars.view.button_skip")
    static let my_qot_calendars_view_button_save = AppTextKey("my_qot.calendars.view.button_save")
    static let daily_brief_weather_view_now_title = AppTextKey("daily_brief.weather.view.now_title")
    static let walkthrough_view_got_it_button = AppTextKey("walkthrough.view.got_it_button")
    static let daily_brief_impact_readiness_view_rolling_data_title = AppTextKey("daily_brief.impact_readiness.view.rolling_data_title")
    static let daily_brief_whats_hot_view_subtitle_title = AppTextKey("daily_brief.whats_hot.view.subtitle_title")
    static let singin_onboarding_view_intro_title = AppTextKey("singin.onboarding.view.intro_title")
    static let singin_onboarding_view_intro_body = AppTextKey("singin.onboarding.view.intro_body")
    static let singin_onboarding_view_button_log_in = AppTextKey("singin.onboarding.view.button_log_in")
    static let singin_onboarding_view_button_register = AppTextKey("singin.onboarding.view.button_register")
    static let results_solve_view_feedback_recovery_title = AppTextKey("results.solve.view.feedback_recovery_title")
    static let results_solve_view_feedback_mindset_shifter_title = AppTextKey("results.solve.view.feedback_mindset_shifter_title")
    static let my_qot_view_my_library_title = AppTextKey("my_qot.view.my_library_title")
    static let my_qot_my_library_view_title_all = AppTextKey("my_qot.my_library.view.title_all")
    static let my_qot_my_library_view_title_bookmarks = AppTextKey("my_qot.my_library.view.title_bookmarks")
    static let my_qot_my_library_view_title_downloads = AppTextKey("my_qot.my_library.view.title_downloads")
    static let my_qot_my_library_view_title_links = AppTextKey("my_qot.my_library.view.title_links")
    static let my_qot_my_library_view_title_notes = AppTextKey("my_qot.my_library.view.title_notes")
    static let my_qot_my_library_view_group_singular_title = AppTextKey("my_qot.my_library.view.group_singular_title")
    static let my_qot_my_library_view_group_plural_title = AppTextKey("my_qot.my_library.view.group_plural_title")
    static let my_qot_my_library_view_group_last_update_title = AppTextKey("my_qot.my_library.view.group_last_update_title")
    static let my_qot_my_plans_event_preps_details_alert_reminder_title = AppTextKey("my_qot.my_plans.event_preps.details.alert.reminder_title")
    static let my_qot_my_plans_event_preps_details_alert_reminder_body = AppTextKey("my_qot.my_plans.event_preps.details.alert.reminder_body")
    static let my_qot_my_plans_event_preps_details_alert_yes_title = AppTextKey("my_qot.my_plans.event_preps.details.alert.yes_title")
    static let my_qot_my_plans_event_preps_details_alert_no_title = AppTextKey("my_qot.my_plans.event_preps.details.alert.no_title")
    static let my_qot_my_profile_app_settings_synced_calender_view_subscribed_title = AppTextKey("my_qot.my_profile.app_settings.synced_calender.view.subscribed.title")
    static let my_coach_qot_tools_mindset_tools_view_interactive_tool_title = AppTextKey("my_coach.qot_tools.mindset_tools.view.interactive_tool.title")
    static let my_qot_my_sprints_view_complete_title = AppTextKey("my_qot.my_sprints.view.complete_title")
    static let my_qot_my_sprints_my_sprint_details_view_header_highlights_title = AppTextKey("my_qot.my_sprints.my_sprint_details.view.header_highlights_title")
    static let my_qot_my_sprints_my_sprint_details_view_header_strategies_title = AppTextKey("my_qot.my_sprints.my_sprint_details.view.header_strategies_title")
    static let my_qot_my_sprints_my_sprint_details_view_header_benefits_title = AppTextKey("my_qot.my_sprints.my_sprint_details.view.header_benefits_title")
    static let my_qot_profile_settings_support_view_support_contact_email_title = AppTextKey("my_qot.profile_settings.support.view.support_contact_email_title")
    static let my_qot_profile_settings_support_view_support_contact_email_link_title = AppTextKey("my_qot.profile_settings.support.view.support_contact_email_link_title")
    static let my_qot_my_library_alert_items_cancel_download_alert_title = AppTextKey("my_qot.my_library.alert.items_cancel_download_alert_title")
    static let my_qot_my_library_alert_items_cancel_download_alert_body = AppTextKey("my_qot.my_library.alert.items_cancel_download_alert_body")
    static let my_qot_my_library_notes_alert_subtitle = AppTextKey("my_qot.my_library.notes.alert.subtitle")
    static let my_library_my_profile_view_my_profile_title = AppTextKey("my_library.my_profile.view.my_profile_title")
    static let my_library_my_library_view_my_library_title = AppTextKey("my_library.my_library.view.my_library_title")
    static let my_library_my_plans_view_my_plans_title = AppTextKey("my_library.my_plans.view.my_plans_title")
    static let my_library_my_sprints_view_my_sprints_title = AppTextKey("my_library.my_sprints.view.my_sprints_title")
    static let my_library_my_data_view_my_data_title = AppTextKey("my_library.my_data.view.my_data_title")
    static let my_library_my_tbv_view_my_tbv_title = AppTextKey("my_library.my_tbv.view.my_tbv_title")
    //
    static let coach_qot_tools_view_header_title = AppTextKey("coach.qot_tools.view.header_title")
    static let coach_qot_tools_view_header_subtitle = AppTextKey("coach.qot_tools.view.header_subtitle")
    static let coach_qot_tools_view_perfomamce_mindset_title = AppTextKey("coach.qot_tools.view.perfomamce_mindset_title")
    static let coach_qot_tools_view_performance_nutrition_title = AppTextKey("coach.qot_tools.view.performance_nutrition_title")
    static let coach_qot_tools_view_performance_movement_title = AppTextKey("coach.qot_tools.view.performance_movement_title")
    static let coach_qot_tools_view_performance_recovery_title = AppTextKey("coach.qot_tools.view.performance_recovery_title")
    static let coach_qot_tools_view_performace_habituation_title = AppTextKey("coach.qot_tools.view.performace_habituation_title")
    //
    static let coach_view_rule_your_compact_title = AppTextKey("coach.view.rule_your_compact_title")
    static let coach_view_your_next_step_title = AppTextKey("coach.view.your_next_step_title")
    static let coach_view_search_title = AppTextKey("coach.view.search_title")
    static let coach_view_apply_tools_title = AppTextKey("coach.view.apply_tools_title")
    static let coach_view_plan_sprint_title = AppTextKey("coach.view.plan_sprint_title")
    static let coach_view_prepare_event_title = AppTextKey("coach.view.prepare_event_title")
    static let coach_view_solve_problem_title = AppTextKey("coach.view.solve_problem_title")
    static let coach_view_what_youre_looking_title = AppTextKey("coach.view.what_youre_looking_title")
    static let coach_view_access_tools_title = AppTextKey("coach.view.access_tools_title")
    static let coach_view_run_5_day_sprint_title = AppTextKey("coach.view.run_5_day_sprint_title")
    static let coach_view_be_ready_title = AppTextKey("coach.view.be_ready_title")
    static let coach_view_understand_your_struggle_title = AppTextKey("coach.view.understand_your_struggle_title")
    //
    //payment_header_title
    //payment_header_subtitle
    //payment_prepared_section_title
    //payment_impact_section_title
    //payment_grow_section_title
    //payment_data_section_title
    //payment_prepared_section_subtitle
    //payment_impact_section_subtitle
    //payment_grow_section_subtitle
    //payment_data_section_subtitle
    //
    //tbv_headline_placeholder
    //tbv_message_placeholder
    // tbv_tooling_headline_placeholder
    //
    static let my_qot_my_data_view_ir_title = AppTextKey("my_qot.my_data.view.ir_title")
    static let my_qot_my_data_view_heatmap_title = AppTextKey("my_qot.my_data.view.heatmap_title")
    static let my_qot_my_data_view_ir_body = AppTextKey("my_qot.my_data.view.ir_body")
    static let my_qot_my_data_view_heatmap_body = AppTextKey("my_qot.my_data.view.heatmap_body")
    static let my_qot_my_data_view_ir_button = AppTextKey("my_qot.my_data.view.ir_button")
    static let my_qot_my_data_view_ir_5_day_button = AppTextKey("my_qot.my_data.view.ir_5_day_button")
    static let my_qot_my_data_view_ir_average_title = AppTextKey("my_qot.my_data.view.ir_average_title")
    //
    static let my_qot_my_data_view_heatmap_high_title = AppTextKey("my_qot.my_data.view.heatmap_high_title")
    static let my_qot_my_data_view_heatmap_low_title = AppTextKey("my_qot.my_data.view.heatmap_low_title")
    //my_data_heatmap_red_color_title
    //my_data_heatmap_blue_color_title
    //
    static let my_qot_my_data_edit_title = AppTextKey("my_qot.my_data.edit.title")
    static let my_qot_my_data_edit_subtitle = AppTextKey("my_qot.my_data.edit.subtitle")
    static let my_qot_my_data_edit_sql_title = AppTextKey("my_qot.my_data.edit.sql_title")
    static let my_qot_my_data_edit_sqn_title = AppTextKey("my_qot.my_data.edit.sqn_title")
    static let my_qot_my_data_edit_ten_dl_title = AppTextKey("my_qot.my_data.edit.ten_dl_title")
    static let my_qot_my_data_edit_five_drr_title = AppTextKey("my_qot.my_data.edit.five_drr_title")
    static let my_qot_my_data_edit_five_drl_title = AppTextKey("my_qot.my_data.edit.five_drl_title")
    static let my_qot_my_data_edit_five_dir_title = AppTextKey("my_qot.my_data.edit.five_dir_title")
    static let my_qot_my_data_edit_ir_title = AppTextKey("my_qot.my_data.edit.ir_title")
    //
    static let my_qot_my_data_info_sql_title = AppTextKey("my_qot.my_data.info.sql_title")
    static let my_qot_my_data_info_sqn_title = AppTextKey("my_qot.my_data.info.sqn_title")
    static let my_qot_my_data_info_ten_dl_title = AppTextKey("my_qot.my_data.info.ten_dl_title")
    static let my_qot_my_data_info_five_drr_title = AppTextKey("my_qot.my_data.info.five_drr_title")
    static let my_qot_my_data_info_five_drl_title = AppTextKey("my_qot.my_data.info.five_drl_title")
    static let my_qot_my_data_info_five_dir_title = AppTextKey("my_qot.my_data.info.five_dir_title")
    static let my_qot_my_data_info_ir_title = AppTextKey("my_qot.my_data.info.ir_title")
    //
    static let my_qot_my_data_info_sql_subtitle = AppTextKey("my_qot.my_data.info.sql_subtitle")
    static let my_qot_my_data_info_sqn_subtitle = AppTextKey("my_qot.my_data.info.sqn_subtitle")
    static let my_qot_my_data_info_ten_dl_subtitle = AppTextKey("my_qot.my_data.info.ten_dl_subtitle")
    static let my_qot_my_data_info_five_drr_subtitle = AppTextKey("my_qot.my_data.info.five_drr_subtitle")
    static let my_qot_my_data_info_five_drl_subtitle = AppTextKey("my_qot.my_data.info.five_drl_subtitle")
    static let my_qot_my_data_info_five_dir_subtitle = AppTextKey("my_qot.my_data.info.five_dir_subtitle")
    static let my_qot_my_data_info_ir_subtitle = AppTextKey("my_qot.my_data.info.ir_subtitle")
    //
    //tbv_generator_alert_not_saved_title
    //tbv_generator_alert_not_saved_message
    //tbv_generator_alert_not_saved_button_title_cancel
    //tbv_generator_alert_not_saved_button_title_default
    //tbv_generator_alert_not_saved_button_title_destructive
    //tbv_sharing
    //
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
    //
    static let my_qot_my_profile_app_settings_synced_calendar_view_title = AppTextKey("my_qot.my_profile.app_settings.synced_calendar.view.title")
    static let my_qot_my_profile_app_settings_synced_calendar_view_subtitle = AppTextKey("my_qot.my_profile.app_settings.synced_calendar.view.subtitle")
    static let know_view_know_title = AppTextKey("know.view.know_title")
    static let daily_brief_view_daily_brief_title = AppTextKey("daily_brief.view.daily_brief_title")
    static let my_qot_view_my_qot_title = AppTextKey("my_qot.view.my_qot_title")
    //know-feed-level-01-page-title
    static let know_view_55_impact_title = AppTextKey("know.view.55_impact_title")
    static let know_view_learn_strategies_subtitle = AppTextKey("know.view.learn_strategies_subtitle")
    static let know_view_whats_hot_title = AppTextKey("know.view.whats_hot_title")
    static let know_view_curated_content_subtitle = AppTextKey("know.view.curated_content_subtitle")
    //
    //subscription_reminder_title
    //subscription_reminder_subtitle
    //subscription_reminder_subtitle_expired
    //subscription_reminder_benefit_title_01
    //subscription_reminder_benefit_subtitle_01
    //subscription_reminder_benefit_title_02
    //subscription_reminder_benefit_subtitle_02
    //subscription_reminder_benefit_title_03
    //subscription_reminder_benefit_subtitle_03
    //subscription_reminder_benefit_title_04
    //subscription_reminder_benefit_subtitle_04
    //
    static let walkthrough_view_search_title = AppTextKey("walkthrough.view.search_title")
    //Walkthrough_Coach_Text
    //Walkthrough_Swipe_Text
    //Settings_Security_Terms_Title
    //Settings_Security_Copyrights_Title
    //
    //Settings_SiriShortcuts_Title
    //Settings_Calendar_Section_OnThisDevice_Header
    //Settings_Calendar_Section_OnOtherDevices_Header
    //SiriShortcuts_ToBeVision_Title
    //SiriShortcuts_UpcomingEventPrep_Title
    //SiriShortcuts_DailyPrep_Title
    //SiriShortcuts_WhatsHotArticle_Title
    //SiriShortcuts_ToBeVision_suggestedInvocation
    //SiriShortcuts_WhatsHotArticle_suggestedInvocation
    //SiriShortcuts_UpcomingEvent_suggestedInvocation
    //SiriShortcuts_DailyPrep_suggestedInvocation
    //Button_Title_Skip
    //Button_Title_Start
    //Button_Title_Allow
    //
    //Search_Filter_All
    //Search_Filter_Audio
    //Search_Filter_Video
    //Search_Filter_Read
    //Search_Filter_Listen
    //Search_Filter_Watch
    //Search_Filter_Tools
    //Search_Placeholder
    //
    //MyQot_Profile_Subtitle
    //MyQot_Sprints_Subtitle
    //MyQot_title
    //MyQot_header_title
    //Choice_View_Header_Edit_Prepare
    //Header_Title_Exclusive_Content
    //Header_Title_Strategies
    //Header_Title_Suggested_Strategies
    //
    //Fatigue_Symptom_Cognitive
    //Fatigue_Symptom_Emotional
    //Fatigue_Symptom_Physical
    //Fatigue_Symptom_General
    //
    //MyQot_Vision_Morethan
    //MyQot_Vision_MonthsSince
    //MyQot_Vision_LessThan
    //MyQot_Vision_NoVision
    //
    static let my_qot_my_data_view_data_impact_title = AppTextKey("my_qot.my_data.view.data_impact_title")
    //
    //Button_Title_Pick
    //Button_Title_Add_Event
    //Button_Title_Save_Continue
    //Button_Title_Save_Changes
    //Button_Title_Remove
    //Button_Title_Cancel
    //Button_Title_YesContinue
    static let generic_view_done_title = AppTextKey("generic.view.done_title")
    //
    //Audio_FullScreen_Button_Download
    //Audio_FullScreen_Button_Waiting
    //Audio_FullScreen_Button_Downloading
    //Audio_FullScreen_Button_Downloaded
    //
    //RateViewController_doneButton
    //RateViewController_skipButton
    //RateViewController_rateMyTBVButton
    //TBVTrackerViewController_doneButton
    //TBVDataGraphBarNextDurationViewCell_inFourWeeks
    static let my_qot_my_tobevision_edit_placeholder_title = AppTextKey("my_qot.my_tobevision.edit.placeholder_title")
    //MyToBeVisionDescriptionPlaceholder
    //
    //ProfileConfirmation_doneButton
    //ProfileConfirmation_header
    //ProfileConfirmation_description
    //
    //QuestionnaireViewController_doneButton
    //DailyCheckIn_SleepQuantity_Value_Suffix
    //DailyCheckIn_SleepQuantity_Value_Suffix_Max
    //DailyBrief_Customize_Sleep_Intro
    //DailyBrief_Customize_Sleep_Question
    //
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
    //
    //Onboarding_Error_General
    //Onboarding_Login_Email_Description
    //Onboarding_Login_Email_Error
    static let login_view_email_user_description_title = AppTextKey("login.view.email_user_description_title")
    static let login_view_email_generic_error_title = AppTextKey("login.view.email_generic_error_title")
    //Onboarding_Login_Code_Description
    //Onboarding_Login_Code_Error
    static let login_view_get_help_button = AppTextKey("login.view.get_help_button")
    static let login_view_resend_code_button = AppTextKey("login.view.resend_code_button")
    static let create_info_view_create_account_button = AppTextKey("create_info.view.create_account_button")
    static let create_info_view_text_description_button = AppTextKey("create_info.view.text_description_button")
    static let create_account_email_registration_view_email_title = AppTextKey("create_account.email_registration.view.email_title")
    static let create_account_email_registration_view_email_next_button = AppTextKey("create_account.email_registration.view.email_next_button")
    static let create_account_email_registration_view_email_error_title = AppTextKey("create_account.email_registration.view.email_error_title")
    static let create_account_email_registration_view_error_existing_email_title = AppTextKey("create_account.email_registration.view.error_existing_email_title")
    static let create_account_email_registration_view_existing_email_title = AppTextKey("create_account.email_registration.view.existing_email_title")
    static let create_account_email_registration_view_unable_to_register_title = AppTextKey("create_account.email_registration.view.unable_to_register_title")
    static let create_account_email_registration_view_yes_button = AppTextKey("create_account.email_registration.view.yes_button")
    static let create_account_email_registration_view_no_button = AppTextKey("create_account.email_registration.view.no_button")
    //Onboarding_Registration_Code_Title
    static let create_account_code_verification_view_code_description_title = AppTextKey("create_account.code_verification.view.code_description_title")
    static let create_account_code_verification_view_code_disclamier_title = AppTextKey("create_account.code_verification.view.code_disclamier_title")
    static let create_account_code_verification_view_disclaimer_terms_title = AppTextKey("create_account.code_verification.view.disclaimer_terms_title")
    static let create_account_code_verification_view_disclaimer_privacy_title = AppTextKey("create_account.code_verification.view.disclaimer_privacy_title")
    //Onboarding_Registration_Code_CodeInfo
    //Onboarding_Registration_Code_ChangeEmail
    //Onboarding_Registration_Code_SendAgain
    //Onboarding_Registration_Code_Help
    static let create_account_code_verification_view_error_title = AppTextKey("create_account.code_verification.view.error_title")
    //Onboarding_Registration_Code_SendCodeError
    static let create_account_user_name_view_names_title = AppTextKey("create_account.user_name.view.names_title")
    static let create_account_user_name_view_name_title = AppTextKey("create_account.user_name.view.name_title")
    static let create_account_user_name_view_surname_title = AppTextKey("create_account.user_name.view.surname_title")
    //Onboarding_Registration_Names_Mandatory
    //Onboarding_Registration_Names_NextTitle
    static let create_account_user_name_view_age_title = AppTextKey("create_account.user_name.view.age_title")
    static let create_account_user_name_view_age_description_title = AppTextKey("create_account.user_name.view.age_description_title")
    static let create_account_user_name_view_age_restriction_title = AppTextKey("create_account.user_name.view.age_restriction_title")
    static let create_account_user_name_view_age_next_title = AppTextKey("create_account.user_name.view.age_next_title")
    //Onboarding_Registration_CreateAccountError
    //Onboarding_Registration_LocationPermission_Title
    //Onboarding_Registration_LocationPermission_Description
    //Onboarding_Registration_LocationPermission_Button_Skip
    //Onboarding_Registration_LocationPermission_Button_Allow
    //Onboarding_Registration_LocationPermission_Alert_Message
    //Onboarding_Registration_LocationPermission_Alert_Settings
    //Onboarding_Registration_LocationPermission_Alert_Skip
    static let track_info_view_skip_title = AppTextKey("track_info.view.skip_title")
    static let track_info_view_get_started_title = AppTextKey("track_info.view.get_started_title")
    static let login_alert_device_alert_title = AppTextKey("login.alert.device_alert_title")
    static let login_alert_device_alert_message = AppTextKey("login.alert.device_alert_message")
    static let login_alert_device_got_it_button = AppTextKey("login.alert.device_got_it_button")
    //
    //my_library_title
    //about_tignum_content_and_copyright_subtitle
    //about_tignum_privacy_subtitle
    //about_tignum_qot_benefits_subtitle
    //about_tignum_terms_and_condition_subtitle
    static let my_qot_my_profile_about_tignum_view_qot_benefits_title = AppTextKey("my_qot.my_profile.about_tignum.view.qot_benefits_title")
    static let my_qot_my_profile_about_tignum_view_about_tignum_title = AppTextKey("my_qot.my_profile.about_tignum.view.about_tignum_title")
    static let my_qot_my_profile_about_tignum_view_privacy_title = AppTextKey("my_qot.my_profile.about_tignum.view.privacy_title")
    static let my_qot_my_profile_about_tignum_view_conditions_title = AppTextKey("my_qot.my_profile.about_tignum.view.conditions_title")
    static let my_qot_my_profile_about_tignum_view_copyright_title = AppTextKey("my_qot.my_profile.about_tignum.view.copyright_title")
    //
    static let my_qot_my_profile_account_settings_view_title = AppTextKey("my_qot.my_profile.account_settings.view.title")
    //account_settings_contact
    //account_settings_email
    //account_settings_company
    //account_settings_phone
    //account_settings_gender
    static let my_qot_my_profile_account_settings_view_year_of_birth_title = AppTextKey("my_qot.my_profile.account_settings.view.year_of_birth_title")
    //account_settings_personal_data
    //account_settings_height
    //account_settings_weight
    //account_settings_account
    //account_settings_change_password
    //account_settings_protect_your_account
    static let my_qot_my_profile_account_settings_view_logout_title = AppTextKey("my_qot.my_profile.account_settings.view.logout_title")
    static let my_qot_my_profile_account_settings_view_logout_subtitle = AppTextKey("my_qot.my_profile.account_settings.view.logout_subtitle")
    //
    static let my_qot_my_profile_app_settings_view_title = AppTextKey("my_qot.my_profile.app_settings.view.title")
    static let my_qot_my_profile_app_settings_view_general_settings_title = AppTextKey("my_qot.my_profile.app_settings.view.general_settings_title")
    static let my_qot_my_profile_app_settings_view_custom_settings_title = AppTextKey("my_qot.my_profile.app_settings.view.custom_settings_title")
    static let my_qot_my_profile_app_settings_view_notification_title = AppTextKey("my_qot.my_profile.app_settings.view.notification_title")
    static let my_qot_my_profile_app_settings_view_notification_subtitle = AppTextKey("my_qot.my_profile.app_settings.view.notification_subtitle")
    static let my_qot_my_profile_app_settings_view_permission_title = AppTextKey("my_qot.my_profile.app_settings.view.permission_title")
    static let my_qot_my_profile_app_settings_view_permission_subtitle = AppTextKey("my_qot.my_profile.app_settings.view.permission_subttile")
    static let my_qot_my_profile_app_settings_view_sync_calendar_title = AppTextKey("my_qot.my_profile.app_settings.view.sync_calendar_title")
    static let my_qot_my_profile_app_settings_view_sync_calendar_subtitle = AppTextKey("my_qot.my_profile.app_settings.view.sync_calendar_subtitle")
    static let my_qot_my_profile_app_settings_view_activity_trackers_title = AppTextKey("my_qot.my_profile.app_settings.view.activity_trackers_title")
    static let my_qot_my_profile_app_settings_view_activity_trackers_subtitle = AppTextKey("my_qot.my_profile.app_settings.view.activity_trackers_subtitle")
    static let my_qot_my_profile_app_settings_view_siri_title = AppTextKey("my_qot.my_profile.app_settings.view.siri_title")
    static let my_qot_my_profile_app_settings_view_siri_subtitle = AppTextKey("my_qot.my_profile.app_settings.view.siri_subtitle")
    //
    //coach_search // REMOVE ME
    //coach_tools
    //coach_sprint
    //coach_event
    //coach_challenge
    //
    static let my_qot_my_profile_account_settings_edit_title = AppTextKey("my_qot.my_profile.account_settings.edit.title")
    //edit_account_personal_data
    static let my_qot_my_profile_account_settings_edit_contact_title = AppTextKey("my_qot.my_profile.account_settings.edit.contact_title")
    static let my_qot_my_profile_account_settings_edit_name_title = AppTextKey("my_qot.my_profile.account_settings.edit.name_title")
    static let my_qot_my_profile_account_settings_edit_surname_title = AppTextKey("my_qot.my_profile.account_settings.edit.surname_title")
    //edit_account_gender
    static let my_qot_my_profile_account_settings_edit_year_title = AppTextKey("my_qot.my_profile.account_settings.edit.year_title")
    static let my_qot_my_profile_account_settings_view_year_title = AppTextKey("my_qot.my_profile.account_settings.view.year_title")
    //edit_account_height
    //edit_account_weight
    //edit_account_company
    //edit_account_title
    //edit_account_email
    //edit_account_phone
    //
    static let my_qot_my_profile_view_member_since_title = AppTextKey("my_qot.my_profile.view.member_since_title")
    static let my_qot_my_profile_view_my_profile_title = AppTextKey("my_qot.my_profile.view.my_profile_title")
    static let my_qot_my_profile_view_account_settings_title = AppTextKey("my_qot.my_profile.view.account_settings_title")
    static let my_qot_my_profile_view_profile_details_title = AppTextKey("my_qot.my_profile.view.profile_details_title")
    static let my_qot_my_profile_view_app_settings_title = AppTextKey("my_qot.my_profile.view.app_settings_title")
    static let my_qot_my_profile_view_enable_notification_title = AppTextKey("my_qot.my_profile.view.enable_notification_title")
    static let my_qot_my_profile_view_support_title = AppTextKey("my_qot.my_profile.view.support_title")
    static let my_qot_my_profile_view_walkthrough_title = AppTextKey("my_qot.my_profile.view.walkthrough_title")
    static let my_qot_my_profile_view_about_us_title = AppTextKey("my_qot.my_profile.view.about_us_title")
    //my_profile_my_library
    static let my_qot_my_profile_view_learn_more_title = AppTextKey("my_qot.my_profile.view.learn_more_title")
    //
    static let my_qot_my_tobevision_view_syncing_title = AppTextKey("my_qot.my_tobevision.view.syncing_title")
    static let my_qot_my_tobevision_view_not_rated_title = AppTextKey("my_qot.my_tobevision.view.not_rated_title")
    static let my_qot_my_tobevision_view_null_state_title = AppTextKey("my_qot.my_tobevision.view.null_state_title")
    static let my_qot_my_tobevision_view_null_state_subtitle = AppTextKey("my_qot.my_tobevision.view.null_state_subtitle")
    //myVision_visionTitle
    static let my_qot_my_tobevision_view_vision_subtitle = AppTextKey("my_qot.my_tobevision.view.vision_subtitle")
    static let my_qot_my_tobevision_edit_vision_subtitle = AppTextKey("my_qot.my_tobevision.edit.vision_subtitle")
    //
    static let my_qot_my_profile_app_settings_activity_trackers_view_title = AppTextKey("my_qot.my_profile.app_settings.activity_trackers.view.title")
    static let my_qot_my_profile_app_settings_activity_trackers_view_sensor_title = AppTextKey("my_qot.my_profile.app_settings.activity_trackers.view.sensor_title")
    //activity_trackers_request_tracker
    //
    static let my_qot_my_profile_app_settings_siri_shortcuts_view_tobevision_title = AppTextKey("my_qot.my_profile.app_settings.siri_shortcuts.view.tobevision_title")
    //siri_title_upcomingevent
    static let my_qot_my_profile_app_settings_siri_shortcuts_view_whatshot_title = AppTextKey("my_qot.my_profile.app_settings.siri_shortcuts.view.whatshot_title")
    static let my_qot_my_profile_app_settings_siri_shortcuts_view_daily_prep_title = AppTextKey("my_qot.my_profile.app_settings.siri_shortcuts.view.daily_prep_title")
    static let my_qot_my_profile_app_settings_siri_shortcuts_view_explanation_title = AppTextKey("my_qot.my_profile.app_settings.siri_shortcuts.view.explanation_title")
    static let my_qot_my_profile_app_settings_siri_shortcuts_view_tobevision_body = AppTextKey("my_qot.my_profile.app_settings.siri_shortcuts.view.tobevision_body")
    //siri_suggestionphrase_upcomingevent
    static let my_qot_my_profile_app_settings_siri_shortcuts_view_whatshot_body = AppTextKey("my_qot.my_profile.app_settings.siri_shortcuts.view.whatshot_body")
    static let my_qot_my_profile_app_settings_siri_shortcuts_view_daily_prep_body = AppTextKey("my_qot.my_profile.app_settings.siri_shortcuts.view.daily_prep_body")
    //
    static let my_qot_my_profile_support_view_support_title = AppTextKey("my_qot.my_profile.support.view.support_title")
    static let my_qot_my_profile_support_view_support_subtitle = AppTextKey("my_qot.my_profile.support.view.support_subtitle")
    static let my_qot_my_profile_support_view_feature_subtitle = AppTextKey("my_qot.my_profile.support.view.feature_subtitle")
    static let my_qot_my_profile_support_view_tutorial_subtitle = AppTextKey("my_qot.my_profile.support.view.tutorial_subtitle")
    static let my_qot_my_profile_support_view_faq_subtitle = AppTextKey("my_qot.my_profile.support.view.faq_subtitle")
    static let my_qot_my_profile_support_view_feature_title = AppTextKey("my_qot.my_profile.support.view.feature_title")
    static let my_qot_my_profile_support_view_tutorial_title = AppTextKey("my_qot.my_profile.support.view.tutorial_title")
    static let my_qot_my_profile_support_view_contact_support_title = AppTextKey("my_qot.my_profile.support.view.contact_support_title")
    static let my_qot_my_profile_support_view_faq_title = AppTextKey("my_qot.my_profile.support.view.faq_title")
    //
    static let my_qot_my_tbv_my_tbv_data_view_title = AppTextKey("my_qot.my_tbv.my_tbv_data.view.title")
    static let my_qot_my_tbv_my_tbv_data_view_subtitle = AppTextKey("my_qot.my_tbv.my_tbv_data.view.subtitle")
    static let my_qot_my_tbv_my_tbv_data_view_my_tbv_title = AppTextKey("my_qot.my_tbv.my_tbv_data.view.my_tbv_title")
    static let my_qot_my_tbv_my_tbv_data_empty_header_title = AppTextKey("my_qot.my_tbv.my_tbv_data.empty.header_title")
    static let my_qot_my_tbv_my_tbv_data_empty_header_description_title = AppTextKey("my_qot.my_tbv.my_tbv_data.empty.header_description_title")
    static let my_qot_my_tbv_my_tbv_data_empty_title = AppTextKey("my_qot.my_tbv.my_tbv_data.empty.title")
    static let my_qot_my_tbv_my_tbv_data_empty_title_description_title = AppTextKey("my_qot.my_tbv.my_tbv_data.empty.title_description_title")
    //
    //tbv_tracker_title
    //tbv_tracker_subtitle
    //tbv_tracker_graphTitle
    //
    //mindset-shifter-checklist-header-title
    //mindset-shifter-checklist-header-subtitle
    //mindset-shifter-checklist-trigger-title
    //mindset-shifter-checklist-reactions-title
    //mindset-shifter-checklist-negativeToPositive-title
    //mindset-shifter-checklist-negativeToPositive-lowTitle
    //mindset-shifter-checklist-negativeToPositive-highTitle
    //mindset-shifter-checklist-vision-Title
    //mindset-shifter-checklist-save-button-text
    //
    //No_Internet_Connection_Title
    //No_Internet_Connection_Message
    //
    //PREPARE_RESULT_GREAT_WORK
    //
    //DELETED_EVENT_OF_PREPARATION_POP_UP_REMOVE_BUTTON_TITLE
    //DELETED_EVENT_OF_PREPARATION_POP_UP_KEEP_BUTTON_TITLE
    //DELETED_EVENT_OF_PREPARATION_POP_UP_TITLE
    //DELETED_EVENT_OF_PREPARATION_POP_UP_DESCRIPTION
    //
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
