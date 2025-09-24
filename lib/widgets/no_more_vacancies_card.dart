import 'package:flutter/material.dart';




import 'package:flutter/material.dart';

class NoMoreVacanciesCard extends StatelessWidget {
  final VoidCallback onGoToProfile;

  const NoMoreVacanciesCard({Key? key, required this.onGoToProfile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double scaleX = screenWidth / 428;
    double scaleY = screenHeight / 956;

    return Container(
      width: 395 * scaleX,
      height: 540 * scaleY,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15 * scaleX),
        boxShadow: const [
          BoxShadow(
            color: Color(0x78E7E7E7),
            offset: Offset(0, 4),
            blurRadius: 19,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 24 * scaleX),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'There are no more vacancies in the selected field for today',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22 * scaleX,
              fontWeight: FontWeight.bold,
              color: Color(0xFF343434),
              fontFamily: 'Jost',
            ),
          ),
          SizedBox(height: 16 * scaleY),
          Text(
            'But! You can look for jobs in other fields. To do this, you need to: \n1. Go to the "Profile" section\n2. Select "Edit Profile"\n3. Choose new fields',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16 * scaleX,
              color: Color(0xFF596574),
              fontFamily: 'Jost',
            ),
          ),
          SizedBox(height: 16 * scaleY),
          Text(
            'New vacancies in this field will appear tomorrow',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18 * scaleX,
              fontWeight: FontWeight.bold,
              color: Color(0xFF343434),
              fontFamily: 'Jost',
            ),
          ),
          SizedBox(height: 16 * scaleY),
          ElevatedButton(
            onPressed: onGoToProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A80E),
              padding: EdgeInsets.symmetric(
                vertical: 14 * scaleY,
                horizontal: 24 * scaleX,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12 * scaleX),
              ),
            ),
            child: Text(
              'Go to Profile',
              style: TextStyle(
                fontSize: 16 * scaleX,
                fontWeight: FontWeight.w600,
                fontFamily: 'Jost',
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
class NoMoreVacanciesCard extends StatelessWidget {
  final VoidCallback onGoToProfile;

  const NoMoreVacanciesCard({Key? key, required this.onGoToProfile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double scaleX = screenWidth / 428;
    double scaleY = screenHeight / 956;

    return Container(
      width: 395 * scaleX,
      height: 540 * scaleY,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15 * scaleX),
        boxShadow: const [
          BoxShadow(
            color: Color(0x78E7E7E7),
            offset: Offset(0, 4),
            blurRadius: 19,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 24 * scaleX),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'В выбранной сфере на сегодня больше вакансий нет',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22 * scaleX,
              fontWeight: FontWeight.bold,
              color: Color(0xFF343434),
              fontFamily: 'Jost',
            ),
          ),
          SizedBox(height: 16 * scaleY),
          Text(
            'Но! Можно поискать работу в других сферах. Для этого необходимо: \n1.Зайти в раздел "Профиль"\n2. Выбрать "Редактировать анкету"\n 3. Выбрать новые сферы',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16 * scaleX,
              color: Color(0xFF596574),
              fontFamily: 'Jost',
            ),
          ),
          SizedBox(height: 16 * scaleY),
          Text(
            'В данной сфере новые вакансии появятся завтра',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18 * scaleX,
              fontWeight: FontWeight.bold,
              color: Color(0xFF343434),
              fontFamily: 'Jost',
            ),
          ),
          SizedBox(height: 16 * scaleY),
          ElevatedButton(
            onPressed: onGoToProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00A80E),
              padding: EdgeInsets.symmetric(
                vertical: 14 * scaleY,
                horizontal: 24 * scaleX,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12 * scaleX),
              ),
            ),
            child: Text(
              'Перейти в профиль',
              style: TextStyle(
                fontSize: 16 * scaleX,
                fontWeight: FontWeight.w600,
                fontFamily: 'Jost',
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/