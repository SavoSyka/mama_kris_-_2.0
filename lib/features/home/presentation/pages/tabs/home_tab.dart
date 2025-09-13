import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_action_button.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/features/home/presentation/widgets/add_job.dart';
import 'package:mama_kris/features/home/presentation/widgets/employe_home_card.dart';
import 'package:mama_kris/features/home/presentation/widgets/empty_posted_job.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<String> _tabList = [
    AppTextContents.active,
    AppTextContents.drafts,
    AppTextContents.archive,
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: CustomDefaultPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: AppTextContents.vacancies,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final item = _tabList[index];

                        return EmployeHomeCard(
                          text: _tabList[index],
                          isSelected: _selectedIndex == index,
                          onTap: () {
                            if (index != _selectedIndex) {
                              setState(() {
                                _selectedIndex = index;
                              });
                            }
                          },
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      itemCount: _tabList.length,
                    ),
                  ),

                  //  Row(
                  //   spacing: 10,
                  //   children: [
                  //     EmployeHomeCard(text: AppTextContents.active),
                  //     EmployeHomeCard(text: AppTextContents.drafts),
                  //     EmployeHomeCard(text: AppTextContents.archive),
                  //   ],
                  // ),
                ),

                const AddJob(),
              ],
            ),

            const EmptyPostedJob(),   
            SizedBox(height: 24.h,),
            const CustomActionButton(
              btnText: AppTextContents.createJob,
              isSecondaryPrimary: true,
              isSecondary: false,
              suffix: CustomImageView(
                imagePath: MediaRes.plusCircle,
                width: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
