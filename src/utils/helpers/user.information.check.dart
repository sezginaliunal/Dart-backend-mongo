import '../../models/user/user.dart';

bool isUserInformationIncomplete(User user) {
  return user.email!.trim().isEmpty ||
      user.password!.trim().isEmpty ||
      user.username!.trim().isEmpty;
}
