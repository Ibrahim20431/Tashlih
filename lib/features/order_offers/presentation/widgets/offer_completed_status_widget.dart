import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/key_enums.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/background_downloader_service.dart';
import '../../../../core/utils/navigator_key.dart';
import 'offer_status_button.dart';

class OfferCompletedStatusWidget extends StatelessWidget {
  const OfferCompletedStatusWidget(this.id, this.name, {super.key});

  final int id;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          flex: 3,
          child: OfferStatusButton(
            color: Colors.green,
            label: 'تم التسليم',
            icon: Icons.handshake_outlined,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: OfferStatusButton(
            onPressed: _download,
            label: 'الفاتورة',
            icon: Icons.download_rounded,
            color: Colors.green,
            showDialog: false,
          ),
        )
      ],
    );
  }

  void _download() {
    final downloaderService = FileDownloaderService();
    downloaderService.download(
      '${ApiService.baseUrl}/trader/offers/$id/bill/download',
      'فاتورة $name.pdf',
      onStatus: (status) async {
        switch (status) {
          case DownloadStatus.downloading:
            navigatorKey.currentContext!.showSnackBar(
              'جار تنزيل فاتورة $name',
              color: Colors.orange,
              icon: Icons.download_rounded,
            );
          case DownloadStatus.complete:
            navigatorKey.currentContext!.showSuccessBar(
              'تم تنزيل فاتورة $name',
              action: SnackBarAction(
                label: 'فتح',
                textColor: Colors.white,
                onPressed: downloaderService.openFile,
              ),
            );
          case DownloadStatus.failed:
            navigatorKey.currentContext!.showErrorBar(
              'فشل تنزيل فاتورة $name',
              action: SnackBarAction(
                label: 'إعادة المحاولة',
                textColor: Colors.white,
                onPressed: _download,
              ),
            );
          default:
        }
      },
    );
  }
}
