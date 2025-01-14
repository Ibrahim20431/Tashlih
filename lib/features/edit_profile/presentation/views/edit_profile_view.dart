import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tashlihi/core/constants/app_colors.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_texts.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../auth/controllers/providers/cities_provider.dart';
import '../../../auth/controllers/providers/user_provider.dart';
import '../../../auth/data/models/id_name_model.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/widgets/future_dropdown.dart';
import '../../../auth/presentation/widgets/mobile_text_field.dart';
import '../../../auth/presentation/widgets/pick_user_image_widget.dart';
import '../../../profile/notifiers/profile_notifier.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  final imageProvider = StateProvider<File?>((_) => null);

  late final TextEditingController nameController;

  late final TextEditingController mobileController;

  late IdNameModel city;
  late final UserModel user;

  @override
  void initState() {
    super.initState();
    user = ref.read(userProvider)!;
    nameController = TextEditingController(text: user.name);
    mobileController = TextEditingController(text: user.mobile);
    city = user.city;
  }

  @override
  Widget build(BuildContext context) {
    _listenProfileState();
    return Scaffold(
      body: AppScaffold(
        title: 'تعديل البيانات',
        body: ListView(
          padding: const EdgeInsets.all(AppDimensions.screenPadding),
          children: [
            PickUserImageWidget(
              imageProvider: imageProvider,
              imageUrl: user.image,
            ),
            const SizedBox(height: 32),
            MobileTextField(
              controller: mobileController,
              readOnly: true,
              fillColor: AppColors.grey,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: nameController,
              labelText: 'اسم المستخدم',
              prefixIcon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 16),
            FutureDropdown(
              itemsProvider: citiesProvider,
              value: city,
              icon: Icons.location_on_outlined,
              hintText: AppTexts.choseLocation,
              onChanged: (val) => city = val!,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                ref.read(profileNotifierProvider.notifier).updateProfile(
                      name: nameController.text,
                      city: city,
                      image: ref.read(imageProvider)?.path,
                    );
              },
              child: const Text('حفظ'),
            )
          ],
        ),
      ),
    );
  }

  void _listenProfileState() {
    ref.listen(profileNotifierProvider, (_, state) {
      if (state.hasData) context.pop();
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    mobileController.dispose();
  }
}
