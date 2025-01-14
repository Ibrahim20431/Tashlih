part of 'message_input_widget.dart';


class TextInputWidget extends ConsumerStatefulWidget {
  const TextInputWidget(
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
  ConsumerState<TextInputWidget> createState() => _MessageInputWidgetState();
}

class _MessageInputWidgetState extends ConsumerState<TextInputWidget> {
  final _messageController = TextEditingController();

  late final GlobalKey _ensureVisibleKey;
  late final ChatCollectionDocModel _collectionDoc;
  late final String _chatDoc;
  late final int _recieverId;
  late final String? _orderName;

  final _senderTypeProvider = StateProvider((_) => MessageSenderType.record);

  @override
  void initState() {
    super.initState();
    _ensureVisibleKey = widget.ensureVisibleKey;
    _collectionDoc = widget.collectionDoc;
    _chatDoc = widget.chatDoc;
    _recieverId = widget.recieverId;
    _orderName = widget.orderName;

    _messageController.addListener(() {
      final val = _messageController.text.trim();
      final senderType = ref.read(_senderTypeProvider);
      if (val.isNotEmpty) {
        if (senderType == MessageSenderType.record) {
          _updateSenderType(MessageSenderType.send);
        }
      } else if (senderType == MessageSenderType.send) {
        _updateSenderType(MessageSenderType.record);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: CustomTextField(
            controller: _messageController,
            hintText: 'اكتب رسالة',
            minLines: 1,
            maxLines: 2,
            unFocusOnTapOut: false,
            onChanged: (val) {},
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FieldIcon(
                  onPressed: () async {
                    final imagePicker = ImagePickerService();
                    imagePicker.pickGalleryImage(maxSizeInMB: 10).then(
                          (image) => _sendImage(
                            image,
                            _chatDoc,
                            _recieverId,
                          ),
                        );
                  },
                  icon: Icons.image_outlined,
                ),
                FieldIcon(
                  onPressed: () {
                    final imagePicker = ImagePickerService();
                    imagePicker.pickCameraImage(maxSizeInMB: 10).then(
                          (image) => _sendImage(
                            image,
                            _chatDoc,
                            _recieverId,
                          ),
                        );
                  },
                  icon: Icons.camera_alt_outlined,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 4),
        Consumer(
          builder: ((_, WidgetRef ref, __) {
            final type = ref.watch(_senderTypeProvider);
            if (type == MessageSenderType.send) {
              return SendMessageWidget(
                icon: Icons.send_rounded,
                onTap: () {
                  final content = _messageController.text.trim();
                  if (content.isNotEmpty) {
                    final message = MessageModel(
                      receiverId: _recieverId,
                      content: content,
                    );
                    ref
                        .read(chatNotifierProvider(_collectionDoc).notifier)
                        .sendChatMessage(message, _orderName);
                    _messageController.clear();
                    _ensureVisible();
                  }
                },
              );
            } else {
              return SendMessageWidget(
                icon: Icons.mic_rounded,
                onTap: () {
                  ref.read(messageInputTypeProvider.notifier).state =
                      MessageType.audio;
                },
              );
            }
          }),
        )
      ],
    );
  }

  void _updateSenderType(MessageSenderType type) {
    ref.read(_senderTypeProvider.notifier).state = type;
  }

  void _sendImage(File? image, String chatUid, int receiverId) {
    if (image != null) {
      context
          .push(
            ChatPickedImageView(image, _collectionDoc, receiverId, _orderName),
          )
          .then((_) => _ensureVisible());
    }
  }

  void _ensureVisible() {
    try {
      Scrollable.ensureVisible(
        _ensureVisibleKey.currentContext!,
        duration: const Duration(milliseconds: 500),
      );
    } catch (_) {}
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
