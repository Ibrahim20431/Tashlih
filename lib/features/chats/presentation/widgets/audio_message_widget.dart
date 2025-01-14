import 'dart:async' show StreamSubscription;

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/key_enums.dart';
import '../../../../core/providers/app_life_cycle_provider.dart';
import '../../../../core/widgets/circular_loading_widget.dart';
import '../../controllers/notifiers/audio_state_notifier.dart';
import '../../controllers/providers/current_audio_playing_provider.dart';
import 'input_field_icon.dart';
import 'timer_widget.dart';

class AudioMessageWidget extends ConsumerStatefulWidget {
  const AudioMessageWidget(
    this.path,
    this.audioSeconds, {
    super.key,
    this.firebasePath,
    this.foregroundColor = Colors.white,
    this.backgroundColor = primaryColor,
  });

  final String path;
  final String? firebasePath;
  final int audioSeconds;
  final Color foregroundColor;
  final MaterialColor backgroundColor;

  @override
  ConsumerState<AudioMessageWidget> createState() => _AudioMessageWidgetState();
}

class _AudioMessageWidgetState extends ConsumerState<AudioMessageWidget> {
  late final PlayerController _palyerController;
  late final StreamSubscription<PlayerState> _playerStateSubscription;

  late final StopWatchTimer _audioTimer;
  late final String _path;
  late final Color _foregroundColor;
  late final MaterialColor _backgroundColor;
  late final String? _firebasePath;

  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _path = widget.path;
    _foregroundColor = widget.foregroundColor;
    _backgroundColor = widget.backgroundColor;
    _firebasePath = widget.firebasePath;
    _palyerController = PlayerController();
    _playerStateSubscription =
        _palyerController.onPlayerStateChanged.listen((state) async {
      final isPlaying = state.isPlaying;
      if (isPlaying) {
        _audioTimer.onStartTimer();
        _updateCurrentAudioPlaying(_path);
      } else {
        _audioTimer.onStopTimer();
        final duration = await _palyerController.getDuration(
          DurationType.current,
        );
        if (duration == 0) _audioTimer.onResetTimer();
      }
      _isPlaying = isPlaying;
      _updateAudioState(isPlaying);
    });
    _preparePlayer();
    _audioTimer = StopWatchTimer(
      mode: StopWatchMode.countDown,
      presetMillisecond: StopWatchTimer.getMilliSecFromSecond(
        widget.audioSeconds,
      ), // millisecond => minute.
    );
  }

  void _preparePlayer() async {
    final audioState = ref.read(audioStateNotifierProvider(_firebasePath));
    if (audioState == AudioPlayerState.paused) {
      _palyerController.preparePlayer(
        path: widget.path,
        shouldExtractWaveform: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _listenAudioState();
    _listenCurrentAudioPlayingState();
    _listenAppLifeCycleState();
    return PopScope(
      onPopInvoked: (_) {
        if (_isPlaying) {
          _updateAudioState(false);
          // When back to chats and re open conversation page if try run
          // the same audio that was before back to chats it is stop because it
          // is the previous so make it null
          _updateCurrentAudioPlaying(null);
        }
      },
      child: Row(
        children: [
          TimerWidget(stream: _audioTimer.rawTime, textColor: _foregroundColor),
          Expanded(
            child: AudioFileWaveforms(
              size: const Size(double.infinity, 48),
              playerController: _palyerController,
              playerWaveStyle: PlayerWaveStyle(
                fixedWaveColor: Colors.grey,
                liveWaveColor: _foregroundColor,
                showSeekLine: false,
                spacing: 6,
              ),
              enableSeekGesture: false,
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
          CircleAvatar(
            backgroundColor: _backgroundColor[400],
            foregroundColor: _foregroundColor,
            child: Consumer(
              builder: (_, WidgetRef ref, __) {
                final audioState = ref.watch(
                  audioStateNotifierProvider(_firebasePath),
                );
                return switch (audioState) {
                  AudioPlayerState.playing => FieldIcon(
                      onPressed: _pause,
                      icon: Icons.pause_rounded,
                    ),
                  AudioPlayerState.paused => FieldIcon(
                      onPressed: _play,
                      icon: Icons.play_arrow_rounded,
                    ),
                  AudioPlayerState.notExist => FieldIcon(
                      onPressed: _download,
                      icon: Icons.download_rounded,
                    ),
                  AudioPlayerState.loading => CircularLoadingWidget(
                      size: 20,
                      color: _foregroundColor,
                      backgroundColor: _backgroundColor,
                    ),
                };
              },
            ),
          )
        ],
      ),
    );
  }

  void _listenAudioState() {
    ref.listen(audioStateNotifierProvider(_firebasePath), (previous, next) {
      if (previous == AudioPlayerState.loading &&
          next == AudioPlayerState.paused) {
        _palyerController.preparePlayer(
          path: _path,
          shouldExtractWaveform: true,
        );
      }
    });
  }

  void _listenCurrentAudioPlayingState() {
    ref.listen(currentAudioPlayingProvider, (previous, next) async {
      if (previous == _path) _stopPlaying();
    });
  }

  void _listenAppLifeCycleState() {
    ref.listen(appLifeCycleProvider, (_, state) {
      if (state != AppLifecycleState.resumed &&
          state != AppLifecycleState.inactive &&
          _isPlaying) _stopPlaying();
    });
  }

  void _stopPlaying() async {
    await _pause();
    _audioTimer.onStopTimer();
    _updateAudioState(false);
  }

  void _updateAudioState(bool isPlaying) {
    ref
        .read(audioStateNotifierProvider(_firebasePath).notifier)
        .isPlaying(isPlaying);
  }

  Future<void> _play() async {
    await _palyerController.startPlayer(
      finishMode: FinishMode.pause,
    );
  }

  Future<void> _pause() async {
    return _palyerController.pausePlayer();
  }

  void _download() {
    ref.read(audioStateNotifierProvider(_firebasePath).notifier).download();
  }

  void _updateCurrentAudioPlaying(String? path) {
    ref.read(currentAudioPlayingProvider.notifier).state = path;
  }

  @override
  void dispose() {
    _playerStateSubscription.cancel();
    _palyerController.dispose();
    super.dispose();
  }
}
