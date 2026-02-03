import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class CustomPhonePicker extends StatefulWidget {
  /// Initial phone number including country code. Example: +251912345678
  final String? initialPhoneNumber;

  /// Default country code if initialPhoneNumber is null or cannot detect
  final String defaultCountryCode;

  /// Callback when the phone number changes
  final void Function(String completeNumber)? onChanged;

  const CustomPhonePicker({
    super.key,
    this.initialPhoneNumber,
    this.defaultCountryCode = 'US',
    this.onChanged,
  });

  @override
  State<CustomPhonePicker> createState() => _CustomPhonePickerState();
}

class _CustomPhonePickerState extends State<CustomPhonePicker> {
  // State to hold the resolved ISO code and the local number part
  String _countryCode = '';
  String? _initialValue;

  @override
  void initState() {
    super.initState();
    _parseInitialPhone();
  }

  /// Parse initial phone, split it into ISO code and local number
  void _parseInitialPhone() {
    if (widget.initialPhoneNumber == null ||
        widget.initialPhoneNumber!.isEmpty) {
      _countryCode = widget.defaultCountryCode;
      _initialValue = null;
      return;
    }

    final fullNumber = widget.initialPhoneNumber!.trim();

    // Regex to split the number: +[DialCode](LocalNumber)
    final match = RegExp(r'^\+(\d+)(.*)').firstMatch(fullNumber);

    if (match != null) {
      final dialCode = match.group(1)!;
      final localNumber = match.group(2)!.trim();

      // Get the corresponding ISO code
      final isoCode = _getCountryCodeFromDial(dialCode);

      // Set state variables
      _countryCode = isoCode;
      _initialValue = localNumber.isEmpty ? null : localNumber;
    } else {
      // If no '+' prefix, assume default country and treat the whole string as local number
      _countryCode = widget.defaultCountryCode;
      _initialValue = fullNumber;
    }
  }

  /// Map dial code to ISO (e.g., '251' -> 'ET')
  String _getCountryCodeFromDial(String dialCode) {
    // NOTE: This map should ideally be generated from the IntlPhoneField's
    // internal list for comprehensive and accurate country detection.
    // This hardcoded map serves as a fix for the common cases.
    final dialToIso = {
      '1': 'US', // Also CA, etc. (IntlPhoneField handles the ambiguity)
      '44': 'GB',
      '91': 'IN',
      '251': 'ET', // Ethiopia
      '33': 'FR', // France
      '49': 'DE', // Germany
      '81': 'JP', // Japan
      '55': 'BR', // Brazil
      // Add more mappings as needed for your application
    };

    // Find the ISO code. If dial code is '1', it might be US, CA, etc.
    // We return the ISO code if found, or the current default.
    return dialToIso[dialCode] ?? widget.defaultCountryCode;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(12), // iOS pill shape
      ),
      child: IntlPhoneField(
        // FIX 1: Set the initial country based on our parsing
        initialCountryCode: _countryCode,
        // FIX 2: Set the local number part (the digits after the code)
        initialValue: _initialValue,
        disableLengthCheck: true,
  
       decoration: InputDecoration(
         hintText: 'Enter phone number',
            errorMaxLines: 3,
            hintStyle: GoogleFonts.outfit(
              color: const Color(0xFF7c7c7c),
              fontSize: 13.sp,
              fontWeight: FontWeight.normal,
            ),
            // prefixIconConstraints: const BoxConstraints(
            //   maxHeight: 32,
            //   maxWidth: 100,
            // ),
            suffixIconConstraints: const BoxConstraints(
              maxHeight: 26,
              maxWidth: 48,
            ),
            // suffixIcon: widget.suffixIcon ??
            //     (widget.isPassword
            //         ? IconButton(
            //             icon: Icon(
            //               _isPasswordVisible
            //                   ? Icons.visibility_off_outlined
            //                   : Icons.visibility_outlined,
            //               color: Colors.grey.shade500,
            //               size: 18, // make icon smaller
            //             ),
            //             onPressed: () {
            //               setState(() {
            //                 _isPasswordVisible = !_isPasswordVisible;
            //               });
            //             },
            //           )
            //         : null),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 0,
              ),
              borderRadius: BorderRadius.circular( 12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 0,
              ),
              borderRadius: BorderRadius.circular( 12),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 0,
              ),
              borderRadius: BorderRadius.circular( 12),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.transparent,
                width: 2,
              ),
              borderRadius: BorderRadius.circular( 12),
            ),
            filled: true,
            fillColor: const Color(0xFFF8F8F8),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 11,
            ),
        
          ),
    
        style: const TextStyle(fontSize: 17, color: CupertinoColors.label),
        // iOS Dropdown Styling
        dropdownIcon: const Icon(
          CupertinoIcons.chevron_down,
          color: CupertinoColors.systemGrey,
          size: 16,
        ),
        dropdownTextStyle: const TextStyle(
          fontSize: 16,
          color: CupertinoColors.label,
        ),
        // Disable autofill for iOS
        disableAutoFillHints: false,
        onChanged: (phone) {
          widget.onChanged?.call(phone.completeNumber);
        },
        onCountryChanged: (country) {
          // This must be here to ensure the flag icon updates when the user changes it
          setState(() {
            _countryCode = country.code;
          });
          debugPrint('Country changed to: ${country.name} (${country.code})');
        },
        validator: (phone) {
          if (phone?.completeNumber.isEmpty ?? true) {
            return 'Please enter a phone number';
          }
          return null;
        },
      ),
    );
  }
}
