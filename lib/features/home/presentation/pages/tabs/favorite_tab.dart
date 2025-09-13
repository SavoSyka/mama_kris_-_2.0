import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_shadow_container.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/app_text_contents.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/features/home/presentation/widgets/employe_home_card.dart';
import 'package:mama_kris/features/home/presentation/widgets/search_field.dart';

class FavoriteTab extends StatefulWidget {
  const FavoriteTab({super.key});

  @override
  State<FavoriteTab> createState() => _FavoriteTabState();
}

class _FavoriteTabState extends State<FavoriteTab> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: const CustomText(
          text: AppTextContents.favoriteResumes,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // search starts
          Row(
            spacing: 16.w,
            children: [
              Expanded(
                child: SearchField(
                  controller: _searchController,
                  onChanged: (value) {
                    // логика поиска
                  },
                ),
              ),
      
              const CustomImageView(imagePath: MediaRes.btnFilter, width: 64),
            ],
          ),
          // job listing strat shere
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              separatorBuilder: (context, index) => const SizedBox(height: 16,),
      
              itemBuilder: (context, index) => const _favJobCard(),
              itemCount: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _favJobCard extends StatelessWidget {
  const _favJobCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomShadowContainer(
      horMargin: 16,
      child: Column(
        spacing: 10,
        children: [
          
          Row(
            children: [
              Expanded(child: CustomText(text: "Егорова Ирина", style: TextStyle(
                color: AppPalette.secondaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 18
              ),)),

              CustomImageView(imagePath: MediaRes.settingGearIcon, width: 28,),
            ],
          
          ),
            Row(children: [
              EmployeHomeCard(text: "Дизайнер", isSelected: false),
           CustomText(text: "19 лет")
           
            ],)
        ],
      ),
    );
  }
}
