import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_input_text.dart';
import 'package:mama_kris/core/constants/media_res.dart';

class HomeSearchBox extends StatefulWidget {
  final Function(String) onChanged;

  const HomeSearchBox({super.key, required this.onChanged});

  @override
  State<HomeSearchBox> createState() => HomeSearchBoxState();
}

class HomeSearchBoxState extends State<HomeSearchBox> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomInputText(
      hintText: 'Текст',
      labelText: "Имя",
      controller: _controller,
      // onChanged: widget.onChanged,
      suffixIcon: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CustomImageView(
          imagePath: MediaRes.search,
          width: 12,
          height: 12,
        ),
      ),
    );
  }
}
