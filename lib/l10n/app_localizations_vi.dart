// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get language => 'Tiếng Việt';

  @override
  String get buttonCancel => 'Hủy đii';

  @override
  String get buttonCreate => 'Tạo thôi nào!';

  @override
  String get buttonConfirm => 'Xác nhận nha!';

  @override
  String get newTaskDialogTitle => 'Nhiệm vụ mới';

  @override
  String get newTaskDialogTaskName => 'Tên';

  @override
  String get newTaskDialogTaskGroup => 'Nhóm';

  @override
  String get newTaskNotificationSubtitle =>
      'đã được thêm vào danh sách cần làm!';

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
  String get systemThemeMode => 'Hệ thống';

  @override
  String get lightThemeMode => 'Sáng';

  @override
  String get darkThemeMode => 'Tối';
}
