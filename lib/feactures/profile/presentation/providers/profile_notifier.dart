import 'package:flutter/material.dart';
import 'package:redsocial/feactures/auth/domain/entities/user.dart';
import 'package:redsocial/feactures/home/domain/entities/posts.dart';
import 'package:redsocial/feactures/profile/domain/entities/profile_data.dart';
import 'package:redsocial/feactures/profile/domain/usecase/get_profile_data_usecase.dart';

enum ProfileStatus { initial, loading, loaded, error }

class ProfileNotifier extends ChangeNotifier {
  final GetProfileDataUseCase getProfileDataUseCase;

  ProfileNotifier({required this.getProfileDataUseCase});

  ProfileStatus _status = ProfileStatus.initial;
  String? _errorMessage;
  User? _user;
  List<Posts> _posts = [];

  ProfileStatus get status => _status;
  String? get errorMessage => _errorMessage;
  User? get user => _user;
  List<Posts> get posts => _posts;

  Future<void> fetchProfileData() async {
    _status = ProfileStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final ProfileData data = await getProfileDataUseCase.call();

      _user = data.user;
      _posts = data.posts;

      _status = ProfileStatus.loaded;
      notifyListeners();

    } catch (e) {
      _status = ProfileStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}