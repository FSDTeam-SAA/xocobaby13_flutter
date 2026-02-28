import 'package:app_pigeon/app_pigeon.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xocobaby13/core/constants/api_endpoints.dart';
import 'package:xocobaby13/feature/profile/model/activity_item_model.dart';
import 'package:xocobaby13/feature/profile/model/activity_status_model.dart';
import 'package:xocobaby13/feature/profile/model/user_profile_data_model.dart';

class ProfileController extends GetxController {
  final Rx<ActivityStatusModel> selectedActivityStatus =
      ActivityStatusModel.ongoing.obs;

  final AuthorizedPigeon _appPigeon = Get.find<AuthorizedPigeon>();
  bool _isFetchingProfile = false;

  final Rx<UserProfileDataModel> profile = const UserProfileDataModel(
    name: 'Mr. Mack',
    email: 'you@gmail.com',
    phone: '(217) 555-0113',
    description: '',
    avatarAssetPath: 'assets/onboarding/avatar_mr_raja.jpg',
    avatarUrl: '',
    avatarBytes: null,
  ).obs;

  final List<ActivityItemModel> _activityItems = const <ActivityItemModel>[
    ActivityItemModel(
      title: 'Crystal Lake Sanctuary',
      dateLabel: 'Feb 10, 2026',
      reviewer: 'John Mitchell',
      rating: 4.5,
      status: ActivityStatusModel.ongoing,
      imagePath:
          'https://images.unsplash.com/photo-1482192596544-9eb780fc7f66?auto=format&fit=crop&w=1200&q=80',
    ),
    ActivityItemModel(
      title: 'Crystal Lake Sanctuary',
      dateLabel: 'Feb 10, 2026',
      reviewer: 'John Mitchell',
      rating: 4.5,
      status: ActivityStatusModel.ongoing,
      imagePath:
          'https://images.unsplash.com/photo-1472396961693-142e6e269027?auto=format&fit=crop&w=1200&q=80',
    ),
    ActivityItemModel(
      title: 'Crystal Lake Sanctuary',
      dateLabel: 'Feb 10, 2026',
      reviewer: 'John Mitchell',
      rating: 4.5,
      status: ActivityStatusModel.ongoing,
      imagePath:
          'https://images.unsplash.com/photo-1439066615861-d1af74d74000?auto=format&fit=crop&w=1200&q=80',
    ),
    ActivityItemModel(
      title: 'Crystal Lake Sanctuary',
      dateLabel: 'Feb 10, 2026',
      reviewer: 'John Mitchell',
      rating: 4.5,
      status: ActivityStatusModel.upcoming,
      imagePath:
          'https://images.unsplash.com/photo-1516939884455-1445c8652f83?auto=format&fit=crop&w=1200&q=80',
    ),
    ActivityItemModel(
      title: 'Crystal Lake Sanctuary',
      dateLabel: 'Feb 10, 2026',
      reviewer: 'John Mitchell',
      rating: 4.5,
      status: ActivityStatusModel.upcoming,
      imagePath:
          'https://images.unsplash.com/photo-1508261303786-8f0679f9f359?auto=format&fit=crop&w=1200&q=80',
    ),
    ActivityItemModel(
      title: 'Crystal Lake Sanctuary',
      dateLabel: 'Feb 10, 2026',
      reviewer: 'John Mitchell',
      rating: 4.5,
      status: ActivityStatusModel.completed,
      imagePath:
          'https://images.unsplash.com/photo-1488127339777-183f1fb7f3d5?auto=format&fit=crop&w=1200&q=80',
    ),
  ];

  void setActivityStatus(ActivityStatusModel status) {
    selectedActivityStatus.value = status;
  }

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    if (_isFetchingProfile) {
      return;
    }
    _isFetchingProfile = true;

    try {
      final response = await _appPigeon.get(ApiEndpoints.getCurrentProfile);
      final statusCode = response.statusCode ?? 0;
      if (statusCode < 200 || statusCode >= 300) {
        return;
      }

      final responseBody = response.data is Map
          ? Map<String, dynamic>.from(response.data)
          : <String, dynamic>{};
      final payload = responseBody['data'];
      final data = payload is Map
          ? Map<String, dynamic>.from(payload)
          : responseBody;
      final avatarPayload = data['avatar'];
      final avatarData = avatarPayload is Map
          ? Map<String, dynamic>.from(avatarPayload)
          : <String, dynamic>{};

      String readString(dynamic value) => value?.toString().trim() ?? '';
      String pickFirstString(List<dynamic> values) {
        for (final value in values) {
          final candidate = readString(value);
          if (candidate.isNotEmpty) {
            return candidate;
          }
        }
        return '';
      }

      final fullName = pickFirstString(<dynamic>[
        data['fullName'],
        data['name'],
        data['username'],
      ]);
      final email = readString(data['email']);
      final phone = pickFirstString(<dynamic>[
        data['phone'],
        data['phoneNumber'],
      ]);
      final description = pickFirstString(<dynamic>[
        data['bio'],
        data['description'],
        data['about'],
      ]);
      final avatarUrl = pickFirstString(<dynamic>[
        avatarData['url'],
        data['avatarUrl'],
        data['avatar'],
      ]);

      final UserProfileDataModel current = profile.value;
      profile.value = current.copyWith(
        name: fullName.isNotEmpty ? fullName : current.name,
        email: email.isNotEmpty ? email : current.email,
        phone: phone.isNotEmpty ? phone : current.phone,
        description: description.isNotEmpty ? description : current.description,
        avatarUrl: avatarUrl.isNotEmpty ? avatarUrl : current.avatarUrl,
      );
    } catch (_) {
      // Keep existing profile data on error.
    } finally {
      _isFetchingProfile = false;
    }
  }

  List<ActivityItemModel> get filteredActivityItems {
    return _activityItems
        .where(
          (ActivityItemModel item) =>
              item.status == selectedActivityStatus.value,
        )
        .toList();
  }

  void updateProfile(UserProfileDataModel updatedProfile) {
    profile.value = updatedProfile;
  }

  Future<void> pickAvatarFromGallery() async {
    final XFile? picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 92,
    );
    if (picked == null) {
      return;
    }

    final UserProfileDataModel current = profile.value;
    profile.value = current.copyWith(avatarBytes: await picked.readAsBytes());
  }

  static ProfileController instance() {
    if (Get.isRegistered<ProfileController>()) {
      return Get.find<ProfileController>();
    }
    return Get.put<ProfileController>(ProfileController());
  }
}
