
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';

class CustomBottomSheetHeader extends StatelessWidget {
  const CustomBottomSheetHeader(
      {required this.title, required this.onClose, super.key});
  final String title;
  final VoidCallback onClose;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
        border: Border(
          bottom: BorderSide(color: Colors.black.withOpacity(0.04)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 44,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomText(
                  text: title,
                  textAlign: TextAlign.center,
                  // fontSize: 16.sp,
                  // fontWeight: FontWeight.w600,
                  // caseType: 'default',
                ),
              ),
              InkWell(
                onTap: () {
                  debugPrint('Bottom sheet tapping hit just now.');
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color.fromARGB(255, 241, 241, 241),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 30,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
//       Container(
//   height: 4,
//   decoration: BoxDecoration(
//     boxShadow: [
//       BoxShadow(
//         color: Colors.black.withOpacity(0.2),
//         blurRadius: 20,
//       ),
//     ],
//     color: Colors.white,
//   ),
// ),
        ],
      ),
    );
  }
}
