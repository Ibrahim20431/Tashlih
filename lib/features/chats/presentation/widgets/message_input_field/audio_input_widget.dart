part of 'message_input_widget.dart';

class AudioInputWidget extends ConsumerStatefulWidget {
  const AudioInputWidget(
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
  ConsumerState<AudioInputWidget> createState() =>
      _RecordAudioInputWidgetState();
}

class _RecordAudioInputWidgetState extends ConsumerState<AudioInputWidget> {
  late final RecorderController _recorderController;

  String _path = '';
  int _seconds = 0;

  late final StopWatchTimer _audioTimer;

  final _senderTypeProvider = StateProvider((_) => MessageSenderType.recording);

  final _isRecordingPausedProvider = StateProvider((_) => false);

  @override
  void initState() {
    super.initState();

    _recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac_eld
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;

    _audioTimer = StopWatchTimer(mode: StopWatchMode.countUp);
    _recorderController.addListener(() {
      if (_recorderController.isRecording) {
        _audioTimer.onStartTimer();
      } else {
        _audioTimer.onStopTimer();
      }
    });

    _startRecording();
  }

  @override
  Widget build(BuildContext context) {
    _listenAppLifeCycleState();
    _listenCurrentAudioPlayingState();
    final senderType = ref.watch(_senderTypeProvider);
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                AppDimensions.widgetRadius,
              ),
              color: primaryColor[400],
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Expanded(
                  child: senderType == MessageSenderType.recording
                      ? Row(
                          children: [
                            TimerWidget(stream: _audioTimer.rawTime),
                            Expanded(
                              child: AudioWaveforms(
                                enableGesture: true,
                                size: const Size(double.infinity, 48),
                                recorderController: _recorderController,
                                waveStyle: const WaveStyle(
                                  waveColor: Colors.white,
                                  extendWaveform: true,
                                  showMiddleLine: false,
                                ),
                              ),
                            ),
                            Consumer(
                              builder: (_, WidgetRef ref, __) {
                                final isPaused =
                                    ref.watch(_isRecordingPausedProvider);
                                if (!isPaused) {
                                  return FieldIcon(
                                    onPressed: _pause,
                                    icon: Icons.pause_circle_outline,
                                    iconColor: Colors.white,
                                  );
                                } else {
                                  return FieldIcon(
                                    onPressed: () async {
                                      await _startRecording();
                                      _updateIsRecordingPaused(false);
                                    },
                                    icon: Icons.mic_none_rounded,
                                    iconColor: Colors.white,
                                  );
                                }
                              },
                            )
                          ],
                        )
                      : AudioMessageWidget(_path, _seconds),
                ),
                FieldIcon(
                  onPressed: _updateMessageInputType,
                  icon: Icons.delete_outline,
                  iconColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 4),
        if (senderType == MessageSenderType.recording)
          SendMessageWidget(
            icon: Icons.stop_rounded,
            onTap: _saveRecord,
          )
        else
          SendMessageWidget(
            icon: Icons.send_rounded,
            onTap: () {
              final message = MessageModel(
                receiverId: widget.recieverId,
                content: _path,
                audioSeconds: _seconds,
              );
              ref
                  .read(chatNotifierProvider(widget.collectionDoc).notifier)
                  .sendChatAudio(message, widget.orderName);
              _updateMessageInputType();
              _ensureVisible();
            },
          )
      ],
    );
  }

  Future<void> _startRecording() async {
    await _recorderController.record();
    ref.read(currentAudioPlayingProvider.notifier).state = null;
  }

  void _listenAppLifeCycleState() {
    ref.listen(appLifeCycleProvider, (_, state) {
      if (state != AppLifecycleState.resumed &&
          state != AppLifecycleState.inactive) _saveRecord();
    });
  }

  void _listenCurrentAudioPlayingState() {
    ref.listen(currentAudioPlayingProvider, (previous, next) async {
      if (previous == null && _recorderController.isRecording) _pause();
    });
  }

  void _saveRecord() async {
    final path = await _recorderController.stop(true);
    if (path != null) {
      _path = path;
      _seconds = _recorderController.recordedDuration.inSeconds;
    }
    ref.read(_senderTypeProvider.notifier).state = MessageSenderType.send;
  }

  void _pause() async {
    await _recorderController.pause();
    _updateIsRecordingPaused(true);
  }

  void _updateMessageInputType() {
    ref.read(messageInputTypeProvider.notifier).state = MessageType.text;

    // When save or delete recorded audio while audio is playing it's state remains
    // AudioPlayerState.playing when run again so make check only recorded audio
    // to update it state to AudioPlayerState.paused
    ref.read(audioStateNotifierProvider(null).notifier).isPlaying(false);
  }

  void _updateIsRecordingPaused(bool isPaused) {
    ref.read(_isRecordingPausedProvider.notifier).state = isPaused;
  }

  void _ensureVisible() {
    try {
      Scrollable.ensureVisible(
        widget.ensureVisibleKey.currentContext!,
        duration: const Duration(milliseconds: 500),
      );
    } catch (_) {}
  }

  @override
  void dispose() {
    _recorderController.dispose();
    super.dispose();
  }
}
