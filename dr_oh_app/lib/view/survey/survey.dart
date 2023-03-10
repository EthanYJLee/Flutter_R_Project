import 'package:dr_oh_app/components/logout_btn.dart';
import 'package:dr_oh_app/view/survey/diabetes_survey_page.dart';
import 'package:dr_oh_app/view/survey/dementia_survey.dart';
import 'package:dr_oh_app/view/survey/stroke_survey_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Survey extends StatelessWidget {
  const Survey({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SURVEY'),
        elevation: 1,
        actions: const [LogoutBtn()],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            _btn(DiabetesSurveyPage(surveyName: '당뇨병 검사'), '당뇨병 검사 하러가기',
                context),
            const SizedBox(
              height: 20,
            ),
            // Date: 2023-01-10, SangwonKim
            // Desc: 뇌졸중 페이지로 가기
            _btn(
                StrokeSurveyPage(surveyName: '뇌졸중 검사'), '뇌졸중 검사 하러가기', context),
            const SizedBox(
              height: 20,
            ),
            _btn(DementiaSurvey(), '치매 검사 하러가기', context),
          ],
        ),
      ),
    );
  } // build

  //---------Widget-----------
  // Date: 2023-01-08, anna
  // survey tab: 각 설문지로 보내는 버튼 생성
  Widget _btn(dynamic page, String title, BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      style: ElevatedButton.styleFrom(
        // foregroundColor: Colors.white,
        // Date: 2023-01-11, SangwonKim
        // Desc: Get.width, Get.height 로 버튼 사이즈 조정
        minimumSize: Size(Get.width / 100 * 90, Get.height / 100 * 22),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              // fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  } //_btn

}//End
