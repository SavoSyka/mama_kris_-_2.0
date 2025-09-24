import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/media_res.dart';

enum FloatingMessageType { success, error, warning, info }

OverlayEntry? currentOverlayEntry;

class FloatingMessageWidget extends StatelessWidget {
  const FloatingMessageWidget({
    required this.title,
    required this.message,
    required this.onDismiss,
    required this.type,
    super.key,
  });
  final String message;
  final String title;

  final VoidCallback onDismiss;
  final FloatingMessageType type;

  @override
  Widget build(BuildContext context) {
    final Color bgColor;
    final Color borderColor;

    String icon;

    switch (type) {
      case FloatingMessageType.success:
        borderColor = const Color(0xFF31C440);
        bgColor = const Color(0xFFDDF7E0);

        icon = MediaRes.successMsgIcon;
      case FloatingMessageType.error:
        borderColor = Colors.redAccent;
        bgColor = Colors.black87;
        icon = MediaRes.errorMsgIcon;
      case FloatingMessageType.warning:
        borderColor = const Color(0xFFF7E89A);
        bgColor = const Color(0xFFFBF4CE);

        icon = MediaRes.warningMsgIcon;
      case FloatingMessageType.info:
        borderColor = const Color(0xFF417BE1);
        bgColor = const Color(0xFFDBE6F9);

        icon = icon = MediaRes.infoMsgIcon;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Dismissible(
          key: Key(message),
          onDismissed: (direction) => onDismiss(),
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                      top: 4,
                      bottom: 4,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      // border:
                      // type != FloatingMessageType.error
                      //     ? Border.all(color: borderColor)
                      //     : null,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(maxWidth: 0.88.sw),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 10,
                      children: [
                        Image.asset(icon, width: 24.w, height: 24.w),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: message,
                                maxLines: 5,
                                style: TextStyle(
                                  color: type != FloatingMessageType.error
                                      ? Colors.black.withOpacity(0.4)
                                      : Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void showToast(
  BuildContext context, {
  required String message,
  bool isError = true,
  bool isInfo = false,
  String successTitle = 'Success',
  String errorTitle = 'Error',
}) {
  var type = FloatingMessageType.success;
  var title = '';

  // isInfo: true,
  // isError: false,

  if (isInfo) {
    title = 'Info';
    type = FloatingMessageType.info;
  } else if (isError) {
    title = errorTitle;

    type = FloatingMessageType.error;
  } else {
    title = successTitle;

    type = FloatingMessageType.success;
  }

  if (currentOverlayEntry != null) {
    currentOverlayEntry?.remove();
    currentOverlayEntry = null;
  }

  void dismissOverlay() {
    if (currentOverlayEntry != null && currentOverlayEntry!.mounted) {
      currentOverlayEntry?.remove();
      currentOverlayEntry = null;
    }
  }

  currentOverlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 0.085.sh,
      right: 0,
      left: 0,
      child: FloatingMessageWidget(
        title: title,
        message: message,
        onDismiss: dismissOverlay,
        type: type,
      ),
    ),
  );

  Overlay.of(context).insert(currentOverlayEntry!);

  Future.delayed(const Duration(seconds: 8), dismissOverlay);
}



/*
/// @isError _-> true mean -- we are displaying error message by default. incase the toast message is success then isError should be false
ToastificationItem? _currentToast;
void CustomToastification(
  BuildContext context, {
  required String message,
  bool isError = true,
  bool isInfo = false,
  String successTitle = 'Success',
  String errorTitle = 'Error',
}) {
  if (_currentToast != null) {r
    toastification.dismiss(_currentToast!);
    _currentToast = null; // Reset the reference after dismissing
  }

  // Show the new toast and save its reference
  _currentToast = toastification.show(
    context: context,
    backgroundColor: isError ? Colors.black : const Color(0xFFDDF7E0),
    foregroundColor: Colors.white,
    primaryColor: isError ? Colors.red : Theme.of(context).primaryColor,
    showProgressBar: false,
    closeOnClick: true,
    type: isInfo
        ? ToastificationType.info
        : isError
            ? ToastificationType.error
            : ToastificationType.success,
    style: ToastificationStyle.flat,
    title: Text(
      isError ? errorTitle : successTitle,
      style: GoogleFonts.outfit(
        color: isError ? Colors.red : Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
    description: Text(
      message,
      style: TextStyle(
        color: isError ? Colors.white : Colors.black.withOpacity(0.4),
        fontSize: 12,
        fontFamily: 'Avenir',
        fontWeight: FontWeight.w400,
      ),
    ),
    alignment: Alignment.topLeft,
    autoCloseDuration: const Duration(seconds: 5),
    closeButtonShowType: CloseButtonShowType.none,
  );
}


*/