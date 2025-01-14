import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../../core/constants/text_styles.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({
    super.key,
    required this.stream,
    this.textColor = Colors.white,
  });

  final Stream<int> stream;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: stream,
      initialData: 0,
      builder: (context, snap) {
        final displayTime = StopWatchTimer.getDisplayTime(
          snap.requireData,
          hours: false,
          milliSecond: false,
        );
        return Text(
          displayTime,
          style: TextStyles.smallRegular.copyWith(color: textColor),
        );
      },
    );
  }
}
