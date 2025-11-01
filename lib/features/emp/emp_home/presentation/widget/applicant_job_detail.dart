import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:mama_kris/core/common/widgets/buttons/custom_button_sec.dart';
import 'package:mama_kris/core/common/widgets/custom_image_view.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/media_res.dart';

Future<String?> ApplicantJobDetail(
  BuildContext context, {
  bool showStar = true,
}) {
  GlobalKey menuKey = GlobalKey();
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
    useSafeArea: true,
    isDismissible: true,

    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: SizedBox(
          // height: MediaQuery.sizeOf(context).height ,
          child: Column(
            children: [
              const SizedBox(height: 20),
          
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    showStar
                        ? InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const CustomImageView(
                              imagePath: MediaRes.modalStarIcon,
                              width: 32,
                            ),
                          )
                        : const SizedBox.shrink(),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const CustomImageView(
                        imagePath: MediaRes.modalCloseIcon,
                        width: 32,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(36),
                    ),
                  ),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                children: [
                                  CustomText(
                                    text: 'Дизайнер инфорграфики',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w600,
                                      height: 1.30,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '6000 - 12 000 руб',
                                    style: TextStyle(
                                      color: Color(0xFF596574),
                                      fontSize: 12,
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w500,
                                      height: 1.30,
                                    ),
                                  ),
                                ],
                              ),
                              
                              InkWell(
                                onTap: () {
                                  _showJobOptionsMenu(context, menuKey);
                                },
                                child: CustomImageView(
                                  key: menuKey,
                                  imagePath: MediaRes.verticalDots,
                                  width: 20,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const CustomText(
                            text: '''Обязанности:
                        Создание инфографики для презентаций, соцсетей и маркетинговых материалов.
                          Преобразование данных в визуально понятные графики.
                          Сотрудничество с командами для реализации проектов.
                                              
                         ия:
                          Условия:
                          Условия:
                          Условия:
                          Условия:
                          Условия:
                          Условия:
                          Условия:
                          Условия:
                                              
                        Гибкий график.
                          Оформление по ТК.
                            Дружный коллектив и развитие.''',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 48),
                              
                          CustomButtonSec(
                            btnText: '',
                            child: _contactCard(
                              icon: MediaRes.telegramIcon,
                              label: 'Перейти в Telegram',
                            ),
                          ),
                          const SizedBox(height: 12),
                              
                          CustomButtonSec(
                            btnText: '',
                            child: _contactCard(
                              icon: MediaRes.whatsappIcon,
                              label: 'Перейти в WhatsApp',
                            ),
                          ),
                          const SizedBox(height: 12),
                              
                          CustomButtonSec(
                            btnText: '',
                              
                            child: _contactCard(
                              icon: MediaRes.vkIcon,
                              label: 'Перейти в VK',
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _contactCard({required String label, required String icon}) {
  return Row(
    children: [
      Center(child: CustomText(text: label)),
      CustomImageView(imagePath: icon, width: 32),
    ],
  );
}

void _showJobOptionsMenu(BuildContext context, GlobalKey menuKey) {
  final RenderBox renderBox =
      menuKey.currentContext!.findRenderObject() as RenderBox;
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
        child: const Text('Добавить в избранное'),
      ),

      PopupMenuItem(
        onTap: () {
          // Handle report
        },
        child: const Text(
          'Отправить жалобу',
          style: TextStyle(color: Colors.red),
        ),
      ),
    ],
  );
}
