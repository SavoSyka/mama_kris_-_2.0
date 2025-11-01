import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCheckbox extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;
  final double scaleX;
  final double scaleY;
  final String activeIconPath; // Например: assets/checkbox/checked.svg
  final String inactiveIconPath; // Например: assets/checkbox/unchecked.svg
  final Key? iconKey; // Новый параметр

  const CustomCheckbox({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.scaleX,
    required this.scaleY,
    this.activeIconPath = 'assets/checkbox/checked.svg',
    this.inactiveIconPath = 'assets/checkbox/unchecked.svg',
    this.iconKey,
  });

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant CustomCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setState(() {
        _isChecked = widget.initialValue;
      });
    }
  }

  void _toggleCheckbox() {
    setState(() {
      _isChecked = !_isChecked;
    });
    widget.onChanged(_isChecked);
  }

  @override
  Widget build(BuildContext context) {
    // Если iconKey передан, добавляем "2" к именам файлов
    String activePath = widget.activeIconPath;
    String inactivePath = widget.inactiveIconPath;
    if (widget.iconKey != null) {
      activePath = 'assets/checkbox/checked_radio.svg';
      inactivePath = 'assets/checkbox/unchecked_radio.svg';
    }
    return GestureDetector(
      onTap: _toggleCheckbox,
      child: SvgPicture.asset(
        _isChecked ? activePath : inactivePath,
        key: widget.iconKey,
        width: 20 * widget.scaleX,
        height: 20 * widget.scaleY,
      ),
    );
  }
}
