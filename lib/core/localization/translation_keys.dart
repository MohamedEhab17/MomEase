class TK {
  const TK._();

  // 🔹 App
  static const appName = 'app.name';
  static const appVersion = 'app.version';

  // 🔹 Auth
  static const authLogin = 'auth.login';
  static const authForgotPassword = 'auth.forgot_password';
  static const authCreatePassword = 'auth.create_password';
  static const authPasswordUpdated = 'auth.password_updated';
  static const authVerifyEmail = 'auth.verify_email';
  static const authResendCode = 'auth.resend_code';

  // Login Screen
  static const authLoginWelcomeFirst = 'auth.login_screen.welcome_first';
  static const authLoginWelcomeSecond = 'auth.login_screen.welcome_second';
  static const authLoginEmailPhoneHint = 'auth.login_screen.email_phone_hint';
  static const authLoginPasswordHint = 'auth.login_screen.password_hint';
  static const authLoginButton = 'auth.login_screen.login_button';
  static const authLoginOr = 'auth.login_screen.or';
  static const authLoginNoAccountFirst = 'auth.login_screen.no_account_first';
  static const authLoginSignUpLink = 'auth.login_screen.sign_up_link';

  // Sign Up Screen
  static const authSignUpTitleFirst = 'auth.sign_up_screen.title_first';
  static const authSignUpTitleSecond = 'auth.sign_up_screen.title_second';
  static const authSignUpSubtitle = 'auth.sign_up_screen.subtitle';
  static const authSignUpFirstNameHint = 'auth.sign_up_screen.first_name_hint';
  static const authSignUpLastNameHint = 'auth.sign_up_screen.last_name_hint';
  static const authSignUpEmailHint = 'auth.sign_up_screen.email_hint';
  static const authSignUpPasswordHint = 'auth.sign_up_screen.password_hint';
  static const authSignUpConfirmPasswordHint =
      'auth.sign_up_screen.confirm_password_hint';
  static const authSignUpButton = 'auth.sign_up_screen.sign_up_button';
  static const authSignUpOr = 'auth.sign_up_screen.or';
  static const authSignUpHasAccountFirst =
      'auth.sign_up_screen.has_account_first';
  static const authSignUpLoginLink = 'auth.sign_up_screen.login_link';

  // Forget Password Screen
  static const authForgetAppBarTitle =
      'auth.forget_password_screen.app_bar_title';
  static const authForgetInstructions =
      'auth.forget_password_screen.instructions';
  static const authForgetEmailHint = 'auth.forget_password_screen.email_hint';
  static const authForgetSendCode = 'auth.forget_password_screen.send_code';

  // Create Password Screen
  static const authCreatePwdInstructions =
      'auth.create_password_screen.instructions';
  static const authCreatePwdNewHint =
      'auth.create_password_screen.new_password_hint';
  static const authCreatePwdConfirmHint =
      'auth.create_password_screen.confirm_new_password_hint';
  static const authCreatePwdSaveButton =
      'auth.create_password_screen.save_button';

  // Verification Screen
  static const authVerificationCodeInstructions =
      'auth.verification_screen.code_instructions';
  static const authVerificationVerifyButton =
      'auth.verification_screen.verify_button';
  static const authVerificationDidntReceiveFirst =
      'auth.verification_screen.didnt_receive_first';
  static const authVerificationSpamLink = 'auth.verification_screen.spam_link';
  static const authVerificationResendNow =
      'auth.verification_screen.resend_now';
  static const authVerificationSpamSnackbar =
      'auth.verification_screen.spam_snackbar';

  // 🔹 Articles
  static const articlesTitle = 'articles.title';
  static const articlesSave = 'articles.save';
  static const articlesSaved = 'articles.saved';
  static const articlesEmpty = 'articles.empty';
  static const articlesNoSaved = 'articles.no_saved';
  static const articlesSearchHint = 'articles.search_hint';
  static const searchNoResults = 'articles.search_no_results';
  static const searchTitle= 'articles.search_title';
  static const  searchEmpty = 'articles.search_empty';
  static const articleReadMinutes = 'articles.read_minutes';
  static const clearAll = 'articles.clear_all';
  static const recentSearches = 'articles.recent_searches';
  // 🔹 Baby
  static const babyTracking = 'baby.tracking';
  static const babyActivity = 'baby.activity';
  static const babyInsights = 'baby.insights';

  // Feeding
  static const babyFeedingTitle = 'baby.feeding.title';
  static const babyFeedingDate = 'baby.feeding.date';
  static const babyFeedingType = 'baby.feeding.type';
  static const babyFeedingSaved = 'baby.feeding.saved';
  static const babyFeedingFrequency = 'baby.feeding.frequency';
  static const babyFeedingSelectDate = 'baby.feeding.select_date';
  static const babyFeedingSaveSession = 'baby.feeding.save_session';
  static const babyFeedingStopSession = 'baby.feeding.stop_session';
  static const babyFeedingStartSession = 'baby.feeding.start_session';
  static const babyFeedingNotesHint = 'baby.feeding.notes_hint';
  static const babyFeedingBreastfeeding = 'baby.feeding.breastfeeding';
  static const babyFeedingFormulaFeeding = 'baby.feeding.formula_feeding';
  static const babyFeedingMixed = 'baby.feeding.mixed';
  static const babyFeedingLast7Days = 'baby.feeding.last_7_days';

  // Sleep
  static const babySleepTitle = 'baby.sleep.title';
  static const babySleepDate = 'baby.sleep.date';
  static const babySleepSaved = 'baby.sleep.saved';
  static const babySleepDuration = 'baby.sleep.duration';
  static const babySleepStart = 'baby.sleep.start_time';
  static const babySleepEnd = 'baby.sleep.end_time';
  static const babySleepNotes = 'baby.sleep.notes_hint';
  static const babySleepSaveRecord = 'baby.sleep.save_record';
  static const babySleepRequired = 'baby.sleep.fill_required';
  static const babySleepHours = 'baby.sleep.duration_hours';
  static const babySleepAvg = 'baby.sleep.daily_avg';
  static const babySleepInvalidDuration = 'baby.sleep.invalid_duration';

  // Vaccine
  static const babyVaccineTitle = 'baby.vaccine.title';
  static const babyVaccineCompleted = 'baby.vaccine.completed';
  static const babyVaccineUpcoming = 'baby.vaccine.upcoming';
  static const babyVaccineCompletedLabel = 'baby.vaccine.completed_label';
  static const babyVaccineNext = 'baby.vaccine.next_due';
  static const babyVaccineInDays = 'baby.vaccine.in_days';
  static const babyVaccineLog = 'baby.vaccine.babys_log';
  static const babyVaccineSchedule = 'baby.vaccine.official_schedule';
  static const babyVaccineOverdueMissed = 'baby.vaccine.overdue_missed';
  static const babyVaccinePending = 'baby.vaccine.pending';
  static const babyVaccineMarkTakenTitle = 'baby.vaccine.mark_taken_title';
  static const babyVaccineMarkTakenDesc = 'baby.vaccine.mark_taken_desc';
  static const babyVaccineDate = 'baby.vaccine.vaccination_date';
  static const babyVaccineCancel = 'baby.vaccine.cancel';
  static const babyVaccineConfirm = 'baby.vaccine.confirm';
  static const babyVaccineSelectChildMsg = 'baby.vaccine.select_child_msg';
  static const babyVaccineRetrievingMsg = 'baby.vaccine.retrieving_msg';
  static const babyVaccineNoLoggedVaccines = 'baby.vaccine.no_logged_vaccines';
  static const babyVaccineNoScheduleAvailable = 'baby.vaccine.no_schedule_available';
  static const babyVaccineDiseasePrevented = 'baby.vaccine.disease_prevented';
  static const babyVaccineWayOfInjection = 'baby.vaccine.way_of_injection';
  static const babyVaccineScheduledDate = 'baby.vaccine.scheduled_date';
  static const babyVaccineTakenDate = 'baby.vaccine.taken_date';
  static const babyVaccineMarkAsTakenBtn = 'baby.vaccine.mark_as_taken_btn';
  static const babyVaccineMonthsSuffix = 'baby.vaccine.months_suffix';

  // Insights Screen
  static const babyInsightsTitle = 'baby.insights_screen.title';
  static const babyHealthScore = 'baby.insights_screen.health_score';
  static const babyMomMood = 'baby.insights_screen.mom_mood';
  static const babyCopingRate = 'baby.insights_screen.coping_rate';
  static const babyGood = 'baby.insights_screen.good';
  static const babyHealthInsights = 'baby.insights_screen.health_insights';
  static const babySleepLabel = 'baby.insights_screen.sleep_label';
  static const babyFeedingLabel = 'baby.insights_screen.feeding_label';
  static const babyFeedingConsistent =
      'baby.insights_screen.feeding_consistent';
  static const babyVaccinesLabel = 'baby.insights_screen.vaccines_label';
  static const babyVaccinesUpToDate =
      'baby.insights_screen.vaccines_up_to_date';
  static const babyMotherWellness = 'baby.insights_screen.mother_wellness';
  static const babyCurrentMood = 'baby.insights_screen.current_mood';
  static const babyCalm = 'baby.insights_screen.calm';
  static const babyDepressionTest = 'baby.insights_screen.depression_test';
  static const babyCompletedStatus = 'baby.insights_screen.completed_status';
  static const babyMoodTrend = 'baby.insights_screen.mood_trend';
  static const babyLast7Days = 'baby.insights_screen.last_7_days';
  static const babyDailyAvg = 'baby.insights_screen.daily_avg';
  static const babyHelpfulSuggestions =
      'baby.insights_screen.helpful_suggestions';
  static const babyBedtimeSugTitle =
      'baby.insights_screen.bedtime_suggestion_title';
  static const babyBedtimeSugBody =
      'baby.insights_screen.bedtime_suggestion_body';
  static const babyFeedingSugTitle =
      'baby.insights_screen.feeding_reminder_title';
  static const babyFeedingSugBody =
      'baby.insights_screen.feeding_reminder_body';

  // 🔹 Community
  static const communityTitle = 'community.title';
  static const communityCreatePost = 'community.create_post';
  static const communityComments = 'community.comments';
  static const communityNoComments = 'community.no_comments';
  static const communityFirstComment = 'community.first_comment';
  static const communityPostSuccess = 'community.post_success';
  static const communityPostsu = 'community.post_success'; // User typo alias
  static const communitySavedPosts = 'community.saved_posts';
  static const communityNoSavedPosts = 'community.no_saved_posts';
  static const communityAddPhotos = 'community.add_photos';
  static const communityGallery = 'community.gallery';
  static const communityAddMore = 'community.add_more';
  static const communityLinkCopied = 'community.link_copied';
  static const communityShareSoon = 'community.share_soon';
  static const communityReportSuccess = 'community.report_success_snackbar';
  static const communityCreatePostHint = 'community.create_post_hint';
  static const communityPostButton = 'community.post_button';
  static const communityPostContentRequired = 'community.post_content_required';
  static const communityReportDialogTitle = 'community.report_dialog_title';
  static const communityReportDialogThanks = 'community.report_dialog_thanks';
  static const communityCopyLink = 'community.copy_link';
  static const communityReportPost = 'community.report_post';
  static const communityRemovePost = 'community.remove_post';
  static const communityDeletePostTitle = 'community.delete_post_title';
  static const communityDeletePostContent = 'community.delete_post_content';
  static const communityShare = 'community.share';
  static const communityShareMoment = 'community.share_moment';
  static const communityWriteComment = 'community.write_comment';
  static const communityReply = 'community.reply';
  static const communityHideReplies = 'community.hide_replies';
  static const communityViewReplies = 'community.view_replies';
  static const communityReplyingTo = 'community.replying_to';
  static const communityYou = 'community.you';
  static const communityJustNow = 'community.just_now';
  static const communityLiked = 'community.liked';
  static const communityComment = 'community.comment';
  static const communitySaved = 'community.saved';
  static const communityLikesCount = 'community.likes_count';
  static const communityViewAllPosts = 'community.view_all_posts';
  static const communityEditImage = 'community.edit_image';
  static const communitySavedPostsOnePost = 'community.saved_posts_one_post';
  static const communitySavedPostsNPosts = 'community.saved_posts_n_posts';
  static const communityUnsavePostTitle = 'community.unsave_post_title';
  static const communityUnsavePostContent = 'community.unsave_post_content';
  static const communityReportReasonHint = 'community.report_reason_hint';
  static const communityReportCancel = 'community.report_cancel';
  static const communityReportSend = 'community.report_send';
  static const communityReportError = 'community.report_error';
  static const communityMaxImagesError = 'community.max_images_error';

  // 🔹 Home
  static const homeWelcome = 'home.welcome';
  static const homeOfferingHelp = 'home.offering_help';
  static const homeMood = 'home.mood';
  static const homeQuickAccessSection = 'home.quick_access.section';
  static const homeQuickAccessCryTitle = 'home.quick_access.cry_title';
  static const homeQuickAccessCrySubtitle = 'home.quick_access.cry_subtitle';
  static const homeQuickAccessSkinTitle = 'home.quick_access.skin_title';
  static const homeQuickAccessSkinSubtitle = 'home.quick_access.skin_subtitle';
  static const homeQuickAccessTrackingTitle =
      'home.quick_access.tracking_title';
  static const homeQuickAccessTrackingSubtitle =
      'home.quick_access.tracking_subtitle';
  static const homeDepressionCardTitle = 'home.depression_card.title';
  static const homeDepressionCardCta = 'home.depression_card.cta';
  static const homeUsefulArticles = 'home.useful_articles';
  static const homeViewAllArticle = 'home.view_all_article';

  // 🔹 Profile
  static const profileParentingJourney = 'profile.parenting_journey';
  static const profileCommunityPosts = 'profile.community_posts';
  static const profileLastMood = 'profile.last_mood';
  static const profileDepression = 'profile.depression_test';
  static const profileTracking = 'profile.baby_tracking';
  static const profileUpdatedToday = 'profile.updated_today';
  static const profileViewBabyData = 'profile.view_baby_data';
  static const profileLogoutAccount = 'profile.logout_account';
  static const profileVersion = 'profile.momease_version';
  static const profileManageProfile = 'profile.manage_profile';
  static const profileSecurity = 'profile.security';
  static const profileNotifications = 'profile.notifications';
  static const profileLanguageLabel = 'profile.language_label';
  static const profileThemeLabel = 'profile.theme_label';
  static const profileHelpCenter = 'profile.help_center';
  static const profileEnglish = 'profile.english_us';
  static const profilePink = 'profile.pastel_pink';
  static const profileLoadError = 'profile.load_error';
  static const profileDeletePhotoTitle = 'profile.delete_photo_title';
  static const profileDeletePhotoContent = 'profile.delete_photo_content';

  // 🔹 Drawer
  static const drawerBabyTracking = 'drawer.baby_tracking';
  static const drawerDepression = 'drawer.depression_test';
  static const drawerBabyCry = 'drawer.baby_cry';
  static const drawerSkinDiagnosis = 'drawer.skin_diagnosis';
  static const drawerAccSettings = 'drawer.account_settings.section';
  static const drawerManageProfile = 'drawer.account_settings.manage_profile';
  static const drawerSecurity = 'drawer.account_settings.security';
  static const drawerNotifications = 'drawer.account_settings.notifications';
  static const drawerSupportInfo = 'drawer.support_info.section';
  static const drawerHelpCenter = 'drawer.support_info.help_center';
  static const drawerContactUs = 'drawer.support_info.contact_us';
  static const drawerAboutMomEase = 'drawer.support_info.about_momease';
  static const drawerPrivacyPolicy = 'drawer.support_info.privacy_policy';
  static const drawerRateApp = 'drawer.general.rate_momease';
  static const drawerShareApp = 'drawer.general.share_with_friends';
  static const drawerSendFeedback = 'drawer.general.send_feedback';
  static const drawerEnglish = 'drawer.english';
  static const drawerArabic = 'drawer.arabic';

  // 🔹 Onboarding
  static const onboardingBabyNameTitle = 'onboarding.baby_name_title';
  static const onboardingBabyNameHint = 'onboarding.baby_name_hint';
  static const onboardingDobTitle = 'onboarding.dob_title';
  static const onboardingDobSubtitle = 'onboarding.dob_subtitle';
  static const onboardingDateHint = 'onboarding.date_hint';
  static const onboardingGenderTitle = 'onboarding.gender_title';
  static const onboardingGenderSubtitle = 'onboarding.gender_subtitle';
  static const onboardingGenderBoy = 'onboarding.gender_boy';
  static const onboardingGenderGirl = 'onboarding.gender_girl';
  static const onboardingAllSetTitle = 'onboarding.all_set_title';
  static const onboardingAllSetSubtitle = 'onboarding.all_set_subtitle';
  static const onboardingNext = 'onboarding.next';
  static const onboardingStartJourney = 'onboarding.start_journey';
  static const onboardingSkip = 'onboarding.skip';
  static const onboardingStart = 'onboarding.start';
  static const onboardingScreen1Title = 'onboarding.screen_1_title';
  static const onboardingScreen1Desc = 'onboarding.screen_1_desc';
  static const onboardingScreen2Title = 'onboarding.screen_2_title';
  static const onboardingScreen2Desc = 'onboarding.screen_2_desc';
  static const onboardingScreen3Title = 'onboarding.screen_3_title';
  static const onboardingScreen3Desc = 'onboarding.screen_3_desc';
  static const onboardingScreen4Title = 'onboarding.screen_4_title';
  static const onboardingScreen4Desc = 'onboarding.screen_4_desc';

  // 🔹 Baby Profile Setup
  static const babySetupHello = 'baby_profile_setup.hello';
  static const babySetupMama = 'baby_profile_setup.mama';
  static const babySetupGetToKnow = 'baby_profile_setup.get_to_know';
  static const babySetupFirstTimeTitle = 'baby_profile_setup.first_time_title';
  static const babySetupFirstTimeYes = 'baby_profile_setup.first_time_yes';
  static const babySetupFirstTimeNo = 'baby_profile_setup.first_time_no';
  static const babySetupCountTitle = 'baby_profile_setup.baby_count_title';
  static const babySetupFeedingTitle = 'baby_profile_setup.feeding_type_title';
  static const babySetupFeedingSubtitle =
      'baby_profile_setup.feeding_type_subtitle';
  static const babySetupFeedingHint = 'baby_profile_setup.feeding_type_hint';
  static const babySetupBreast = 'baby_profile_setup.breast_feeding';
  static const babySetupFormula = 'baby_profile_setup.formula_feeding';
  static const babySetupMixed = 'baby_profile_setup.mixed_feeding';
  static const babySetupBirthTitle =
      'baby_profile_setup.birth_experience_title';
  static const babySetupBirthSub =
      'baby_profile_setup.birth_experience_subtitle';
  static const babySetupBirthHint = 'baby_profile_setup.birth_experience_hint';
  static const babySetupVaginal = 'baby_profile_setup.vaginal';
  static const babySetupCSection = 'baby_profile_setup.c_section';

  // 🔹 Children
  static const childrenMyChildren = 'children.my_children';
  static const childrenSpaceLittleOnes = 'children.space_little_ones';
  static const childrenYouHaveBabies = 'children.you_have_babies';
  static const childrenAddBaby = 'children.add_baby';
  static const childrenEditBabyInfo = 'children.edit_baby_info';
  static const childrenAddNewBaby = 'children.add_new_baby';
  static const childrenBabyFullName = 'children.baby_full_name';
  static const childrenFullNameHint = 'children.full_name_hint';
  static const childrenDateOfBirth = 'children.date_of_birth';
  static const childrenDateHint = 'children.date_hint';
  static const childrenDeliveryType = 'children.delivery_type';
  static const childrenDeliverySelect = 'children.delivery_select';
  static const childrenFeedingType = 'children.feeding_type';
  static const childrenFeedingSelect = 'children.feeding_select';
  static const childrenSaveChanges = 'children.save_changes';
  static const childrenChildInfo = 'children.child_info';
  static const childrenAddProfilePhoto = 'children.add_profile_photo';
  static const childrenRemovePhoto = 'children.remove_photo';
  static const childrenRemoveBaby = 'children.remove_baby';
  static const childrenRemoveCurrentPhoto = 'children.remove_current_photo';
  static const childrenSureRemoveBaby = 'children.sure_remove_baby';
  static const childrenCancel = 'children.cancel';
  static const childrenRemove = 'children.remove';
  static const childrenBoy = 'children.boy';
  static const childrenGirl = 'children.girl';
  static const childrenGender = 'children.gender';
  static const childrenAge = 'children.age';
  static const childrenDelivery = 'children.delivery';
  static const childrenFeeding = 'children.feeding';
  static const childrenNormal = 'children.normal';
  static const childrenCesarean = 'children.cesarean';
  static const childrenBreastfeeding = 'children.breastfeeding';
  static const childrenFormula = 'children.formula';
  static const childrenSolidFood = 'children.solid_food';
  static const childrenNameRequired = 'children.name_required';
  static const childrenSelectGender = 'children.select_gender';
  static const childrenSelectDelivery = 'children.select_delivery';
  static const childrenSelectFeeding = 'children.select_feeding';
  static const childrenSelectBirth = 'children.select_birth';
  static const childrenAddSuccess = 'children.add_success';
  static const childrenUpdateSuccess = 'children.update_success';
  static const childrenDeleteSuccess = 'children.delete_success';
  static const childrenPhotoSuccess = 'children.photo_success';
  static const childrenPhotoDeleteSuccess = 'children.photo_delete_success';
  static const childrenAddFirstBaby = 'children.add_first_baby';
  static const childrenAddFirstBabySubtitle = 'children.add_first_baby_subtitle';
  static const childrenNoBabiesYet = 'children.no_babies_yet';
  static const childrenAddYourBaby = 'children.add_your_baby';

  // 🔹 Baby Cry
  static const babyCryAppBarTitle = 'baby_cry.app_bar_title';
  static const babyCryInsightHeadline = 'baby_cry.insight_headline';
  static const babyCryInsightSubtitle = 'baby_cry.insight_subtitle';
  static const babyCryHowItWorks = 'baby_cry.how_it_works';
  static const babyCryStartRecording = 'baby_cry.start_recording';
  static const babyCryStopRecording = 'baby_cry.stop_recording';
  static const babyCryRecordingStatus = 'baby_cry.recording_status';
  static const babyCryHoldPhoneNear = 'baby_cry.hold_phone_near';
  static const babyCryTapToStart = 'baby_cry.tap_to_start';
  static const babyCryTipQuietPlace = 'baby_cry.tip_quiet_place';
  static const babyCryAnalyzingHeadline = 'baby_cry.analyzing_headline';
  static const babyCryAnalyzingSubtitle = 'baby_cry.analyzing_subtitle';
  static const babyCryResultTitle = 'baby_cry.result_title';
  static const babyCryBabyMightBe = 'baby_cry.baby_might_be';
  static const babyCryDiscomfort = 'baby_cry.discomfort';
  static const babyCryDiscomfortDesc = 'baby_cry.discomfort_desc';
  static const babyCryRecommendSteps = 'baby_cry.recommend_steps';
  static const babyCryAnalyzeAnother = 'baby_cry.analyze_another';
  static const babyCryInsightStep1 = 'baby_cry.insight_step_1';
  static const babyCryInsightStep2 = 'baby_cry.insight_step_2';
  static const babyCryInsightStep3 = 'baby_cry.insight_step_3';
  static const babyCryTip1 = 'baby_cry.tip_1';
  static const babyCryTip2 = 'baby_cry.tip_2';
  static const babyCryTip3 = 'baby_cry.tip_3';
  static const babyCryTip4 = 'baby_cry.tip_4';

  // 🔹 Depression
  static const depressionAppBarTitle = 'depression.app_bar_title';
  static const depressionCheckInTitle = 'depression.check_in_title';
  static const depressionSafeSpaceDesc = 'depression.safe_space_desc';
  static const depressionAnsNotAtAll = 'depression.ans_not_at_all';
  static const depressionAnsSeveralDays = 'depression.ans_several_days';
  static const depressionAnsHalfDays = 'depression.ans_half_days';
  static const depressionAnsEveryday = 'depression.ans_everyday';

  static const depressionQ1Query = 'depression.q1_query';
  static const depressionQ2Query = 'depression.q2_query';
  static const depressionQ3Query = 'depression.q3_query';
  static const depressionQ4Query = 'depression.q4_query';
  static const depressionQ5Query = 'depression.q5_query';
  static const depressionQ6Query = 'depression.q6_query';
  static const depressionQ7Query = 'depression.q7_query';
  static const depressionQ8Query = 'depression.q8_query';

  static const depressionPrivateTitle = 'depression.completely_private_title';
  static const depressionPrivateSubtitle =
      'depression.completely_private_subtitle';
  static const depressionNoJudgmentTitle = 'depression.no_judgment_title';
  static const depressionNoJudgmentSubtitle = 'depression.no_judgment_subtitle';
  static const depressionQuickTitle = 'depression.quick_title';
  static const depressionQuickSubtitle = 'depression.quick_subtitle';
  static const depressionStartCheckIn = 'depression.start_check_in';
  static const depressionQuestionProgress = 'depression.question_progress';
  static const depressionFinishCheckIn = 'depression.finish_check_in';
  static const depressionNextQuestion = 'depression.next_question';
  static const depressionWellbeing = 'depression.emotional_wellbeing';
  static const depressionScoreDisplay = 'depression.score_display';
  static const depressionDoingWell = 'depression.doing_well';
  static const depressionRecommendations = 'depression.gentle_recommendations';
  static const depressionRetake = 'depression.retake_check_in';
  static const depressionBackHome = 'depression.back_to_home';
  static const depressionTestTitle = 'depression.depression_test_title';
  static const depressionTestsDesc = 'depression.depression_tests_desc';
  // Severity
  static const depressionSeverityMinimal = 'depression.severity.minimal';
  static const depressionSeverityMild = 'depression.severity.mild';
  static const depressionSeverityModerate = 'depression.severity.moderate';
  static const depressionSeverityModSevere =
      'depression.severity.moderately_severe';
  static const depressionSeveritySevere = 'depression.severity.severe';
  // Result Messages
  static const depressionResultMinimal = 'depression.result_messages.minimal';
  static const depressionResultMild = 'depression.result_messages.mild';
  static const depressionResultModerate = 'depression.result_messages.moderate';
  static const depressionResultModSevere =
      'depression.result_messages.moderately_severe';
  static const depressionResultSevere = 'depression.result_messages.severe';

  // 🔹 Skin Diagnosis
  static const skinAppBarTitle = 'skin_diagnosis.app_bar_title';
  static const skinInsightHeadline = 'skin_diagnosis.insight_headline';
  static const skinInsightSubtitle = 'skin_diagnosis.insight_subtitle';
  static const skinHowItWorks = 'skin_diagnosis.how_it_works';
  static const skinCtaText = 'skin_diagnosis.cta_text';
  static const skinNoPhotoTitle = 'skin_diagnosis.no_photo_title';
  static const skinNoPhotoSubtitle = 'skin_diagnosis.no_photo_subtitle';
  static const skinAnalyzeSkin = 'skin_diagnosis.analyze_skin';
  static const skinRetakePhoto = 'skin_diagnosis.retake_photo';
  static const skinReuploadGallery = 'skin_diagnosis.reupload_gallery';
  static const skinTakePhoto = 'skin_diagnosis.take_photo';
  static const skinUploadGallery = 'skin_diagnosis.upload_gallery';
  static const skinCropPhoto = 'skin_diagnosis.crop_photo';
  static const skinAnalyzingHeadline = 'skin_diagnosis.analyzing_headline';
  static const skinAnalyzingSubtitle = 'skin_diagnosis.analyzing_subtitle';
  static const skinResultTitle = 'skin_diagnosis.result_title';
  static const skinLikelyCondition = 'skin_diagnosis.likely_condition';
  static const skinEczema = 'skin_diagnosis.eczema';
  static const skinEczemaDesc = 'skin_diagnosis.eczema_desc';
  static const skinCareTips = 'skin_diagnosis.gentle_care_tips';
  static const skinAnalyzeAnother = 'skin_diagnosis.analyze_another_photo';
  static const skinError = 'skin_diagnosis.error_occurred';
  static const skinFailedPick = 'skin_diagnosis.failed_pick_image';
  static const skinFailedCrop = 'skin_diagnosis.failed_crop_image';
  static const skinInsightStep1 = 'skin_diagnosis.insight_step_1';
  static const skinInsightStep2 = 'skin_diagnosis.insight_step_2';
  static const skinInsightStep3 = 'skin_diagnosis.insight_step_3';
  static const skinTip1 = 'skin_diagnosis.tip_1';
  static const skinTip2 = 'skin_diagnosis.tip_2';
  static const skinTip3 = 'skin_diagnosis.tip_3';
  static const skinTip4 = 'skin_diagnosis.tip_4';
  static const skinDisclaimerText = 'skin_diagnosis.disclaimer_text';
  static const skinViewHistory = 'skin_diagnosis.view_history';
  static const skinHistoryTitle = 'skin_diagnosis.history_title';
  static const skinHistoryEmpty = 'skin_diagnosis.history_empty';
  static const skinHistoryEmptySubtitle = 'skin_diagnosis.history_empty_subtitle';
  static const skinDeleteRecord = 'skin_diagnosis.delete_record';
  static const skinDeleteConfirmTitle = 'skin_diagnosis.delete_confirm_title';
  static const skinDeleteConfirmBody = 'skin_diagnosis.delete_confirm_body';
  static const skinSelectChild = 'skin_diagnosis.select_child';

  // 🔹 Notifications
  static const notificationsTitle = 'notifications.title';
  static const notificationsClearAll = 'notifications.clear_all';
  static const notificationsEmptyTitle = 'notifications.empty_title';
  static const notificationsEmptySubtitle = 'notifications.empty_subtitle';
  static const notificationsViewPost = 'notifications.view_post';

  // 🔹 Common
  static const commonViewAll = 'common.view_all';
  static const commonReadMore = 'common.read_more';
  static const commonNotes = 'common.notes';
  static const commonRetry = 'common.retry';
  static const commonLanguage = 'common.language';
  static const commonThemeMode = 'common.theme_mode';
  static const commonErrorWithDetails = 'common.error_with_details';
  static const commonContinue = 'common.continue_button';
  static const commonLogout = 'common.logout';
  static const commonVersion = 'common.momease_version';
  static const commonVersionDisplay = 'common.momease_version_display';
  static const commonShare = 'common.share';
  static const commonGuidance = 'common.guidance';
  static const commonDaySun = 'common.day_labels.sun';
  static const commonDayMon = 'common.day_labels.mon';
  static const commonDayTue = 'common.day_labels.tue';
  static const commonDayWed = 'common.day_labels.wed';
  static const commonDayThu = 'common.day_labels.thu';
  static const commonDayFri = 'common.day_labels.fri';
  static const commonDaySat = 'common.day_labels.sat';

  // 🔹 Toast
  static const toastSuccess = 'common.toast.success';
  static const toastError = 'common.toast.error';
  static const toastWarning = 'common.toast.warning';
  static const toastInfo = 'common.toast.info';
  static const toastActionFailed = 'common.toast.action_failed';
}
