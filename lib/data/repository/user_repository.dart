import 'package:my_camp/data/models/user_model.dart';

import '../services/user_service.dart';

class UserRepository{
  final UserService _userService = UserService();
  Future<UserModel> fetchUser(userId){
    return _userService.fetchUser(userId: userId);
  }
  Future<void> updateUser(String userId, String name){
    return _userService.updateUser(userId, name);
  }
}