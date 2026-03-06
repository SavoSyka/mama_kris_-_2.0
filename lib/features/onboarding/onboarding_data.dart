import 'package:mama_kris/core/constants/media_res.dart';

class OnboardingStep {
  final String title;
  final String description;
  final String backgroundImage;
  final double? hintTopPosition;
  final double? hintBottomPosition;

  const OnboardingStep({
    required this.title,
    required this.description,
    required this.backgroundImage,
    this.hintTopPosition,
    this.hintBottomPosition,
  });
}

final List<OnboardingStep> applicantOnboardingSteps = [
  const OnboardingStep(
    title: 'Рилсы',
    description:
        'Здесь отображается актуальная информация об обновлениях, статьях',
    backgroundImage: MediaRes.onboardingAppl1,
    hintBottomPosition: 80,
  ),
  const OnboardingStep(
    title: 'Поиск вакансий',
    description:
        'Мама Крис предоставляет возможность поиска вакансий в виде слайдера или в виде списка',
    backgroundImage: MediaRes.onboardingAppl2,
    hintBottomPosition: 80,
  ),
  const OnboardingStep(
    title: 'Слайдер',
    description:
        'В режиме слайдера вам будет предоставлена случайная подходящая под выбранные вами параметры вакансия',
    backgroundImage: MediaRes.onboardingAppl3,
    hintBottomPosition: 80,
  ),
  const OnboardingStep(
    title: 'Слайдер',
    description:
        'При нажатии на «Неинтересно» вакансия больше не будет отображаться',
    backgroundImage: MediaRes.onboardingAppl4,
    hintBottomPosition: 80,
  ),
  const OnboardingStep(
    title: 'Список',
    description:
        'В режиме списка вам будут предоставлены те же вакансии, но в другом формате. Для доступа к этому режиму следует оплатить подписку',
    backgroundImage: MediaRes.onboardingAppl5,
    hintBottomPosition: 80,
  ),
  const OnboardingStep(
    title: 'Вакансия',
    description:
        'При отклике вакансия автоматически добавится в ваши заказы, а в подробной информации есть ссылки для связи',
    backgroundImage: MediaRes.onboardingAppl6,
    hintBottomPosition: 80,
  ),
  const OnboardingStep(
    title: 'Поддержка',
    description:
        'Если останутся вопросы, то вы всегда сможете связаться с нашей командой или прочитать полезные материалы во вкладке «Поддержка»',
    backgroundImage: MediaRes.onboardingAppl7,
    hintBottomPosition: 80,
  ),
  const OnboardingStep(
    title: 'Мошенники',
    description:
        'Проверьте информацию о работодателе самостоятельно. Если что-то вызывает сомнение — сообщите нам.\nУдаленные вакансии добавляются автоматически с открытых источниковс помощью ИИ. Обязательно прочтите статью «Как защититься от мошенников?» в разделе «Поддержка»',
    backgroundImage: MediaRes.onboardingAppl8,
    hintBottomPosition: 80,
  ),
  const OnboardingStep(
    title: 'К вакансиям',
    description:
        'Онбординг заверешен, наша команда желает удачи в поисках работы!',
    backgroundImage: MediaRes.onboardingAppl9,
    hintBottomPosition: 80,
  ),
];

final List<OnboardingStep> employeeOnboardingSteps = [
  const OnboardingStep(
    title: 'Рилсы',
    description:
        'Здесь отображается актуальная информация об обновлениях, статьях',
    backgroundImage: MediaRes.onboardingEmp1,
    hintBottomPosition: 80,
  ),
  const OnboardingStep(
    title: 'Ваши вакансии',
    description:
        'Тут будут отображаться ваши вакансии, черновые и архивированные версии',
    backgroundImage: MediaRes.onboardingEmp2,
    hintBottomPosition: 80,
  ),
  const OnboardingStep(
    title: 'Добавление вакансии',
    description:
        'Нажмите на кнопку «Создать» и заполните всю информацию в форме',
    backgroundImage: MediaRes.onboardingEmp3,
    hintBottomPosition: 80,
  ),
  const OnboardingStep(
    title: 'Поддержка',
    description:
        'Если останутся вопросы, то вы всегда сможете прочитать связаться нашей командой или прочитать полезные материалы во вкладке «Поддержка»',
    backgroundImage: MediaRes.onboardingEmp4,
    hintBottomPosition: 80,
  ),
  const OnboardingStep(
    title: 'Разместить вакансию',
    description:
        'Онбординг заверешен, наша команда желает удачи в поисках работников!',
    backgroundImage: MediaRes.onboardingEmp5,
    hintBottomPosition: 80,
  ),
];
