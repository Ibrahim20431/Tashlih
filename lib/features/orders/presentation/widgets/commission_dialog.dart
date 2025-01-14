import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/constants/text_styles.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/alert_dialog_header.dart';
import '../../../../core/widgets/info_card.dart';
import '../../../policy/policy_view.dart';
import '../../models/bank_model.dart';

class CommissionDialog extends StatefulWidget {
  const CommissionDialog({
    super.key,
    required this.bank,
    required this.onPressed,
  });

  final BankModel bank;
  final VoidCallback onPressed;

  @override
  State<CommissionDialog> createState() => _CommissionDialogState();
}

class _CommissionDialogState extends State<CommissionDialog> {
  bool agreeTerms = false;

  late final bank = widget.bank;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AlertDialogHeader(
          icon: Icons.percent_rounded,
          color: primaryColor,
          title: 'إتفاقية الرسوم',
        ),
        const SizedBox(height: 8),
        const Flexible(
          child: SingleChildScrollView(
            child: Text(
              '''
        بسم الله الرحمن الرحيم
        قال الله تعالى:" وَأَوْفُواْ بِعَهْدِ اللهِ إِذَا عَاهَدتُّمْ وَلاَ تَنقُضُواْ الأَيْمَانَ بَعْدَ تَوْكِيدِهَا وَقَدْ جَعَلْتُمُ اللهَ عَلَيْكُمْ كَفِيلاً "صدق الله العظيم
        
         * اتعهد واقسم بالله أنا المشتري أن أدفع رسوم التطبيق من قيمة البيع سواء تم البيع عن طريق الموقع أو بسببه.
        
        * كما أتعهد بدفع الرسوم خلال 10 أيام من إتمام المبايعة.
        
        ملاحظة: رسوم التطبيق هي على المشتري ولا تبرأ ذمة المشتري من الرسوم إلا في حال دفعها.
        ''',
              style: TextStyles.mediumRegular,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('العمولة'),
            InfoCard(info: '%${bank.commission}'),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('البنك'),
            InfoCard(info: bank.name),
          ],
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: bank.account));
            Fluttertoast.showToast(msg: 'تم النسخ');
          },
          child: Row(
            children: [
              const Expanded(child: Text('الحساب')),
              InfoCard(info: bank.account),
              const SizedBox(width: 4),
              const Icon(Icons.copy_rounded, size: 20)
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.warning_rounded, color: Colors.red),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'في حالة لم يتم تحويل العمولة قد يتم حظر حسابك بشكل دائم.',
              ),
            )
          ],
        ),
        CheckboxListTile(
          contentPadding: const EdgeInsets.all(0),
          visualDensity: const VisualDensity(
            horizontal: VisualDensity.minimumDensity,
            vertical: VisualDensity.minimumDensity,
          ),
          title: Row(
            children: [
              const Text('أوافق على'),
              TextButton(
                onPressed: () => context.push(const PolicyView()),
                child: const Text('الشروط'),
              )
            ],
          ),
          value: agreeTerms,
          onChanged: (bool? value) {
            setState(() {
              agreeTerms = value!;
            });
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: agreeTerms
              ? () {
                  context.pop();
                  widget.onPressed();
                }
              : null,
          child: const Text('تأكيد ارسال العرض'),
        )
      ],
    );
  }
}
