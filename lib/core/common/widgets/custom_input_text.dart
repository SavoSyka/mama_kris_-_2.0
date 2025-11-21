// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/services/dependency_injection/dependency_import.dart';
import 'package:mama_kris/features/appl/app_auth/data/data_sources/auth_local_data_source.dart';

class CustomInputText extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final bool readOnly;
  final bool autoFocus;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final int minLines;
  final int maxLines;
  final String labelText;
  final bool hasGreyBg;
  final Function(String)? onChanged;
  final InputBorder? border;
  final EdgeInsetsGeometry? contentPadding;

  const CustomInputText({
    super.key,
    required this.hintText,
    this.obscureText = false,
    required this.controller,
    this.readOnly = false,
    this.autoFocus = false,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.minLines = 1,
    this.maxLines = 1,
    this.labelText = '',
    this.hasGreyBg = false,
    this.onChanged,
    this.border,
    this.contentPadding,
  });

  @override
  State<CustomInputText> createState() => _CustomInputTextState();
}

class _CustomInputTextState extends State<CustomInputText> {
  bool _showPassword = false;
  late final FocusNode _focusNode;
  late final bool _isApplicant;

  // ──────────────────────────────────────────────
  // LIGHT MODE COLORS (2025 Premium Style)
  // ──────────────────────────────────────────────
  static const Color primaryColor = Color(
    0xFF0066FF,
  ); // Bright blue (like Telegram/YouTube)
  static const Color backgroundIdle = Color(0xFFF7F7F7); // Very light gray
  static const Color backgroundFocus = Color(
    0xFFE8F0FE,
  ); // Soft blue tint when focused
  static const Color borderFocus = Color(0xFF0066FF); // Strong blue border
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color labelIdle = Color(0xFF757575);
  static const Color labelActive = Color(0xFF0066FF);
  static const Color iconIdle = Color(0xFF9E9E9E);
  static const Color iconActive = Color(0xFF0066FF);

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _togglePassword() => setState(() => _showPassword = !_showPassword);

  Future<void> getUserType() async {
    final type = await sl<AuthLocalDataSource>().getUserType();

    setState(() {
      _isApplicant = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isFocused = _focusNode.hasFocus;
    final bool hasText = widget.controller.text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ───── Label (moves color on focus or text) ─────
        if (widget.labelText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: CustomText(
              text: widget.labelText,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: (isFocused || hasText) ? labelActive : labelIdle,
              ),
            ),
          ),

        // ───── Animated Container (background + border) ─────
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: widget.hasGreyBg
                ? Colors.grey.withOpacity(0.08)
                : (isFocused ? backgroundFocus : backgroundIdle),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isFocused ? borderFocus : Colors.transparent,
              width: isFocused ? 2.0 : 1.0,
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText && !_showPassword,
            readOnly: widget.readOnly,
            autofocus: widget.autoFocus,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            style: const TextStyle(fontSize: 15.5, color: Colors.black87),
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            onChanged: (v) {
              setState(() {}); // Update label color when typing
              widget.onChanged?.call(v);
            },
            onTap: widget.onTap,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                fontSize: 15.5,
                color: textHint,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 12, right: 6),
                      child: widget.prefixIcon,
                    )
                  : null,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 24,
                minHeight: 24,
              ),

              // Password visibility toggle
              suffixIcon:
                  widget.suffixIcon ??
                  (widget.obscureText
                      ? IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: isFocused ? iconActive : iconIdle,
                            size: 22,
                          ),
                          onPressed: _togglePassword,
                        )
                      : null),

              contentPadding:
                  widget.contentPadding ??
                  const EdgeInsets.symmetric(vertical: 17, horizontal: 16),

              // Clean borders (we already handle visual with container)
              border: _inputBorder(),
              enabledBorder: _inputBorder(),
              focusedBorder: _inputBorder(),
              errorBorder: _inputBorder(color: Colors.red.shade400),
              focusedErrorBorder: _inputBorder(color: Colors.red.shade400),
            ),
          ),
        ),
      ],
    );
  }

  InputBorder _inputBorder({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color ?? Colors.transparent, width: 1),
    );
  }
}
