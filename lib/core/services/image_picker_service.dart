import 'dart:io' show File;

import 'package:image_picker/image_picker.dart';

import '../../core/extensions/context_extension.dart';
import '../utils/navigator_key.dart';

final class ImagePickerService {
  final ImagePicker _imagePicker = ImagePicker();

  final int _mbConvert = 1048576;
  final int _imageQuality = 70;
  final _context = navigatorKey.currentContext!;

  Future<File?> pickImage(ImageSource source) async {
    final xFile = await _imagePicker.pickImage(source: source);
    if (xFile != null && _allowedExtensions(xFile.path)) {
      return File(xFile.path);
    }
    return null;
  }

  Future<File?> pickGalleryImage({int? maxSizeInMB}) async {
    final xFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: _imageQuality,
    );
    return _checkAllowedSize(xFile, maxSizeInMB);
  }

  Future<List<File>> pickMultiImage() async {
    final xFiles = await _imagePicker.pickMultiImage();
    final List<File> files = [];
    for (final f in xFiles) {
      if (_allowedExtensions(f.path)) {
        files.add(File(f.path));
        continue;
      }
      return [];
    }
    return files;
  }

  Future<File?> pickCameraImage({int? maxSizeInMB}) async {
    final xFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: _imageQuality,
    );
    return _checkAllowedSize(xFile, maxSizeInMB);
  }

  Future<File?> _checkAllowedSize(XFile? xFile, int? maxSizeInMB) async {
    if (xFile != null) {
      if (_allowedExtensions(xFile.path)) {
        if (maxSizeInMB != null) {
          final allowedSize = await _allowedSize(maxSizeInMB, xFile);
          if (!allowedSize) return null;
        }
        return File(xFile.path);
      }
    }
    return null;
  }

  bool _allowedExtensions(String path) {
    final allowed = switch (path.split('.').last.toLowerCase()) {
      'png' => true,
      'jpg' => true,
      'jpeg' => true,
      _ => false,
    };
    if (!allowed) {
      _context.showErrorBar(
        'يجب أن تكون صيغة الصورة png, jpg أو jpeg',
      );
    }
    return allowed;
  }

  Future<bool> _allowedSize(int maxSizeInMB, XFile xFile) {
    return xFile.length().then((fileSize) {
      if (fileSize > maxSizeInMB * _mbConvert) {
        _context.showErrorBar(
          'يجب أن لا يتعدى حجم الصورة $maxSizeInMB MB',
        );
        return false;
      }
      return true;
    });
  }
}
