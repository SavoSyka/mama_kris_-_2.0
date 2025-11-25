import 'package:flutter/material.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';

class ViewPaymentScreenDetail extends StatelessWidget {
  const ViewPaymentScreenDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: "MУправление подпиской"),
      body: Container(
        child: const CustomDefaultPadding(
          child: Column(
            children: [
              Expanded(child: Column(children: [Text("Manage Subscription")])),
            ],
          ),
        ),
      ),
    );
  }
}
