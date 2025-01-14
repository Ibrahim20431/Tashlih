import 'dart:io' show Platform;

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/rendering.dart' show debugPrint;

import '../constants/key_enums.dart';
import 'api_service.dart';

final class FileDownloaderService {
  FileDownloaderService() {
    _init();
  }

  DownloadTask? _task;

  String? _filePath;

  final _fileDownloader = FileDownloader();

  void _init() {
    _configure();
    _configureNotification();
  }

  Future<void> _configure() {
    return _fileDownloader.configure(
      globalConfig: [(Config.requestTimeout, const Duration(minutes: 2))],
      androidConfig: [(Config.useCacheDir, Config.whenAble)],
    ).then((result) =>
        debugPrint('Download Service configuration result = $result'));
  }

  FileDownloader _configureNotification() {
    return _fileDownloader
        .registerCallbacks(
          taskNotificationTapCallback: _notificationTapCallback,
        )
        .configureNotificationForGroup(
          FileDownloader.defaultGroup,
          // When use 'enqueue' and a default group
          running: TaskNotification(
            '{filename}',
            Platform.isIOS
                ? 'جارٍ التنزيل'
                : '{progress} - سرعة {networkSpeed} - متبقي {timeRemaining}',
          ),
          complete: const TaskNotification(
            '{filename}',
            'تم التنزيل بنجاح',
          ),
          error: const TaskNotification(
            '{filename}',
            'فشل التنزيل',
          ),
          paused: const TaskNotification(
            '{filename}',
            'تم إيقاف التنزيل',
          ),
          progressBar: true,
        );
  }

  /// Process the user tapping on a notification by printing a message
  void _notificationTapCallback(Task task, NotificationType notificationType) {
    if (notificationType == NotificationType.complete) openFile();
    debugPrint(
      'Tapped notification $notificationType for taskId ${task.taskId}',
    );
  }

  Future<void> download(
    String url,
    String fileName, {
    required void Function(DownloadStatus) onStatus,
  }) async {
    await _getNotificationsPermission();

    onStatus(DownloadStatus.loading);

    _task = DownloadTask(
      url: url,
      filename: fileName,
      httpRequestMethod: 'GET',
      baseDirectory: BaseDirectory.applicationDocuments,
      updates: Updates.status,
      headers: {'Authorization': 'Bearer ${ApiService.token}'},
    );

    final result = await _fileDownloader.download(
      _task!,
      onStatus: (status) => onStatus(_getDownloadState(status)),
    );

    if (result.status == TaskStatus.complete) {
      await _moveToSharedStorage(fileName.split('.').last);
      onStatus(DownloadStatus.complete);
    }
  }

  void openFile() => _fileDownloader.openFile(filePath: _filePath);

  static DownloadStatus _getDownloadState(TaskStatus status) {
    return switch (status) {
      TaskStatus.enqueued ||
      TaskStatus.waitingToRetry ||
      TaskStatus.complete =>
        DownloadStatus.loading,
      TaskStatus.running => DownloadStatus.downloading,
      _ => DownloadStatus.failed,
    };
  }

  Future<void> _moveToSharedStorage(String extension) async {
    // add to photos library and print path
    // If you need the path, ask full permissions beforehand by calling
    final permissionType = Platform.isIOS
        ? PermissionType.iosChangePhotoLibrary
        : PermissionType.androidSharedStorage;
    PermissionStatus auth =
        await _fileDownloader.permissions.status(permissionType);
    if (auth != PermissionStatus.granted) {
      auth = await _fileDownloader.permissions.request(permissionType);
    }
    if (auth == PermissionStatus.granted) {
      _filePath = await _fileDownloader.moveToSharedStorage(
        _task!,
        SharedStorage.downloads,
      );
      debugPrint('Path in Photos Library = $_filePath');
    } else {
      debugPrint('Photo Library permission not granted');
    }
  }

  /// Attempt to get permissions if not already granted
  Future<void> _getNotificationsPermission() async {
    PermissionStatus status = await _fileDownloader.permissions.status(
      PermissionType.notifications,
    );
    if (status != PermissionStatus.granted) {
      if (await _fileDownloader.permissions
          .shouldShowRationale(PermissionType.notifications)) {
        debugPrint('Showing some rationale');
      }
      status = await _fileDownloader.permissions
          .request(PermissionType.notifications);
      debugPrint('Permission for ${PermissionType.notifications} was $status');
    }
  }
}
