import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xocobaby13/feature/profile/model/activity_item_model.dart';
import 'package:xocobaby13/feature/profile/model/activity_status_model.dart';
import 'package:xocobaby13/feature/profile/model/user_profile_data_model.dart';

class ProfileController extends GetxController {
  final Rx<ActivityStatusModel> selectedActivityStatus =
      ActivityStatusModel.ongoing.obs;

  final Rx<UserProfileDataModel> profile = const UserProfileDataModel(
    name: 'Mr. Mack',
    email: 'you@gmail.com',
    phone: '(217) 555-0113',
    description: '',
    avatarAssetPath: 'assets/onboarding/avatar_mr_raja.jpg',
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
