import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/core/common/widgets/custom_app_bar.dart';
import 'package:mama_kris/core/common/widgets/custom_default_padding.dart';
import 'package:mama_kris/core/common/widgets/custom_error_retry.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_iphone_loader.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/core/constants/media_res.dart';
import 'package:mama_kris/core/theme/app_theme.dart';
import 'package:mama_kris/features/appl/app_auth/domain/entities/user_profile_entity.dart';
import 'package:mama_kris/features/appl/appl_profile/presentation/bloc/user_bloc.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/resume_bloc.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/resume_event.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/resume_state.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/speciality_search_bloc.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/speciality_search_event.dart';
import 'package:mama_kris/features/emp/emp_resume/presentation/bloc/speciality_search_state.dart';
import 'package:share_plus/share_plus.dart';

class EmpResumeScreenDetail extends StatefulWidget {
  const EmpResumeScreenDetail({super.key, required this.userId});
  final String userId;
  @override
  _EmpResumeScreenDetailState createState() => _EmpResumeScreenDetailState();
}

class _EmpResumeScreenDetailState extends State<EmpResumeScreenDetail> {
  final GlobalKey _menuKey = GlobalKey();

  bool isLiked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUser();
  }

  // * ────────────── UI ───────────────────────
  @override
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpecialitySearchBloc, SpecialitySearchState>(
      listener: (context, state) {
        if (state is LoadedPublicPofileState) {
          setState(() {
            isLiked = state.user.isFavorite;
          });
        }
      },
      builder: (context, state) {
        if (state is SpecialitySearchLoading) {
          return CustomScaffold(
            extendBodyBehindAppBar: true,
            appBar: const CustomAppBar(title: '', alignTitleToEnd: true),
            body: Container(
              decoration: const BoxDecoration(color: AppPalette.empBgColor),

              child: const CustomDefaultPadding(
                child: Column(
                  children: [
                    Expanded(
                      child: Row(children: [Expanded(child: IPhoneLoader())]),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state is SpecialitySearchError) {
          return CustomScaffold(
            extendBodyBehindAppBar: true,
            appBar: const CustomAppBar(title: '', alignTitleToEnd: true),
            body: Container(
              decoration: const BoxDecoration(color: AppPalette.empBgColor),

              child: CustomDefaultPadding(
                child: CustomErrorRetry(onTap: _fetchUser),
              ),
            ),
          );
        }

        if (state is LoadedPublicPofileState) {
          final user = state.user;

          return CustomScaffold(
            extendBodyBehindAppBar: true,

            // ✔️ AppBar is built ONLY when user exists
            appBar: CustomAppBar(
              title: '',
              alignTitleToEnd: true,
              actions: [
                IconButton(
                  onPressed: () {
                    _onLikeOrDislikeUser(
                      isFavorited: user.isFavorite,
                      userId: user.userID.toString(),
                    );
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: AppTheme.cardDecoration.copyWith(
                      borderRadius: BorderRadius.circular(8),
                      border: isLiked
                          ? Border.all(color: AppPalette.empPrimaryColor)
                          : null,
                    ),
                    child: const CustomImageView(
                      imagePath: MediaRes.star,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    _showJobOptionsMenu(context);
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: AppTheme.cardDecoration.copyWith(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const CustomImageView(
                      imagePath: MediaRes.verticalDots,
                      width: 20,
                      height: 20,
                    ),
                  ),
                  key: _menuKey,
                ),
              ],
            ),

            body: Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: AppPalette.empBgColor),
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: CustomDefaultPadding(
                          child: Column(
                            children: [
                              _AcceptOrders(
                                name: user.name,
                                birthDate: user.birthDate,
                              ),
                              const SizedBox(height: 20),
                              _Contacts(email: user.email, phone: user.phone),
                              const SizedBox(height: 20),
                              if (user.specializations != null)
                                _Specalisations(
                                  specializations: user.specializations,
                                ),
                              const SizedBox(height: 20),
                              _Experiences(experience: user.workExperience),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _showJobOptionsMenu(BuildContext context) {
    final RenderBox renderBox =
        _menuKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        offset.dx + size.width,
        offset.dy + size.height,
      ),
      items: [
        PopupMenuItem(
          onTap: () {
            // Handle add to favorites
          },
          child: const Text('В избранное'),
        ),
        PopupMenuItem(
          onTap: () {
            // Handle share
            Share.share('Check out this job: ', subject: 'Job Opportunity');
          },
          child: const Text('Отправить жалобу'),
        ),
        PopupMenuItem(
          onTap: () {
            // Handle report
          },
          child: const Text('Скрыть', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  // * ────────────── Helpere methods ───────────────────────

  Future<void> _fetchUser() async {
    context.read<SpecialitySearchBloc>().add(
      GetUserPublicProfileEvent(userId: widget.userId),
    );
  }

  Future<void> _onLikeOrDislikeUser({
    required bool isFavorited,
    required String userId,
  }) async {
    debugPrint("On like or dislike");
    context.read<ResumeBloc>().add(
      UpdateFavoritingEvent(isFavorited: isFavorited, userId: userId),
    );
  }
}

class _AcceptOrders extends StatelessWidget {
  const _AcceptOrders({this.name, this.birthDate});
  final String? name;
  final String? birthDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              ///  Rounded Chips
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 1,
                      color: AppPalette.primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Принимает заказы',
                  style: TextStyle(
                    color: Color(0xFF2E7866),
                    fontSize: 12,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    height: 1.30,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "$name",
                style: const TextStyle(
                  color: AppPalette.primaryColor,
                  fontSize: 20,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  height: 1.30,
                ),
              ),
              const SizedBox(height: 8),

              if (birthDate != null)
                Text(
                  formatBirthDateWithAge(birthDate!),
                  style: const TextStyle(
                    color: AppPalette.greyDark,

                    fontSize: 12,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    height: 1.30,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String formatBirthDateWithAge(String birthDateStr) {
    if (birthDateStr.isEmpty) return '';

    try {
      // Parse backend format: yyyy-MM-dd
      final date = DateTime.parse(birthDateStr);
      final now = DateTime.now();

      int age = now.year - date.year;
      if (now.month < date.month ||
          (now.month == date.month && now.day < date.day)) {
        age--;
      }

      // Russian plural form logic
      String ageText;
      if (age % 10 == 1 && age % 100 != 11) {
        ageText = "$age год";
      } else if ([2, 3, 4].contains(age % 10) &&
          ![12, 13, 14].contains(age % 100)) {
        ageText = "$age года";
      } else {
        ageText = "$age лет";
      }

      // Format date into dd.MM.yyyy
      final formattedDate =
          "${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}";

      return "$formattedDate ($ageText)";
    } catch (_) {
      return birthDateStr;
    }
  }
}

class _Contacts extends StatelessWidget {
  const _Contacts({this.email, this.phone});
  final String? email;
  final String? phone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Контакты',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  height: 1.30,
                ),
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  const Icon(Icons.email, color: AppPalette.primaryColor),
                  const SizedBox(width: 16),
                  Text(
                    "$email",
                    style: const TextStyle(
                      color: Color(0xFF596574),
                      fontSize: 16,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w500,
                      height: 1.30,
                    ),
                  ),
                ],
              ),

              if (phone != null && phone!.isNotEmpty) ...[
                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(Icons.phone, color: AppPalette.primaryColor),
                    const SizedBox(width: 16),
                    Text(
                      "$phone",

                      style: const TextStyle(
                        color: Color(0xFF596574),
                        fontSize: 16,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w500,
                        height: 1.30,
                      ),
                    ),
                  ],
                ),
              ],
              // * Telegram, VK, whatsapp action cards -- left
            ],
          ),
        ],
      ),
    );
  }
}

class _Specalisations extends StatelessWidget {
  const _Specalisations({this.specializations});

  final List<String>? specializations;

  @override
  Widget build(BuildContext context) {
    // If empty or null → return nothing
    if (specializations == null || specializations!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.cardDecoration,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Специализация',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    height: 1.30,
                  ),
                ),

                const SizedBox(height: 24),

                // Dynamic items with wrap
                Wrap(
                  spacing: 8,
                  runSpacing: 12,
                  children: specializations!
                      .map((item) => _specialisationItem(item))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _specialisationItem(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0x7F2E7866)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF2E7866),
          fontSize: 12,
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
          height: 1.30,
        ),
      ),
    );
  }
}

class _Experiences extends StatelessWidget {
  final List<ApplWorkExperienceEntity>? experience;
  const _Experiences({this.experience});

  @override
  Widget build(BuildContext context) {
    if (experience == null) {
      return const SizedBox.shrink();
    } else {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: AppTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Опыт работы',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                height: 1.30,
              ),
            ),

            const SizedBox(height: 24),

            ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: experience!.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final work = experience![index];
                return _buildExperienceCard(context, work);
              },
            ),
          ],
        ),
      );
    }
  }

  Widget _buildExperienceCard(
    BuildContext context,
    ApplWorkExperienceEntity exp,
  ) {
    return GestureDetector(
      onTap: () async {
        HapticFeedback.lightImpact();
        // TODO: Navigate to edit page
        // await Navigator.push(...);
      },
      child: _expereinceItems(
        title: exp.company ?? "Компания не указана",
        position: exp.position ?? "Должность не указана",
        datePeriod: exp.isPresent == true
            ? "${exp.startDate ?? ''} — наст. время"
            : "${exp.startDate ?? ''} — ${exp.endDate ?? ''}",
      ),
    );
  }
}

Widget _expereinceItems({
  required String title,
  required String position,
  required String datePeriod,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: Color(0x7F2E7866)),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w600,
            height: 1.30,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          position,
          style: const TextStyle(
            color: AppPalette.primaryColor,
            fontSize: 12,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w600,
            height: 1.30,
          ),
        ),
        const SizedBox(height: 4),

        Text(
          datePeriod,
          style: const TextStyle(
            color: Color(0xFF596574),
            fontSize: 12,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w500,
            height: 1.30,
          ),
        ),
      ],
    ),
  );
}
