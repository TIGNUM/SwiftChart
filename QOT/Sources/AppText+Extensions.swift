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
    static let daily_brief_good_to_know_title = AppTextKey("daily_brief.good_to_know.title")
    //"Settings.Tutorial.Reset.Title" = "Tutorial reset";
    //
    //"Settings.Title" = "SETTINGS";
    //"Settings.Title.General" = "General";
    //"Settings.Title.Notifications" = "Notifications";
    //"Settings.Title.Security" = "Security";
    //
    //"Settings.General.Company.Title" = "Company";
    //"Settings.General.Email.Title" = "Email";
    //"Settings.General.Telephone.Title" = "Telephone";
    //"Settings.General.FirstName.Title" = "First Name";
    //"Settings.General.LastName.Title" = "Last Name";
    //"Settings.General.Gender.Title" = "Gender";
    //"Settings.General.DateOfBirth.Title" = "Date Of Birth";
    //"Settings.General.Weight.Title" = "Weight";
    //"Settings.General.Height.Title" = "Height";
    //"Settings.General.Calendar.Title" = "Synchronized Calendars";
    //"Settings.General.Tutorial.Title" = "TUTORIAL";
    //"Settings.General.Interview.Title" = "Initial Interview";
    //"Settings.General.Support.Title" = "Support";
    //"Settings.General.Admin.Title" = "(ADMIN)";
    //"Settings.General.JobTitle.Title" = "Title";
    //
    //"Settings.Notifications.Strategies.Title" = "PERFORMANCE REMINDERS";
    //"Settings.Notifications.DailyPrep.Title" = "DAILY CHECK IN";
    //"Settings.Notifications.WeeklyChoices.Title" = "Your 5 Weekly Choices";
    //
    //"Settings.Security.Password.Title" = "Change Password";
    //"Settings.Security.Confirm.Title" = "Confirm";
    //"Settings.Security.Terms.Title" = "TERMS AND CONDITIONS";
    //"Settings.Security.Copyrights.Title" = "CONTENT AND COPYRIGHTS";
    //"Settings.Security.Privacy.Policy.Title" = "PRIVACY\nPOLICY";
    //
    //"Settings.SiriShortcuts.Title" = "SIRI SHORTCUTS";
    //
    static let my_qot_my_profile_app_settings_synced_calendars_view_this_device_title = AppTextKey("my_qot.my_profile.app_settings.synced_calendars.view.this_device_title")
    static let my_qot_my_profile_app_settings_synced_calendars_view_other_devices_title = AppTextKey("my_qot.my_profile.app_settings.synced_calendars.view.other_devices_title")
    //"Settings.Calendars.Subscribed" = "*You can only give access to QOT to the calendars you own.";
    //
    //"Settings.Change.Password.Button" = "Send email";
    //
    //"Sidebar.Title.Search" = "Search";
    //"Sidebar.Title.Tools" = "QOT TOOLS";
    //"Sidebar.Title.Benefits" = "QOT BENEFITS";
    //"Sidebar.Title.Profile" = "Profile";
    //"Sidebar.Title.Sensor" = "CONNECT ACTIVITY TRACKER";
    //"Sidebar.Title.Support" = "Support";
    //"Sidebar.Title.About" = "ABOUT TIGNUM";
    //"Sidebar.Title.Permission" = "PERMISSIONS";
    //"Sidebar.Title.Calendars" = "SYNCED CALENDARS";
    //
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
    //"Sidebar.Title.FAQ" = "FAQ";
    //"Sidebar.Title.ContactSupport" = "CONTACT\nSUPPORT";
    //"Sidebar.Title.FeatureRequest" = "FEATURE\nREQUEST";
    //"Sidebar.Title.Intro.Sliders" = "TUTORIAL";
    //"Sidebar.User.Titles.Member.Since" = "MEMBER SINCE";
    //"Sidebar.User.Titles.Member.QOT.Usage" = "QOT USAGE";
    //
    //"SiriShortcuts.ToBeVision.Title" = "Your To Be Vision";
    //"SiriShortcuts.UpcomingEventPrep.Title" = "Your Upcoming Event Preparation";
    //"SiriShortcuts.DailyPrep.Title" = "Your Daily Check In Feedback";
    //"SiriShortcuts.WhatsHotArticle.Title" = "Your What's Hot? Article";
    //"SiriShortcuts.ToBeVision.suggestedInvocation" = "Read my To Be Vision";
    //"SiriShortcuts.WhatsHotArticle.suggestedInvocation" = "Show me the latest What's Hot? article";
    //"SiriShortcuts.UpcomingEvent.suggestedInvocation" = "What's my Upcoming QOT Preparation Event?";
    //"SiriShortcuts.DailyPrep.suggestedInvocation" = "Show my Daily Check In feedback";
    //
    //"Tab.Bar.Item.Guide" = "GUIDE";
    //"Tab.Bar.Item.Learn" = "LEARN";
    //"Tab.Bar.Item.Me" = "ME";
    //"Tab.Bar.Item.Data" = "DATA";
    //"Tab.Bar.Item.tbv" = "To Be Vision";
    //"Tab.Bar.Item.Prepare" = "PREPARE";
    //
    //"Top.Tab.Bar.Item.Title.Guide" = "GUIDE";
    //"Top.Tab.Bar.Item.Title.Learn.Strategies" = "55 Strategies";
    //"Top.Tab.Bar.Item.Title.Learn.WhatsHot" = "What's Hot";
    //"Top.Tab.Bar.Item.Title.Me.MyData" = "My Data";
    //"Top.Tab.Bar.Item.Title.Me.MyWhy" = "My Why";
    //"Top.Tab.Bar.Item.Title.Perpare.Coach" = "QOT Coach";
    //"Top.Tab.Bar.Item.Title.Perpare.Prep" = "My Prep";
    //"Top.Tab.Bar.Item.Title.Perpare.Tools" = "Tools";
    //"Top.Tab.Bar.Item.Title.Perpare.Preparation" = "PREPARATION";
    //"Top.Tab.Bar.Item.Title.Perpare.Notes" = "NOTES";
    //"Top.Tab.Bar.Item.Title.Tutorial" = "TUTORIAL";
    //
    static let tutorial_view_skip_button = AppTextKey("tutorial.view.skip_button")
    static let tutorial_view_start_button = AppTextKey("tutorial.view.start_button")
    //"Button.Title.Allow" = "Allow";
    //
    //"Guide.Card.Type.WhatsHot" = "Whats Hot Article";
    //"Guide.DailyPrep.NotFinished.WhyDPM" = "WHY DPM ?";
    //"Guide.DailyPrep.NotFinished.Feedback" = "How do you feel today? I can help you Rule Your Impact with just a minute of your time.";
    //"Guide.ToBeVision.NotFisished.Title" = "CREATE YOUR TO BE VISION";
    //"Guide.ToBeVision.NotFisished.Message" = "No human being can outperform their self-image, yet you have not created yours. I would love to help you.";
    //
    //"Article.Loading" = "Please wait while we configure what's hot";
    //"Guide.Loading" = "Please wait while we configure your guide";
    //"Me.My.Universe.Loading" = "Please wait while we configure your universe";
    //"Loading.Data" = "Please wait while we configure your data";
    //"Me.My.Prep.Loading" = "Please wait while we configure your preparation";
    //
    //"Me.Sector.My.Why.Select.Weekly.Choices.Max.Choice.Alert.Title" = "Max Limit";
    //"Me.Sector.My.Why.Select.Weekly.Choices.Max.Choice.Alert.Message" = "You have already reached the maximum limit of weekly choices. Please unselect something to continue your selection";
    //"Me.Sector.My.Why.Select.Weekly.Choices.Max.Choice.Alert.Button" = "OK";
    //"Me.Sector.My.Why.Partners.Photo.Error.Title" = "Error";
    //"Me.Sector.My.Why.Partners.Photo.Error.Message" = "There was a problem updating your profile image. Please try again";
    //"Me.Sector.My.Why.Partners.Photo.Error.OK.Button" = "OK";
    //"Me.Sector.My.Why.Partners.Share.NoContent.Title" = "Unable to share content";
    //"Me.Sector.My.Why.Partners.Share.MissingMyToBeVision.alert" = "Please create your To Be Vision first";
    //"Me.Sector.My.Why.Partners.Share.MissingWeeklyChoice.alert" = " No Weekly Choices selected.";
    //
    //"Prepare.PrepareEvents.AddPreparation" = "ADD THIS PREPARATION TO";
    //"Prepare.PrepareEvents.AddNewEvent" = "Add new event";
    //"Prepare.PrepareEvents.AddNewEvent.Title" = "QOT PREPARE";
    //"Prepare.PrepareEvents.AddNewEvent.Note" = "Here is a checklist to help you quickly show up at your best:\nSet your intentions\n_How do you want to be perceived?\n_How do you want them to feel?\n_What do you want them to know?\nQuick reminders\n_Grab a snack\n_Hydrate\n_Move\n_Dial into the right emotional state for this meeting";
    //"Prepare.PrepareEvents.SyncCalendarEvents" = "Sync Calendars";
    //"Prepare.PrepareEvents.MyPrepList" = "MY PREP LIST";
    //"Prepare.PrepareEvents.UpcomingEvents" = "UPCOMING EVENTS";
    //"Prepare.PrepareEvents.NoSynchronisableCalendars" = "NO EVENTS AVAILABLE,\nPLEASE SYNC CALENDARS";
    //"Prepare.PrepareEvents.NoUpcomingEventsSynchronisableCalendar" = "NO EVENTS AVAILABE,\nPLEASE ADD EVENT";
    //"Prepare.PrepareEvents.UpcomingEventsNoSynchronisableCalendars" = "UPCOMING EVENTS,\nOR SYNC CALENDAR";
    //"Prepare.PrepareEvents.YourDevice" = "YOUR DEVICE";
    //"Prepare.PrepareEvents.SaveThisPreparation" = "Save Preparation";
    static let prepare_view_read_more_title = AppTextKey("prepare.view.read_more_title")
    //"Prepare.Content.Completed" = "PREPARATIONS COMPLETED";
    //"Prepare.Chat.Footer.DeliveredTime" = "Delivered at %@";
    //"Prepare.Chat.Header.Preparations" = "PREPARATIONS";
    //"Prepare.MyPrep.TimeToEvent" = "Time to the event %@";
    //"Prepare.MyPrep.NoSavePreparations" = "No preps saved";
    //"Prepare.MyPrep.Tableview.section.header.PastPreparations" = "Past preps";
    //"Prepare.MyPrep.Tableview.section.header.UpCommingPreparations" = "Upcoming preps";
    //"Prepare.Chat.PreparationSaved" = "Your preparation has been saved to My Prep";
    //"Prepare.Notes.Placeholder" = "Put any additional thoughts into writing. Some examples might include your event To Be Vision, details of what your event's space looks like, or key people at your event.";
    //"Prepare.Review.Notes.Intention.Preceiving.Title" = "How do you want to be perceived during the event?";
    //"Prepare.Review.Notes.Intention.Knowing.Title" = "What do you want the person/group to know after the event?";
    //"Prepare.Review.Notes.Intention.Feeling.Title" = "How do you want the person/group to feel after the event?";
    //"Prepare.Review.Notes.Reflection.Positive.Title" = "5 minutes is all you need to rewire your brain for future success. What did you do well in this event?";
    //"Prepare.Review.Notes.Reflection.Improve.Title" = "If there is something you wish you would have done better, what would you look like if you had done it exactly the way you envisioned?";
    //"Prepare.Review.Notes.General.Title" = "Room for additional thoughts";
    //"Prepare.Review.Notes.Intentions.Placeholder" = "Put your thoughts into writing (i.e. I'm not perfect; your opinion matters; I'm committed to excellence).";
    //"Prepare.Review.Notes.Reflections.Placeholder" = "Write your reflection notes here";
    //"Prepare.Review.Notes.Reflections.Navbar.Title" = "REFLECT ON SUCCESS";
    //"Prepare.Review.Notes.Intentions.Navbar.Title" = "YOUR INTENTIONS";
    //"Prepare.Review.Notes.General.Navbar.Title" = "GENERAL NOTES";
    //
    //"Prepare.Review.Notes.Intentions.Perceived.Placeholder" = "Put your thoughts into writing (i.e. calm, engaged, confident, empathetic).";
    //"Prepare.Review.Notes.Intentions.PersonGroup.Placeholder" = "Put your thoughts into writing (i.e. heard, loved, valued, important).";
    //"Prepare.Review.Notes.Reflection.BrainSuccess.Placeholder" = "Put your thoughts into writing (i.e. I listened well; I was calm; I answered questions clearly).";
    //"Prepare.Review.Notes.Reflection.Wish.Placeholder" = "Put your thoughts into writing (i.e. I listened well; I didn't overreact; I was prepared).";
    static let prepare_choice_view_title = AppTextKey("prepare.choice.view.title")
    //"Prepare.Subtitle.Learn.More" = "LEARN MORE";
    //"Prepare.header.before.and.after" = "BEFORE AND AFTER";
    //"Prepare.header.preparation.list" = "PREPARATION LIST";
    //"Prepare.header.your.intentions" = "YOUR INTENTIONS";
    //"Prepare.header.reflect.on.success" = "REFLECT ON SUCCESS";
    //"Prepare.edit.preparation.list" = "EDIT PREPARATION LIST";
    //
    //"Weekly.Choices.No.Content" = "No weekly choices\nhave been saved yet.";
    //
    //"Learn.Content.Item.Title.Related.Articles" = "RELATED ARTICLES";
    //"Learn.Content.Item.Title.Related.Articles.Load.More" = "Load more";
    //"Learn.Content.Item.Article" = "Article";
    //"Learn.Content.Item.Articles" = "Articles";
    static let article_view_to_read_title = AppTextKey("article.view.to_read_title")
    static let article_pdf_view_to_read_title = AppTextKey("article.pdf.view.to_read_title")
    static let article_view_next_up_title = AppTextKey("article.view.next_up_title")
    static let article_view_related_content_title = AppTextKey("article.view.related_content_title")
    //"learn.category-list-view.title" = "Categories";
    static let pdf_list_duration_title = AppTextKey("pdf.list.duration_title")
    //"learn.content.duration.video" = "%@ min video";
    static let video_list_duration_title = AppTextKey("video.list.duration_title")
    static let audio_list_duration_title = AppTextKey("audio.list.duration_title")
    //
    //"Sidebar.SettingsMenu.Settings" = "SETTINGS";
    //"Sidebar.SettingsMenu.GeneralButton" = "GENERAL";
    //"Sidebar.SettingsMenu.NotificationsButton" = "NOTIFICATIONS";

    //"Sidebar.SettingsMenu.SecurityButton" = "SECURITY AND LEGAL";
    //"Sidebar.SettingsMenu.LogoutButton" = "Logout";
    //
    //"Sidebar.SensorsMenu.Sensors" = "ACTIVITY TRACKERS";
    //"Sidebar.SensorsMenu.Fitbit" = "FITBIT";
    //"Sidebar.SensorsMenu.Sensors.NoData" = "No Data";
    //"Sidebar.SensorsMenu.Sensors.Disconnected" = "Disconnected";
    //"Sidebar.SensorsMenu.Sensors.Connected" = "Connected";
    //"Sidebar.SensorsMenu.Sensors.Syncing" = "Syncing...";
    //"Sidebar.SensorsMenu.Seonsors.NoData" = "No data";
    //"Sidebar.SensorsMenu.OuraRing" = "OURA RING";
    //"Sidebar.SensorsMenu.HealthKit" = "HEALTH KIT";
    //"Sidebar.SensorsMenu.RequestSensor" = "Request activity tracker";
    //"Sidebar.SensorsMenu.Connect" = "CONNECT";
    //"Sidebar.SensorsMenu.Fitbit.Success" = "Fitbit successfully linked";
    //"Sidebar.SensorsMenu.Fitbit.Failure" = "Failed to link Fitbit";
    //"Sidebar.SensorsMenu.Fitbit.Already.Connected.Message" = "Fitbit is already connected with QOT.";
    //"Sidebar.SensorsMenu.Fitbit.Already.Connected.Title" = "CONNECTED";
    //
    //"Common.InvalidContent" = "Cannot Display Content";
    //
    static let startup_alert_database_error_title = AppTextKey("startup.alert.database_error_title")
    static let startup_alert_database_error_body = AppTextKey("startup.alert.database_error_body")
    static let my_qot_my_to_be_vision_alert_camera_not_available_title = AppTextKey("my_qot.my_to_be_vision.alert.camera_not_available_title")
    static let my_qot_my_to_be_vision_alert_camera_not_available_body = AppTextKey("my_qot.my_to_be_vision.alert.camera_not_available_body")
    //"Alert.Title.Notifications.Not.Authorized" = "No Authorization";
    //"Alert.Message.Notifications.Not.Authorized" = "Push Notifications are not authorized for QOT. To enabled Push Notifications open Settings and enable them. ";
    static let search_alert_no_content_title = AppTextKey("search.alert.no_content_title")
    //"Alert.Message.NoContent" = "This content is currently unavailable. Please check back later.";
    static let generic_alert_custom_title = AppTextKey("generic_alert_custom_title")
    //"Alert.Title.Unauthenticated" = "User not authenticated";
    //"Alert.Message.Unauthenticated" = "Unable to authenticated";
    static let generic_alert_no_network_connection_title = AppTextKey("generic.alert.no_network_connection_title")
    static let generic_alert_no_network_connection_message_title = AppTextKey("generic.alert.no_network_connection_message_title")
    static let generic_alert_no_network_connection_file = AppTextKey("generic.alert.no_network_connection_file")
    //Settings.Tutorial.Reset.Title
    static let alert_alert_edit_preparation_name_title = AppTextKey("alert.alert.edit_preparation_name_title")
    static let generic_alert_unknown_title = AppTextKey("generic.alert.unknown_title")
    static let generic_alert_unknown_message_title = AppTextKey("generic.alert.unknown_message_title")
    static let generic_alert_unknown_message_custom_body = AppTextKey("generic.alert.unknown_message_custom_body")
    static let generic_alert_ok_button = AppTextKey("generic.alert.ok_button")
    static let alert_alert_cancel_button = AppTextKey("alert.alert.cancel_button")
    static let generic_alert_continue_button = AppTextKey("generic.alert.continue_button")
    static let my_qot_profile_settings_alert_save_button = AppTextKey("my_qot.profile_settings.alert.save_button")
    static let coach_prepare_alert_save_button = AppTextKey("coach.prepare.alert.save_button")
    static let my_qot_my_sprints_alert_save_button = AppTextKey("my_qot.my_sprints.alert.save_button")
    static let coach_solve_results_alert_save_button = AppTextKey("coach.solve.results.alert.save_button")
    static let alert_alert_level5_saved_button = AppTextKey("alert.alert.level5_saved_button")
    static let alert_alert_level5_alert_title = AppTextKey("alert.alert.level5_alert_title")
    static let alert_alert_level5_alert_body = AppTextKey("alert.alert.level5_alert_body")
    static let alert_alert_copyright_text_title = AppTextKey("alert.alert.copyright_text_title")
    static let alert_alert_save_continue_button = AppTextKey("alert.alert.save_continue_button")
    static let my_qot_my_to_be_vision_alert_settings_title = AppTextKey("my_qot.my_to_be_vision.alert.settings_title")
    static let my_qot_my_profile_app_settings_notifications_alert_open_settings_title = AppTextKey("my_qot.my_profile.app_settings.notifications.alert.open_settings_title")
    //"Alert.Title.LocationServices" = "Location Services";
    //"Alert.Message.LocationServices" = "To change the location service permissions please go the settings.";
    //"Alert.Title.Calendar.No.Access" = "No Access";
    //"Alert.Message.Calendar.No.Access" = "This app does not have access to your calendars.\nYou can enable access in Privacy Settings";
    static let login_alert_email_not_found_title = AppTextKey("login.alert.email_not_found_title")
    static let login_alert_email_not_found_body = AppTextKey("login.alert.email_not_found_body")
    static let my_qot_my_profile_support_alert_email_try_again = AppTextKey("my_qot.my_profile.support.alert.email_try_again")
    static let my_qot_my_profile_support_article_alert_email_try_again = AppTextKey("my_qot.my_profile.support.article.alert.email_try_again")
    //"Alert.CameraNotAvailable.Message" = "The camera is not currently available on this device";
    static let my_qot_my_to_be_vision_alert_camera_not_granted_body = AppTextKey("my_qot.my_to_be_vision.alert.camera_not_granted_body")
    static let my_qot_my_to_be_vision_alert_photo_not_granted_body = AppTextKey("my_qot.my_to_be_vision.alert.photo_not_granted_body")
    //"Alert.PermissionNotGranted.Message" = "Please open your settings to enable permissions for this action";
    //"Alert.NotSynced.Message" = "QOT needs to download more data. Please try again later";
    static let alert_alert_reset_password_title = AppTextKey("alert.alert.reset_password_title")
    static let alert_alert_reset_password_body = AppTextKey("alert.alert.reset_password_body")
    //"Alert.Title.Could.Not.Send.Email" = "Could not send email";
    //"Alert.Message.Could.Not.Send.Email.ToBeVision" = "Please define your 'To Be Vision' first";
    //"Alert.Message.Could.Not.Send.Email.WeeklyChoices" = "No Weekly Choices selected.";
    static let alert_alert_could_not_send_email_body = AppTextKey("alert.alert.could_not_send_email_body")
    static let alert_alert_patner_invite_title = AppTextKey("alert.alert.patner_invite_title")
    static let alert_alert_patner_invite_body = AppTextKey("alert.alert.patner_invite_body")
    //"Alert.Title.Preparation.Add.Strategy" = "Add strategy";
    //"Alert.Title.Preparation.Remove.Strategy" = "Delete strategy";
    //"Alert.Title.Preparation.Edit.Strategy" = "Customize your preparation";
    //"Alert.Message.Preparation.Edit.Strategy" = "You can tailor your preparation. Add strategies that fit best or delete those you dont like.";
    static let alert_alert_edit_vision_button = AppTextKey("alert.alert.edit_vision_button")
    static let alert_alert_create_vision_button = AppTextKey("alert.alert.create_vision_button")
    static let my_qot_support_alert_email_not_setup_body = AppTextKey("my_qot.support.alert.email_not_setup_body")
    static let my_qot_account_settings_alert_logout_body = AppTextKey("my_qot.account_settings.alert.logout_body")
    static let payment_reminder_alert_logout_body = AppTextKey("payment_reminder.alert.logout_body")
    static let subscription_reminder_alert_logout_body = AppTextKey("subscription_reminder.alert.logout_body")
    static let my_qot_my_profile_account_settings_alert_logout_body = AppTextKey("my_qot.my_profile.account_settings.alert.logout_body")
    static let alert_alert_change_permission_title = AppTextKey("alert.alert.change_permission_title")
    static let alert_alert_change_permission_body = AppTextKey("alert.alert.change_permission_body")
    static let coach_prepare_alert_calendar_not_synced_title = AppTextKey("coach.prepare.alert.calendar_not_synced_title")
    //"Alert.title.event.date.not.available" = "Date not available";
    static let coach_prepare_alert_calendar_not_synced_body = AppTextKey("coach.prepare.alert.calendar_not_synced_body")
    //"Alert.message.event.date.not.available" = "QOT could not create the event for the selected date. Please choose date in next 30 days.";
    static let my_qot_my_profile_app_settings_notifications_alert_change_notifications_title = AppTextKey("my_qot.my_profile.app_settings.notifications.alert.change_notifications_title")
    static let my_qot_my_profile_app_settings_notifications_alert_change_notifications_body = AppTextKey("my_qot.my_profile.app_settings.notifications.alert.change_notifications_body")
    static let alert_alert_sign_in_missing_connection_body = AppTextKey("alert.alert.sign_in_missing_connection_body")
    static let video_alert_use_mobile_data_title = AppTextKey("video.alert.use_mobile_data_title")
    static let video_alert_use_mobile_data_body = AppTextKey("video.alert.use_mobile_data_body")
    static let audio_alert_use_mobile_data_title = AppTextKey("audio.alert.use_mobile_data_title")
    static let audio_alert_use_mobile_data_body = AppTextKey("audio.alert.use_mobile_data_body")
    static let my_qot_my_library_alert_use_mobile_data_title = AppTextKey("my_qot.my_library.alert.use_mobile_data_title")
    static let my_qot_my_library_alert_use_mobile_data_body = AppTextKey("my_qot.my_library.alert.use_mobile_data_body")
    static let alert_alert_title_ok_button = AppTextKey("alert.alert.title_ok_button")
    //
    //"ImagePicker.Options.Message" = "A short description of the action goes here";
    static let my_qot_my_to_be_vision_edit_take_a_picture_title = AppTextKey("my_qot.my_to_be_vision.edit.take_a_picture_title")
    static let my_qot_my_to_be_vision_edit_choose_picture_title = AppTextKey("my_qot.my_to_be_vision.edit.choose_picture_title")
    static let my_qot_my_to_be_vision_edit_delete_photo_title = AppTextKey("my_qot.my_to_be_vision.edit.delete_photo_title")
    static let my_qot_my_to_be_vision_edit_cancel_title = AppTextKey("my_qot.my_to_be_vision.edit.cancel_title")
    //"YearPicker.Title.Select" = "Select";
    //
    //"MorningController.doneButton" = "DONE";
    static let login_alert_failed_title = AppTextKey("login.alert.failed_title")
    //
    //"Partners.Alert.Imcomplete.Title" = "Incomplete Partners";
    //"Partners.Alert.Imcomplete.Message" = "Every partner requires a 'Name', 'Surname', 'Relationship' and 'Email.'";
    //"Partners.Alert.DeleteError.Title" = "Cannot delete Partner";
    //"Partners.Alert.DeleteError.Message" = "Please try it again.";
    //
    static let search_edit_all_title = AppTextKey("search.edit.all_title")
    static let search_edit_audio_title = AppTextKey("search.edit.audio_title")
    static let search_edit_video_title = AppTextKey("search.edit.video_title")
    static let search_edit_read_title = AppTextKey("search.edit.read_title")
    static let search_edit_listen_title = AppTextKey("search.edit.listen_title")
    static let search_edit_watch_title = AppTextKey("search.edit.watch_title")
    static let search_edit_tools_title = AppTextKey("search.edit.tools_title")
    static let search_view_placeholder_title = AppTextKey("search.view.placeholder_title")
    //
    //"shortcut.item.title.whats.hot" = "Latest What's Hot Article";
    //"shortcut.item.title.library" = "Tools";
    //"shortcut.item.title.me.universe" = "Review My Data";
    //"shortcut.item.title.prepare" = "Prepare for an event";
    //
    //"MyQot.Profile.Subtitle" = "Edit your personal info and settings";
    //"MyQot.Sprints.Subtitle" = "Building your daily recovery plan";
    static let my_qot_my_plans_view_title = AppTextKey("my_qot.my_plans.view.title")
    //"Choice.View.Header.Edit.Prepare" = "Add or delete strategies from your preparation list.";
    //
    //"Header.Title.Exclusive.Content" = "EXCLUSIVE CONTENT";
    //"Header.Title.Strategies" = "STRATEGIES";
    //"Header.Title.Suggested.Strategies" = "SUGGESTED SOLUTIONS";
    //
    //"Fatigue.Symptom.Cognitive" = "cognitive fatigue";
    //"Fatigue.Symptom.Emotional" = "emotional fatigue";
    //"Fatigue.Symptom.Physical" = "physical fatigue";
    //"Fatigue.Symptom.General" = "It looks like your fatigue is coming from all angles. Jet lag and sleep are the most common causes of this type of fatigue. Which of these two is more applicable to you?";
    //
    static let my_qot_view_my_tbv_more_than_subtitle = AppTextKey("my_qot.view.my_tbv_more_than_subtitle")
    static let my_qot_view_my_tbv_more_months_since_subtitle = AppTextKey("my_qot.view.my_tbv_more_months_since_subtitle")
    static let my_qot_view_my_tbv_less_than_subtitle = AppTextKey("my_qot.view.my_tbv_less_than_subtitle")
    static let my_qot_view_my_tbv_no_vision_subtitle = AppTextKey("my_qot.view.my_tbv_no_vision_subtitle")
    static let my_qot_view_my_data_impact_subtitle = AppTextKey("my_qot.view.my_data_impact_subtitle")
    //
    //"Button.Title.Pick" = "Pick %d to continue";
    //"Button.Title.Add.Event" = "Add new event";
    //"Button.Title.Save.Continue" = "Save & Continue";
    //"Button.Title.Save.Changes" = "Save changes";
    //"Button.Title.Remove" = "Delete";
    //"Button.Title.Cancel" = "Cancel";
    //"Button.Title.YesContinue" = "Yes, continue";
    //"Button.Title.Done" = "Done";
    //"Button.Title.YesLeave" = "Yes, Leave";
    //
    static let audio_view_download_button = AppTextKey("audio.view.download_button")
    static let audio_view_waiting_button = AppTextKey("audio.view.waiting_button")
    static let audio_view_downloading_button = AppTextKey("audio.view.downloading_button")
    static let audio_view_downloaded_button = AppTextKey("audio.view.downloaded_button")
    //
    static let video_view_download_button = AppTextKey("video.view.download_button")
    static let video_view_downloading_button = AppTextKey("video.view.downloading_button")
    static let video_view_downloaded_button = AppTextKey("video.view.downloaded_button")
    //
    //"RateViewController.doneButton" = "Done";
    //"RateViewController.skipButton" = "Skip";
    //"RateViewController.rateMyTBVButton" = "Rate my TBV";
    //
    //"TBVTrackerViewController.doneButton" = "Done";
    //"TBVDataGraphBarNextDurationViewCell.inFourWeeks" = "in 4 weeks";
    //
    //"QuestionnaireViewController.doneButton" = "Done";
    //
    static let daily_brief_daily_checkin_view_hours_subtitle = AppTextKey("daily_brief.daily_checkin.view.hours_subtitle")
    static let daily_brief_daily_checkin_vew_hours_more_subtitle = AppTextKey("daily_brief.daily_checkin.vew.hours_more_subtitle")
    //
    //"MySprintDetails.Info.Title.In.Progress" = "A Sprint is already in progress";
    //"MySprintDetails.Info.Body.In.Progress" = "Looks like you have a sprint in progress that ends the %@. It’s important to keep your focus to reach your current sprint goals. Would you like to stop it and start %@?";
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
    //"MySprintDetails.Button.Cancel" = "Cancel";
    //"MySprintDetails.Button.Continue" = "Continue";
    static let my_qot_my_sprints_my_sprint_details_view_start_sprint_button = AppTextKey("my_qot.my_sprints.my_sprint_details.view.start_sprint_button")
    //"MySprintDetails.Button.PauseSprint" = "Pause Sprint";
    //"MySprintDetails.Button.YesPause" = "Yes, Pause";
    //"MySprintDetails.Button.ContinueSprint" = "Continue sprint";
    //"MySprintDetails.Button.RestartSprint" = "Restart sprint";
    //"MySprintDetails.Info.Title.PauseSprint" = "PAUSE YOUR SPRINT";
    //"MySprintDetails.Info.Title.ReplanSprint" = "REPLAN YOUR SPRINT";
    //"MySprintDetails.Info.Title.SprintInProgress" = "A SPRINT IS ALREADY IN PROGRESS";
    //"MySprintDetails.Info.Message.PauseSprint" = "Are you sure you want to pause your current sprint? To reach the best results is recommended to finish a sprint in maximum %d days.";
    //"MySprintDetails.Info.Message.ReplanSprint" = "It’s really important keep your focus in your sprint to reach your results and finish it in %d days. Do you want to continue where you stopped or restart it from the beginning?";
    //"MySprintDetails.Info.Message.SprintInProgress" = "Looks like you have a sprint in progress that ends the %@. It’s important to keep your focus to reach your current sprint goals. Would you like to stop it and start To be vision anchors?";
    //
    //"MySprintDetailsNotes.Button.Save" = "Save";
    //"MySprintDetailsNotes.Button.Cancel" = "Cancel";
    //"MySprintDetailsNotes.Button.Leave" = "Yes, Leave";
    //"MySprintDetailsNotes.Info.Title.Leave" = "LEAVE WITHOUT SAVING";
    //"MySprintDetailsNotes.Info.Message.Leave" = "Are you sure you want to leave without saving? The changes will not be applied.";
    //"MySprintDetailsNotes.Button.Save" = "Save";
    static let daily_brief_daily_checkin_empty_start_your_dc_in_title = AppTextKey("daily_brief.daily_checkin.empty.start_your_dc_in_title")
    static let daily_brief_daily_checkin_view_explore_your_score_title = AppTextKey("daily_brief.daily_checkin.view.explore_your_score_title")
    //
    //"DailyBrief.Customize.Sleep.Intro" = "Only you know how much sleep you really need to feel fully recovered. Customize your sleep quanity target here.";
    //"DailyBrief.Customize.Sleep.Question" = "How many hours of sleep do you need each night to feel your best?";
    //
    //"Onboarding.Error.General" = "An error occurred, please try again";
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
    //
    static let create_info_view_button_create_account = AppTextKey("create_info.view.button_create_account")
    static let create_info_view_description_title = AppTextKey("create_info.view.description_title")
    //
    static let create_account_email_verification_view_title = AppTextKey("create_account.email_verification.view.title")
    static let create_account_email_verification_view_email_placeholder_title = AppTextKey("create_account.email_verification.view.email_placeholder_title")
    static let create_account_email_verification_view_button_next = AppTextKey("create_account.email_verification.view.button_next")
    static let create_account_email_verification_view_email_error_title = AppTextKey("create_account.email_verification.view.email_error_title")
    static let create_account_email_verification_view_existing_email_error_title = AppTextKey("create_account.email_verification.view.existing_email_error_title")
    static let create_account_email_verification_view_existing_email_error_description = AppTextKey("create_account.email_verification.view.existing_email_error_description")
    static let create_account_email_verification_view_unable_to_register_error = AppTextKey("create_account.email_verification.view.unable_to_register_error")
    static let create_account_email_verification_view_button_yes = AppTextKey("create_account.email_verification.view.button_yes")
    static let create_account_email_verification_view_button_no = AppTextKey("create_account.email_verification.view.button_no")
    //
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
    //
    static let create_account_user_name_view_title = AppTextKey("create_account.user_name.view.title")
    static let create_account_user_name_view_first_name_title = AppTextKey("create_account.user_name.view.first_name_title")
    static let create_account_user_name_view_last_name_title = AppTextKey("create_account.user_name.view.last_name_title")
    static let create_account_user_name_view_mandatory_title = AppTextKey("create_account.user_name.view.mandatory_title")
    static let create_account_user_name_view_next_title = AppTextKey("create_account.user_name.view.next_title")
    //
    static let create_account_birth_year_view_title = AppTextKey("create_account.birth_year.view.title")
    static let create_account_birth_year_view_placeholder_title = AppTextKey("create_account.birth_year.view.placeholder_title")
    static let create_account_birth_year_view_description_title = AppTextKey("create_account.birth_year.view.description_title")
    static let create_account_birth_year_view_restriction_title = AppTextKey("create_account.birth_year.view.restriction_title")
    static let create_account_birth_year_view_next_title = AppTextKey("create_account.birth_year.view.next_title")
    static let create_account_birth_year_view_create_account_error = AppTextKey("create_account.birth_year.view.create_account_error")
    //
    static let notification_permission_view_title = AppTextKey("notification_permission.view.title")
    static let notification_permission_view_description = AppTextKey("notification_permission.view.description")
    static let notification_permission_view_button_skip = AppTextKey("notification_permission.view.button_skip")
    static let notification_permission_view_button_allow = AppTextKey("notification_permission.view.button_allow")
    static let notification_permission_view_alert_message_title = AppTextKey("notification_permission.view.alert_message_title")
    static let notification_permission_view_alert_settings = AppTextKey("notification_permission.view.alert_settings")
    static let notification_permission_view_alert_skip = AppTextKey("notification_permission.view.alert_skip")
    //
    static let track_info_view_title = AppTextKey("track_info.view.title")
    static let track_info_view_message_title = AppTextKey("track_info.view.message_title")
    static let track_info_view_button_fast_track_title = AppTextKey("track_info.view.button_fast_track_title")
    static let track_info_view_button_guided_track_title = AppTextKey("track_info.view.button_guided_track_title")
    //
    static let know_view_title = AppTextKey("know.view.title")
    static let daily_brief_view_title = AppTextKey("daily_brief.view.title")
    static let my_qot_view_title = AppTextKey("my_qot.view.title")
    //
    static let my_qot_my_preps_event_preps_view_subtitle = AppTextKey("my_qot.my_preps.event_preps.view.subtitle")
    static let my_qot_my_preps_event_preps_view_body = AppTextKey("my_qot.my_preps.event_preps.view.body")
    static let my_qot_my_preps_mindset_shifts_view_subtitle = AppTextKey("my_qot.my_preps.mindset_shifts.view.subtitle")
    static let my_qot_my_preps_mindset_shifts_view_body = AppTextKey("my_qot.my_preps.mindset_shifts.view.body")
    static let my_qot_my_preps_recovery_plans_view_subtitle = AppTextKey("my_qot.my_preps.recovery_plans.view.subtitle")
    static let my_qot_my_preps_recovery_plans_view_body = AppTextKey("my_qot.my_preps.recovery_plans.view.body")
    static let my_qot_my_preps_alert_delete_title = AppTextKey("my_qot.my_preps.alert.delete_title")
    static let my_qot_my_preps_alert_delete_body = AppTextKey("my_qot.my_preps.alert.delete_body")
    //
    //"MindsetShifter.LeaveAlert.LeaveButton" = "Yes, Leave";
    //"MindsetShifter.LeaveAlert.Title" = "COACH FOLLOW-UP";
    //"MindsetShifter.LeaveAlert.Message" = "Are you sure you want to leave without setting a coach follow-up?";
    static let coach_solve_alert_leave_title = AppTextKey("coach.solve.alert.leave_title")
    static let coach_solve_alert_leave_body = AppTextKey("coach.solve.alert.leave_body")
    static let coach_solve_alert_button_continue = AppTextKey("coach.solve.alert.button_continue")
    static let coach_solve_alert_button_activate = AppTextKey("coach.solve.alert.button_activate")
    //
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
    static let my_qot_my_library_notes_alert_subtitle = AppTextKey("my_qot.my_library.notes.alert.subtitle")
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
    //
    static let my_qot_my_sprints_empty_title = AppTextKey("my_qot.my_sprints.empty.title")
    static let my_qot_my_sprints_edit_title = AppTextKey("my_qot.my_sprints.edit.title")
    static let my_qot_my_sprints_view_sprint_plan_title = AppTextKey("my_qot.my_sprints.view.sprint_plan_title")
    static let my_qot_my_sprints_view_complete_title = AppTextKey("my_qot.my_sprints.view.complete_title")
    static let my_qot_my_sprints_alert_remove_title = AppTextKey("my_qot.my_sprints.alert.remove_title")
    static let my_qot_my_sprints_alert_remove_body = AppTextKey("my_qot.my_sprints.alert.remove_body")
    static let my_qot_my_sprints_empty_subtitle = AppTextKey("my_qot.my_sprints.empty.subtitle")
    static let my_qot_my_sprints_empty_body = AppTextKey("my_qot.my_sprints.empty.body")
    static let my_qot_my_sprints_view_active_title = AppTextKey("my_qot.my_sprints.view.active_title")
    static let my_qot_my_sprints_view_upcoming_title = AppTextKey("my_qot.my_sprints.view.upcoming_title")
    static let my_qot_my_sprints_view_paused_title = AppTextKey("my_qot.my_sprints.view.paused_title")
    static let my_qot_my_sprints_view_completed_at_title = AppTextKey("my_qot.my_sprints.view.completed_at_title")
    //
    static let my_qot_tbv_view_button_title_my_tbv_data = AppTextKey("my_qot.tbv.view.button_title_my_tbv_data")
    static let my_qot_tbv_empty_auto_generate_button = AppTextKey("my_qot.tbv.empty.auto_generate_button")
    static let my_qot_tbv_empty_write_button = AppTextKey("my_qot.tbv.empty.write_button")
    static let my_qot_tbv_view_updated_comment_subtitle = AppTextKey("my_qot.tbv.view.updated_comment_subtitle")
    static let my_qot_tbv_view_rated_comment_subtitle = AppTextKey("my_qot.tbv.view.rated_comment_subtitle")
    //"TBV.Counter.Ready" = "Ready to start in";
    //"TBV.Counter.Dont.Show" = "Don't show this again";
    //"TBV.Show.More" = "Show more";
    //"TBV.Show.Less" = "Show less";
    static let my_qot_tbv_tbv_tracker_view_your_last_rating_title = AppTextKey("my_qot.tbv.tbv_tracker.view.your_last_rating_title")
    static let my_qot_tbv_questionaire_view_customize_title = AppTextKey("my_qot.tbv.questionaire.view.customize_title")
    static let my_qot_tbv_questionaire_view_customize_body = AppTextKey("my_qot.tbv.questionaire.view.customize_body")
    static let my_qot_tbv_questionaire_view_rate_yourself_body = AppTextKey("my_qot.tbv.questionaire.view.rate_yourself_body")
    static let my_qot_tbv_questionaire_view_rate_never_title = AppTextKey("my_qot.tbv.questionaire.view.rate_never_title")
    static let my_qot_tbv_questionaire_view_rate_sometimes_title = AppTextKey("my_qot.tbv.questionaire.view.rate_sometimes_title")
    static let my_qot_tbv_questionaire_view_rate_always_title = AppTextKey("my_qot.tbv.questionaire.view.rate_always_title")
    //
    static let know_strategy_view_performance_title = AppTextKey("know.strategy.view.performance_title")
    //
    static let know_article_view_mark_as_read_title = AppTextKey("know.article.view.mark_as_read_title")
    static let know_article_view_mark_as_unread_title = AppTextKey("know.article.view.mark_as_unread_title")
    //
    static let coach_solve_results_view_solution_title = AppTextKey("coach.solve.results.view.solution_title")
    static let coach_solve_results_view_answers_title = AppTextKey("coach.solve.results.view.answers_title")
    static let coach_solve_results_view_fatigue_title = AppTextKey("coach.solve.results.view.fatigue_title")
    static let coach_solve_results_view_cause_title = AppTextKey("coach.solve.results.view.cause_title")
    //
    static let my_qot_calendars_view_button_skip = AppTextKey("my_qot.calendars.view.button_skip")
    static let my_qot_calendars_view_button_save = AppTextKey("my_qot.calendars.view.button_save")
    //
    static let daily_brief_weather_view_now_title = AppTextKey("daily_brief.weather.view.now_title")
    //
    static let walkthrough_view_got_it_button = AppTextKey("walkthrough.view.got_it_button")
    static let daily_brief_impact_readiness_view_rolling_data_title = AppTextKey("daily_brief.impact_readiness.view.rolling_data_title")
    static let daily_brief_whats_hot_view_subtitle_title = AppTextKey("daily_brief.whats_hot.view.subtitle_title")
    //
    //"Onboarding.Intro.Title" = "IF YOU CAN'T MAKE AN IMPACT, DON'T BOTHER SHOWING UP.";
    //"Onboarding.Intro.Body" = "From merely present to totally prepared.";
    //"Onboarding.Intro.Button.Login" = "Log in";
    //"Onboarding.Intro.Button.Register" = "New user";
    //
    //"Results.Feedback.Recovery" = "Great work in developing your Recovery Plan. It will be saved for you in MY QOT so that you can review it as needed.";
    //"Results.Feedback.Mindset.Shifter" = "Great work in developing your plan to shift your mindset from low impact to high impact when you face this mindset killer. This mindset shifter will be saved for you in MY QOT so that you can review it as needed.";
    //
    //"MyLibrary.Title" = "MY LIBRARY";
    //"MyLibrary.GroupTitle.All" = "ALL";
    //"MyLibrary.GroupTitle.Bookmarks" = "Bookmarks";
    //"MyLibrary.GroupTitle.Downloads" = "Downloads";
    //"MyLibrary.GroupTitle.Links" = "Links";
    //"MyLibrary.GroupTitle.Notes" = "Notes";
    //"MyLibrary.GroupItemCount.Singular" = "%@ item";
    //"MyLibrary.GroupItemCount.Plural" = "%@ items";
    //"MyLibrary.GroupLastUpdate" = " | Last update %@";
    //
    //myqot_profile_section_title
    //myqot_library_section_title
    //myqot_preps_section_title
    //myqot_sprints_section_title
    //myqot_data_section_title
    //myqot_tobevision_section_title
    //
    //tools_header_title
    //tools_header_subtitle
    //tools_mindset_section_title
    //tools_nutrition_section_title
    //tools_movement_section_title
    //tools_recovery_section_title
    //tools_habituation_section_title
    //
    //coach_header_title
    //coach_header_subtitle
    //coach_search_section_title
    //coach_apply_tools_section_title
    //coach_plan_sprint_section_title
    //coach_prepare_event_section_title
    //coach_solve_challenge_section_title
    //coach_search_section_subtitle
    //coach_apply_tools_section_subtitle
    //coach_plan_sprint_section_subtitle
    //coach_prepare_event_section_subtitle
    //coach_solve_challenge_section_subtitle
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
    //tbv_tooling_headline_placeholder
    //tbv_message_placeholder
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
    //
    //main_know_title
    //main_daily_brief_title
    //main_my_qot_title
    //know-feed-level-01-page-title
    //know-feed-level-01-section-title-strategies
    //know-feed-level-01-section-subtitle-strategies
    //know-feed-level-01-section-title-whats-hot
    //know-feed-level-01-section-subtitle-whats-hot
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
    //Walkthrough_Search_Text
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
    //MyQot_Data_Impact
    //
    //Button_Title_Pick
    //Button_Title_Add_Event
    //Button_Title_Save_Continue
    //Button_Title_Save_Changes
    //Button_Title_Remove
    //Button_Title_Cancel
    //Button_Title_YesContinue
    //Button_Title_Done
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
    //MyToBeVisionTitlePlaceholder
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
    //Onboarding_Login_Email_UserDoesntExistError
    //Onboarding_Login_Email_GenericError
    //Onboarding_Login_Code_Description
    //Onboarding_Login_Code_Error
    //Onboarding_Login_Button_GetHelp
    //Onboarding_Login_Button_ResendCode
    //Onboarding_CreateInfo_Button_CreateAccount
    //Onboarding_CreateInfo_Text_Description
    //Onboarding_Registration_Email_Title
    //Onboarding_Registration_Email_Button_Next
    //Onboarding_Registration_Email_Error
    //Onboarding_Registration_Email_Error_ExistingEmail_Title
    //Onboarding_Registration_Email_Error_ExistingEmail
    //Onboarding_Registration_Email_Error_UnableToRegister
    //Onboarding_Registration_Email_Button_Yes
    //Onboarding_Registration_Email_Button_No
    //Onboarding_Registration_Code_Title
    //Onboarding_Registration_Code_Description
    //Onboarding_Registration_Code_Disclaimer
    //Onboarding_Registration_Code_DisclaimerTermsPlaceholder
    //Onboarding_Registration_Code_DisclaimerPrivacyPlaceholder
    //Onboarding_Registration_Code_CodeInfo
    //Onboarding_Registration_Code_ChangeEmail
    //Onboarding_Registration_Code_SendAgain
    //Onboarding_Registration_Code_Help
    //Onboarding_Registration_Code_CodeError
    //Onboarding_Registration_Code_SendCodeError
    //Onboarding_Registration_Names_Title
    //Onboarding_Registration_Names_Name
    //Onboarding_Registration_Names_Surname
    //Onboarding_Registration_Names_Mandatory
    //Onboarding_Registration_Names_NextTitle
    //Onboarding_Registration_Age_Title
    //Onboarding_Registration_Age_Description
    //Onboarding_Registration_Age_Restriction
    //Onboarding_Registration_Age_NextTitle
    //Onboarding_Registration_CreateAccountError
    //Onboarding_Registration_LocationPermission_Title
    //Onboarding_Registration_LocationPermission_Description
    //Onboarding_Registration_LocationPermission_Button_Skip
    //Onboarding_Registration_LocationPermission_Button_Allow
    //Onboarding_Registration_LocationPermission_Alert_Message
    //Onboarding_Registration_LocationPermission_Alert_Settings
    //Onboarding_Registration_LocationPermission_Alert_Skip
    //Onboarding_Registration_TrackSelection_Button_FastTrack
    //Onboarding_Registration_TrackSelection_Button_GuidedTrack
    //Onboarding_Unoptimized_Device_Alert_Title
    //Onboarding_Unoptimized_Device_Alert_Message
    //Onboarding_Unoptimized_Device_Button_Got_it
    //
    //about_tignum_subtitle
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
    static let my_qot_my_profile_account_settings_view_email_title = AppTextKey("my_qot.my_profile.account_settings.view.email_title")
    static let my_qot_my_profile_account_settings_view_company_title = AppTextKey("my_qot.my_profile.account_settings.view.company_title")
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
    static let my_qot_my_profile_account_settings_edit_dob_title = AppTextKey("my_qot.my_profile.account_settings.edit.dob_title")
    //edit_account_height
    //edit_account_weight
    static let my_qot_my_profile_account_settings_edit_company_title = AppTextKey("my_qot.my_profile.account_settings.edit.company_title")
    //edit_account_title
    static let my_qot_my_profile_account_settings_edit_email_title = AppTextKey("my_qot.my_profile.account_settings.edit.email_title")
    //edit_account_phone
    //
    //my_profile_member_since
    //my_profile_my_profile
    //my_profile_account_settings
    //my_profile_manage_your_profile_details
    //my_profile_app_settings
    //my_profile_enable_notifications
    //my_profile_support
    //my_profile_walkthrough_our_features
    //my_profile_about_tignum
    //my_profile_my_library
    //my_profile_learn_more_about_us
    //
    //myVision_rate_syncingText
    //myVision_rate_notRatedText
    //myVision_nullStateTitle
    //myVision_nullStateSubtitle
    //myVision_visionTitle
    //myVision_visionDescription
    //
    static let my_qot_my_profile_app_settings_activity_trackers_view_title = AppTextKey("my_qot.my_profile.app_settings.activity_trackers.view.title")
    static let my_qot_my_profile_app_settings_activity_trackers_view_sensor_title = AppTextKey("my_qot.my_profile.app_settings.activity_trackers.view.sensor_title")
    //activity_trackers_request_tracker
    //
    //siri_title_tobevision
    static let my_qot_my_profile_app_settings_siri_shortcuts_view_tobevision_title = AppTextKey("my_qot.my_profile.app_settings.siri_shortcuts.view.tobevision_title")
    static let my_qot_my_profile_app_settings_siri_shortcuts_view_upcoming_evemt_title = AppTextKey("my_qot.my_profile.app_settings.siri_shortcuts.view.upcoming_evemt_title")
    static let my_qot_my_profile_app_settings_siri_shortcuts_view_whatshot_title = AppTextKey("my_qot.my_profile.app_settings.siri_shortcuts.view.whatshot_title")
    static let my_qot_my_profile_app_settings_siri_shortcuts_view_daily_prep_title = AppTextKey("my_qot.my_profile.app_settings.siri_shortcuts.view.daily_prep_title")
    //siri_suggestionphrase_tobevision
    //siri_suggestionphrase_upcomingevent
    //siri_suggestionphrase_dailyprep
    //siri_suggestionphrase_whatshot
    //
    static let my_qot_my_profile_support_view_suport_title = AppTextKey("my_qot.my_profile.support.view.suport_title")
    static let my_qot_my_profile_support_view_support_subtitle = AppTextKey("my_qot.my_profile.support.view.support_subtitle")
    static let my_qot_my_profile_support_view_feature_subtitle = AppTextKey("my_qot.my_profile.support.view.feature_subtitle")
    static let my_qot_my_profile_support_view_tutorial_subtitle = AppTextKey("my_qot.my_profile.support.view.tutorial_subtitle")
    static let my_qot_my_profile_support_view_faq_subtitle = AppTextKey("my_qot.my_profile.support.view.faq_subtitle")
    static let my_qot_my_profile_support_view_feature_title = AppTextKey("my_qot.my_profile.support.view.feature_title")
    static let my_qot_my_profile_support_view_tutorial_title = AppTextKey("my_qot.my_profile.support.view.tutorial_title")
    static let my_qot_my_profile_support_view_contact_support_title = AppTextKey("my_qot.my_profile.support.view.contact_support_title")
    static let my_qot_my_profile_support_view_faq_title = AppTextKey("my_qot.my_profile.support.view.faq_title")
    //
    //tbv_data_title
    //tbv_data_subtitle
    //tbv_data_graphTitle
    //tbv_data_empty_state_headerTitle
    //tbv_data_empty_state_headerDescrption
    //tbv_data_empty_state_titleTitle
    //tbv_data_empty_state_titleDescription
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
    static let TOBEVISION_TRACKER_TBVTRACKER = AppTextKey("TOBEVISION_TRACKER_TBVTRACKER")}
