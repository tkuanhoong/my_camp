import 'package:image_picker/image_picker.dart';
import 'package:my_camp/data/models/user_model.dart';
import 'dart:io';
import '../services/user_service.dart';

class UserRepository {
  final ImagePicker picker = ImagePicker();
  final UserService _userService = UserService();
  Future<UserModel> fetchUser(userId) {
    return _userService.fetchUser(userId: userId);
  }

  Future<void> updateUser(String userId, String name, File? image) {
    return _userService.updateUser(userId, name, image);
  }

  Future<File?> changeImage() async {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File? image = File(pickedFile.path);
      return image;
    }
    return null;
  }
}
