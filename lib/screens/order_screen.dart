import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mama_kris/screens/subscribtion_screen.dart';
import 'package:mama_kris/screens/main_screen.dart';
import 'package:mama_kris/widgets/custom_text_field.dart';
import 'package:mama_kris/widgets/custom_dropdown.dart';
import 'package:mama_kris/widgets/custom_checkbox.dart';
import 'package:mama_kris/utils/funcs.dart' as funcs;
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
import 'package:mama_kris/utils/job_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderScreen extends StatefulWidget {
  // Опциональные данные для предзаполнения
  final Map<String, dynamic>? prefillData;

  const OrderScreen({super.key, this.prefillData});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // Контроллеры для полей
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController telegramController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController vkController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController profileLinkController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();

  // GlobalKey для доступа к выбранным значениям из CustomMultiSelectDropdown
  final GlobalKey<CustomMultiSelectDropdownState> multiSelectKey =
      GlobalKey<CustomMultiSelectDropdownState>();

  // Состояние для чекбокса "Стоимость договорная"
  bool _isPriceNegotiable = false;

  @override
  @override
  void initState() {
    super.initState();
    _initializePrefill();
  }

  Future<void> _initializePrefill() async {
    if (widget.prefillData != null) {
      final data = widget.prefillData!;
      jobTitleController.text = data['title'] ?? "";
      descriptionController.text = data['description'] ?? "";

      // final contactData = await funcs.fetchContactDetails(
      //   userId: data['userID'],
      //   contactsId: data['contactsID'],
      // );

      // if (contactData != null) {
      //   telegramController.text = contactData['telegram'] ?? '';
      //   whatsappController.text = contactData['whatsapp'] ?? '';
      //   vkController.text = contactData['vk'] ?? '';
      //   emailController.text = contactData['email'] ?? '';
      //   phoneController.text = contactData['phone'] ?? '';
      //   profileLinkController.text = contactData['link'] ?? '';
      //
      //   // 💾 Сохраняем контактные данные в prefillData
      //   widget.prefillData!['contact'] = contactData;
      // }

      if ((data['salary'] ?? "0.00") == "0.00") {
        _isPriceNegotiable = true;
        salaryController.text = "";
      } else {
        _isPriceNegotiable = false;
        salaryController.text = data['salary'] ?? "";
      }

      final jobSpheres = widget.prefillData!['jobSpheres'] as List<dynamic>?;
      if (jobSpheres != null && jobSpheres.isNotEmpty) {
        final selectedIds = jobSpheres
            .map((sphere) => sphere['sphereID'])
            .whereType<int>()
            .toSet();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          multiSelectKey.currentState?.updateSelectedValues(selectedIds);
        });
      }

      if (mounted) setState(() {});
    }
  }

  void _onPublishPressed(BuildContext context) async {
    final jobTitle = jobTitleController.text.trim();
    final description = descriptionController.text.trim();
    final telegram = telegramController.text.trim();
    final whatsapp = whatsappController.text.trim();
    final vk = vkController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final profileLink = profileLinkController.text.trim();
    final salary = salaryController.text.trim();
    final selectedSpheres = multiSelectKey.currentState?.selectedValues ?? {};

    // --- Валидации ---
    if (jobTitle.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Название и описание обязательны")),
      );
      return;
    }

    if (selectedSpheres.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Выберите хотя бы одну сферу")),
      );
      return;
    }

    if ([
      telegram,
      whatsapp,
      vk,
      email,
      phone,
      profileLink,
    ].every((c) => c.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Укажите хотя бы один способ связи")),
      );
      return;
    }

    if (!_isPriceNegotiable && salary.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Введите оплату или выберите договорную")),
      );
      return;
    }

    try {
      // --- Подготовка контакта ---
      final newContact = {
        'telegram': telegram,
        'whatsapp': whatsapp,
        'vk': vk,
        'email': email,
        'phone': phone,
        'link': profileLink,
      };

      final oldContact = widget.prefillData?['contact'];

      final contactId = await JobService.createOrUpdateContact(
        newContactData: newContact,
        oldContactData: oldContact,
      );

      if (contactId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Ошибка при создании/обновлении контакта"),
          ),
        );
        return;
      }

      // --- Создание или обновление вакансии ---
      final jobPayload = {
        'title': jobTitle,
        'description': description,
        'salary': _isPriceNegotiable ? 0 : double.tryParse(salary) ?? 0,
        'dateTime': DateTime.now().toIso8601String(),
        'status': 'checking',
        'contactsID': contactId,
      };

      final existingJobID = widget.prefillData?['jobID'];
      final jobResponse = await JobService.createOrUpdateJob(
        jobData: jobPayload,
        jobId: existingJobID,
      );

      if (jobResponse == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ошибка при сохранении вакансии")),
        );
        return;
      }

      int jobId;
      dynamic jobStatus;

      jobId = jobResponse['jobID'];
      jobStatus = jobResponse['status'];
      // print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA       $jobId : $jobStatus");

      // print("Вакансия создана. ID: $jobId, статус: $jobStatus");

      // Сохраняем идентификатор и статус в prefillData (если необходимо)
      widget.prefillData?['jobID'] = jobId;
      widget.prefillData?['status'] = jobStatus;

      final spheresSaved = await JobService.setJobSpheres(
        jobId,
        selectedSpheres.toList(),
      );
      if (!spheresSaved) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ошибка при сохранении сфер")),
        );
        return;
      }

      // --- Переход на список вакансий ---
      if (jobStatus == "unpaid") {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (_, animation, __) => SubscribtionScreen(jobId: jobId),
            transitionsBuilder: (_, animation, __, child) {
              final tween = Tween(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeInOut));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (_, animation, __) =>
                const MainScreen(initialIndex: 1),
            transitionsBuilder: (_, animation, __, child) {
              final tween = Tween(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeInOut));
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
          (_) => false,
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ошибка при публикации. Попробуйте позже."),
        ),
      );
    }
  }

  @override
  void dispose() {
    jobTitleController.dispose();
    descriptionController.dispose();
    telegramController.dispose();
    whatsappController.dispose();
    vkController.dispose();
    emailController.dispose();
    phoneController.dispose();
    profileLinkController.dispose();
    salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Масштабирование по размерам макета (428 x 956)
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double scaleX = screenWidth / 428;
    double scaleY = screenHeight / 956;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Форма размещения заказа с прокруткой
          Positioned(
            top: 0 * scaleY,
            left: 0,
            right: 0,
            bottom: 0,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16 * scaleX,
                    vertical: 20 * scaleY,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: screenHeight - 335 * scaleY,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Заголовок
                        SizedBox(height: 75 * scaleY),
                        SizedBox(
                          width: 215 * scaleX,
                          height: 38 * scaleY,
                          child: Text(
                            "Разместите заказ",
                            style: TextStyle(
                              fontFamily: 'Jost',
                              fontWeight: FontWeight.w700,
                              fontSize: 26 * scaleX,
                              height: 1.0,
                              letterSpacing: 0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 23 * scaleY),
                        // Поле ввода "Введите название вакансии"
                        CustomTextField(
                          scaleX: scaleX,
                          scaleY: scaleY,
                          width: 396 * scaleX,
                          hintText: "Введите название вакансии",
                          isPassword: false,
                          enableToggle: false,
                          controller: jobTitleController,
                        ),
                        SizedBox(height: 20 * scaleY),
                        // Поле ввода "Описание вакансии"
                        CustomTextField(
                          scaleX: scaleX,
                          scaleY: scaleY,
                          width: 396 * scaleX,
                          height: 170 * scaleY,
                          hintText: "Описание вакансии",
                          isPassword: false,
                          enableToggle: false,
                          controller: descriptionController,
                        ),
                        SizedBox(height: 20 * scaleY),
                        // Выпадающий список "Категория" (мультивыбор)
                        CustomMultiSelectDropdown(
                          key: multiSelectKey,
                          scaleX: scaleX,
                          scaleY: scaleY,
                          width: 396 * scaleX,
                          hintText: "Категория",
                        ),
                        SizedBox(height: 10 * scaleY),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 0 * scaleY,
                            horizontal: 16 * scaleX,
                          ),
                          child: SizedBox(
                            width: 396 * scaleX,
                            height: 40 * scaleY,
                            child: Text(
                              "Заполните поля ниже,\nкуда бы Вы хотели получать отклик от исполнителей.",
                              style: TextStyle(
                                fontFamily: 'Jost',
                                fontWeight: FontWeight.w400,
                                fontSize: 14 * scaleX,
                                height: 20 / 14,
                                letterSpacing: -0.1 * scaleX,
                                color: const Color(0xFF596574),
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                        SizedBox(height: 20 * scaleY),
                        // Поле ввода "Telegram"
                        CustomTextField(
                          scaleX: scaleX,
                          scaleY: scaleY,
                          width: 396 * scaleX,
                          hintText: "Telegram",
                          isPassword: false,
                          enableToggle: false,
                          controller: telegramController,
                        ),
                        SizedBox(height: 20 * scaleY),
                        // Поле ввода "WhatsApp"
                        CustomTextField(
                          scaleX: scaleX,
                          scaleY: scaleY,
                          width: 396 * scaleX,
                          hintText: "WhatsApp",
                          isPassword: false,
                          enableToggle: false,
                          controller: whatsappController,
                        ),
                        SizedBox(height: 20 * scaleY),
                        // Поле ввода "VK"
                        CustomTextField(
                          scaleX: scaleX,
                          scaleY: scaleY,
                          width: 396 * scaleX,
                          hintText: "VK",
                          isPassword: false,
                          enableToggle: false,
                          controller: vkController,
                        ),
                        SizedBox(height: 20 * scaleY),
                        // Поле ввода "Почта"
                        CustomTextField(
                          scaleX: scaleX,
                          scaleY: scaleY,
                          width: 396 * scaleX,
                          hintText: "Почта",
                          isPassword: false,
                          enableToggle: false,
                          controller: emailController,
                        ),
                        SizedBox(height: 20 * scaleY),
                        // Поле ввода "Телефон"
                        CustomTextField(
                          scaleX: scaleX,
                          scaleY: scaleY,
                          width: 396 * scaleX,
                          hintText: "Телефон",
                          isPassword: false,
                          enableToggle: false,
                          controller: phoneController,
                        ),
                        SizedBox(height: 20 * scaleY),
                        // Поле ввода "Ссылка на анкету"
                        CustomTextField(
                          scaleX: scaleX,
                          scaleY: scaleY,
                          width: 396 * scaleX,
                          hintText: "Ссылка на анкету",
                          isPassword: false,
                          enableToggle: false,
                          controller: profileLinkController,
                        ),
                        SizedBox(height: 34 * scaleY),
                        // Чекбокс "Стоимость договорная" с суфиксом 2
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomCheckbox(
                              initialValue: _isPriceNegotiable,
                              onChanged: (bool value) {
                                setState(() {
                                  _isPriceNegotiable = value;
                                });
                              },
                              scaleX: scaleX,
                              scaleY: scaleY,
                              iconKey: const Key("checkbox2"),
                            ),
                            SizedBox(width: 10 * scaleX),
                            Container(
                              width: 275 * scaleX,
                              height: 28 * scaleY,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Стоимость договорная",
                                style: TextStyle(
                                  fontFamily: 'Jost',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18 * scaleX,
                                  height: 28 / 18,
                                  letterSpacing: -0.18 * scaleX,
                                  color: const Color(0xFF596574),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Поле для ввода зарплаты
                        SizedBox(height: 20 * scaleY),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 16 * scaleX, right: 16 * scaleX),
                          child: Container(
                            width: 466 * scaleX,
                            height: 60 * scaleY,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15 * scaleX),
                              // Если чекбокс активен, используем градиентный фон; иначе белый с тенями
                              gradient: _isPriceNegotiable
                                  ? const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color.fromRGBO(255, 255, 255, 0.5),
                                        Color.fromRGBO(255, 255, 255, 0.5),
                                      ],
                                    )
                                  : null,
                              color: _isPriceNegotiable ? null : Colors.white,
                              boxShadow: _isPriceNegotiable
                                  ? null
                                  : [
                                      BoxShadow(
                                        color: const Color(0x78E7E7E7),
                                        offset: Offset(0, 4 * scaleY),
                                        blurRadius: 19 * scaleX,
                                      ),
                                    ],
                            ),
                            child: _isPriceNegotiable
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 25 * scaleX,
                                      ),
                                      child: Text(
                                        "Укажите стоимость",
                                        style: TextStyle(
                                          fontFamily: 'Jost',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18 * scaleX,
                                          height: 28 / 18,
                                          letterSpacing: -0.18 * scaleX,
                                          color: const Color(0xff979aa099),
                                        ),
                                      ),
                                    ),
                                  )
                                : TextField(
                                    keyboardType: TextInputType.number,
                                    controller: salaryController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                        25 * scaleX,
                                        16 * scaleY,
                                        25 * scaleX,
                                        16 * scaleY,
                                      ),
                                      hintText: "Укажите стоимость",
                                      hintStyle: TextStyle(
                                        fontFamily: 'Jost',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18 * scaleX,
                                        height: 28 / 18,
                                        letterSpacing: -0.18 * scaleX,
                                        color: const Color(0xFF979AA0),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    style: TextStyle(
                                      fontFamily: 'Jost',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18 * scaleX,
                                      height: 28 / 18,
                                      letterSpacing: -0.18 * scaleX,
                                      color: const Color(0xFF979AA0),
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 40 * scaleY),
                        // Кнопка "Опубликовать"
                        Container(
                          width: 396 * scaleX,
                          height: 72 * scaleY,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFCFFFD1),
                                offset: Offset(0, 4 * scaleY),
                                blurRadius: 19 * scaleX,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(15 * scaleX),
                          ),
                          child: ElevatedButton(
                            onPressed: () => _onPublishPressed(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00A80E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  15 * scaleX,
                                ),
                              ),
                              elevation: 0,
                              padding: EdgeInsets.symmetric(
                                vertical: 20 * scaleY,
                                horizontal: 24 * scaleX,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Опубликовать',
                                    style: TextStyle(
                                      fontFamily: 'Jost',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18 * scaleX,
                                      height: 28 / 18,
                                      letterSpacing: -0.18 * scaleX,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10 * scaleX),
                                SvgPicture.asset(
                                  'assets/welcome_screen/arrow.svg',
                                  width: 32 * scaleX,
                                  height: 32 * scaleY,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20 * scaleY),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
