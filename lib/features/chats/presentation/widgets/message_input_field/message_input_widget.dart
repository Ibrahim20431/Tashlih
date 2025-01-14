import 'dart:io' show File;

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/constants/key_enums.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/providers/app_life_cycle_provider.dart';
import '../../../../../core/services/image_picker_service.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../controllers/notifiers/audio_state_notifier.dart';
import '../../../controllers/notifiers/chat_notifier.dart';
import '../../../controllers/providers/current_audio_playing_provider.dart';
import '../../../controllers/providers/message_input_type_provider.dart';
import '../../../data/models/chat_collection_doc_model.dart';
import '../../../data/models/message_model.dart';
import '../audio_message_widget.dart';
import '../chat_picked_image_view.dart';
import '../input_field_icon.dart';
import '../timer_widget.dart';
import '../send_message_widget.dart';

part 'audio_input_widget.dart';
part 'text_input_widget.dart';

class MessageInputWidget extends ConsumerWidget {
  const MessageInputWidget(
    this.ensureVisibleKey,
    this.chatDoc,
    this.recieverId,
    this.collectionDoc,
    this.orderName, {
    super.key,
  });

  final GlobalKey ensureVisibleKey;
  final String chatDoc;
  final int recieverId;
  final ChatCollectionDocModel collectionDoc;
  final String? orderName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inputType = ref.watch(messageInputTypeProvider);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: inputType == MessageType.text
          ? TextInputWidget(
              ensureVisibleKey,
              chatDoc,
              recieverId,
              collectionDoc,
              orderName,
            )
          : AudioInputWidget(
              ensureVisibleKey,
              chatDoc,
              recieverId,
              collectionDoc,
              orderName,
            ),
    );
  }
}
