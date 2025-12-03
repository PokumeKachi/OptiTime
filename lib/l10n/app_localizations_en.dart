// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'English';

  @override
  String get buttonCancel => 'Cancel';

  @override
  String get buttonCreate => 'Create';

  @override
  String get buttonConfirm => 'Confirm';

  @override
  String get newTaskDialogTitle => 'New Task';

  @override
  String get newTaskDialogTaskName => 'Name';

  @override
  String get newTaskDialogTaskGroup => 'Group';

  @override
  String get newTaskNotificationSubtitle => 'has been added to your todo list!';

  @override
  String signedInLabel(Object name) {
    return 'Signed in as $name (Tap here to log out)';
  }

  @override
  String get signInButton => 'Sign in';

  @override
  String get signOutDialogLabel => 'Signing out';

  @override
  String get signOutDialogWarning =>
      'Are you sure you want to sign out? (Your data will be preserved)';

  @override
  String get signOutSuccessNotificationTitle => 'Successfully signed out!';

  @override
  String get signOutSuccessNotificationSubtitle =>
      'Your data is now available locally only.';

  @override
  String get signOutFailureNotificationTitle => 'Something has gone wrong...';

  @override
  String get signOutFailureNotificationSubtitle => 'Sign out failed.';

  @override
  String get systemThemeMode => 'System';

  @override
  String get lightThemeMode => 'Light';

  @override
  String get darkThemeMode => 'Dark';
}
