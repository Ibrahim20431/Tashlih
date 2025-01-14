import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_texts.dart';
import '../../../../core/constants/key_enums.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/utils/validation_mixin.dart';
import '../../../../core/widgets/custom_radio_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../policy/policy_view.dart';
import '../../controllers/notifiers/auth_notifier.dart';
import '../../controllers/providers/cities_provider.dart';
import '../../data/models/id_name_model.dart';
import '../../data/models/register_validation_model.dart';
import '../../controllers/providers/user_type_provider.dart';
import '../widgets/future_dropdown.dart';
import '../widgets/password_text_field.dart';
import '../widgets/mobile_text_field.dart';
import '../widgets/pick_user_image_widget.dart';

class SignupView extends ConsumerStatefulWidget {
  const SignupView({super.key});

  @override
  ConsumerState<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignupView> with ValidationMixin {
  final formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final mobile = TextEditingController();
  final password = TextEditingController();
  final passwordConf = TextEditingController();

  IdNameModel? city;
  final imageProvider = StateProvider<File?>((_) => null);

  RegisterValidationModel user = const RegisterValidationModel();
  RegisterValidationModel apiValidation = const RegisterValidationModel();

  @override
  void dispose() {
    name.dispose();
    mobile.dispose();
    password.dispose();
    passwordConf.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _listenAuthState();
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPadding,
          vertical: 26,
        ),
        children: [
          PickUserImageWidget(imageProvider: imageProvider),
          const SizedBox(height: 20),
          CustomTextField(
            controller: name,
            prefixIcon: Icons.person,
            labelText: AppTexts.userName,
            keyboardType: TextInputType.name,
            validator: (val) {
              final validation = nameValidation(val);
              if (validation == null) {
                if (val?.trim() == user.name?.trim()) {
                  return apiValidation.name;
                }
              }
              return validation;
            },
          ),
          const SizedBox(height: 16),
          MobileTextField(
            controller: mobile,
            validator: (val) {
              final validation = phoneValidation(val);
              if (validation == null) {
                if (val?.trim() == user.mobile?.trim()) {
                  return apiValidation.mobile;
                }
              }
              return validation;
            },
          ),
          const SizedBox(height: 16),
          FutureDropdown(
            itemsProvider: citiesProvider,
            value: city,
            icon: Icons.location_on_rounded,
            hintText: AppTexts.choseLocation,
            validator: (val) => requiredSelectValidation(val, 'المنطقة'),
            onChanged: (val) => city = val,
          ),
          const SizedBox(height: 16),
          PasswordTextField(
            controller: password,
            labelText: AppTexts.password,
            validator: (val) {
              final validation = passwordValidation(val);
              if (validation == null) {
                if (val?.trim() == user.password?.trim()) {
                  return apiValidation.password;
                }
              }
              return validation;
            },
          ),
          const SizedBox(height: 16),
          PasswordTextField(
            controller: passwordConf,
            labelText: AppTexts.passwordConfirmation,
            validator: (val) {
              final validation = passwordConfValidation(val, password.text);
              if (validation == null) {
                if (val?.trim() == user.passwordConfirmation?.trim()) {
                  return apiValidation.passwordConfirmation;
                }
              }
              return validation;
            },
          ),
          const SizedBox(height: 16),
          const Text('أرغب في أن أكون'),
          const SizedBox(height: 8),
          Consumer(
            builder: (_, WidgetRef ref, __) {
              final type = ref.watch(userTypeProvider);
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomRadioButton(
                          value: UserType.client,
                          groupValue: type,
                          onTap: () {
                            ref.read(userTypeProvider.notifier).state =
                                UserType.client;
                          },
                          label: 'عميل',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomRadioButton(
                          value: UserType.trader,
                          groupValue: type,
                          onTap: () {
                            ref.read(userTypeProvider.notifier).state =
                                UserType.trader;
                          },
                          label: 'تاجر',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AnimatedOpacity(
                    opacity: type == UserType.trader ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Row(
                      children: [
                        SizedBox(width: 8),
                        Icon(Icons.info_rounded, color: Colors.orange),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'سيلزمك تقديم معلومات إضافية في الخطوة القادمة',
                            style: TextStyles.smallMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16)
                ],
              );
            },
          ),
          const Text(
            'بالضغط على تسجيل حساب فإنك توافق على',
            textAlign: TextAlign.center,
          ),
          Center(
            child: TextButton(
              onPressed: () => context.push(const PolicyView()),
              child: const Text('سياسة التطبيق'),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                user = RegisterValidationModel(
                  name: name.text.trim(),
                  mobile: mobile.text,
                  image: ref.read(imageProvider)?.path,
                  city: city!.id,
                  password: password.text,
                  passwordConfirmation: passwordConf.text,
                );
                final authNotifier = ref.read(authNotifierProvider.notifier);
                final type = ref.read(userTypeProvider);
                if (type == UserType.client) {
                  authNotifier.clientSignup(user);
                } else {
                  authNotifier.checkTraderData(user);
                }
              }
            },
            child: const Text(AppTexts.register),
          ),
        ],
      ),
    );
  }

  void _listenAuthState() {
    ref.listen(authNotifierProvider, (_, state) {
      if (state.error is RegisterValidationModel) {
        apiValidation = state.error as RegisterValidationModel;
        formKey.currentState!.validate();
      }
    });
  }
}
