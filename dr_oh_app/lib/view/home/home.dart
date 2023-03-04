import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_oh_app/components/logout_btn.dart';
import 'package:dr_oh_app/components/news_api.dart';
import 'package:dr_oh_app/model/body_info_model.dart';
import 'package:dr_oh_app/model/name_model.dart';
import 'package:dr_oh_app/model/news_model.dart';
import 'package:dr_oh_app/model/user.dart';
import 'package:dr_oh_app/repository/localdata/user_repository.dart';
import 'package:dr_oh_app/view/home/all_checkup_history.dart';
import 'package:dr_oh_app/view/home/body_info.dart';
import 'package:dr_oh_app/view/home/checkup_calendar.dart';
import 'package:dr_oh_app/view/home/checkup_history.dart';
import 'package:dr_oh_app/view/home/hospital_visit.dart';
import 'package:dr_oh_app/view/home/medication.dart';
import 'package:dr_oh_app/view/mypage/edit_member_info.dart';
import 'package:dr_oh_app/view/mypage/hos_med_view.dart';
import 'package:dr_oh_app/view/survey/dementia_survey.dart';
import 'package:dr_oh_app/view/survey/diabetes_survey_page.dart';
import 'package:dr_oh_app/view/survey/stroke_survey_page.dart';
import 'package:dr_oh_app/view/survey/survey.dart';
import 'package:dr_oh_app/viewmodel/checkup_history_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //** News API
  List<NewsModel> news = [];
  bool isLoading = true;
  NewsAPI newsAPI = NewsAPI();
  Future initNews() async {
    news = await newsAPI.getNews();
  }
  // News API */

  late String id = '';

  // Desc: shared preferences 받기
  // Date: 2023-01-10
  _initSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('id') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();

    _initSharedPreferences();
    initNews().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  // Desc: Calendar Date Picker
  // 검진기록이 있는 날짜 선택, 조회용
  // 2023-01-07, youngjin lee
  // Widget _calendar() {
  //   DateTime selectedDate = DateTime.now();
  //   return Column(
  //     children: [
  //       Column(
  //         children: [
  //           SizedBox(
  //             height: 300,
  //             child: CalendarDatePicker(
  //               initialDate: selectedDate,
  //               firstDate: DateTime(2000),
  //               lastDate: DateTime.now(),
  //               onDateChanged: ((value) {
  //                 selectedDate = value;
  //               }),
  //             ),
  //           ),
  //         ],
  //       ),
  //       ElevatedButton(
  //         onPressed: () {
  //           Get.to(
  //             () => CheckupHistory(),
  //             arguments: selectedDate,
  //           );
  //         },
  //         child: const Text(
  //           '검진기록 조회',
  //           style: TextStyle(color: Colors.white),
  //         ),
  //       )
  //     ],
  //   );
  // }

  // Desc: 홈화면 섹션 구분 박스
  // 2023-01-07, youngjin lee
  BoxDecoration _borderBox() {
    return BoxDecoration(
      border: Border.all(
        style: BorderStyle.solid,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 1,
        ),
      ],
    );
  }

  Widget _sizedBox() {
    return const SizedBox(
      height: 20,
    );
  }

  // Desc: 각 박스 타이틀
  // Date: 2023-01-09
  Widget _head(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color.fromARGB(255, 239, 173, 115),
        ),
        width: Get.width,
        height: 30,
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Desc: 버튼 style
  Widget _button(dynamic path, String title) {
    return ElevatedButton(
      onPressed: () {
        Get.to(path);
      },
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  // Desc: Health 카테고리 기사 헤드라인 (NewsAPI)
  // Date: 2023-01-09
  Widget _news() {
    return Container(
      decoration: _borderBox(),
      height: 110,
      width: 350,
      child: isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [CircularProgressIndicator()],
            )
          : Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: news.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 140,
                          width: 160,
                          padding: const EdgeInsets.all(2),
                          child: Card(
                            elevation: 2,
                            color: const Color.fromARGB(255, 239, 173, 115),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: ((context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AlertDialog(
                                          scrollable: true,
                                          title: Text(news[index].title),
                                          content: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                news[index].description,
                                                maxLines: 30,
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('닫기'))
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                );
                              },
                              child: Column(
                                children: [
                                  // 뉴스 길어서 헤드라인만 보여주도록 자름
                                  // 2023-01-17
                                  Text(
                                    news[index].title,
                                    style: const TextStyle(
                                        fontSize: 17,
                                        // fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                    maxLines: 4,
                                  ),
                                  // Text(
                                  //   news[index].description,
                                  //   maxLines: 5,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
    );
  }

  // Desc: welcome 위젯 이름
  // Date: 2023-01-10
  Widget _getName(DocumentSnapshot doc) {
    final user = NameModel(name: doc['name']);
    return ListTile(
        title: Text(
      '${user.name}님 건강한 하루 되세요',
      style: const TextStyle(fontSize: 14),
      textAlign: TextAlign.center,
    ));
  }

  // Desc: 신체정보 받아오기
  // Date: 2023-01-11
  Widget _getBodyinfo(DocumentSnapshot doc) {
    final bodyinfo = doc.data().toString().contains('height')
        ? BodyInfoModel(
            id: doc['id'],
            height: doc['height'],
            weight: doc['weight'],
          )
        : BodyInfoModel(id: '', height: '', weight: '');
    return ListTile(
      title: bodyinfo.height.toString().isNotEmpty
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '키 : ${bodyinfo.height}cm',
                    style: const TextStyle(
                      fontSize: 28,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '몸무게 : ${bodyinfo.weight}kg',
                    style: const TextStyle(
                      fontSize: 28,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: const [
                Text(
                  '입력된 신체정보가 없습니다.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
    );
  }

  // Desc: 진단하러 가기 버튼
  // Date: 2023-01-18
  Widget _goToSurvey(dynamic page, String title) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            Get.to(page);
          },
          style: ElevatedButton.styleFrom(fixedSize: const Size(100, 50)),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    );
  }

  // -----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(175, 105, 152, 234),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('HOME'),
        elevation: 1,
        actions: const [LogoutBtn()],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _sizedBox(),
              Container(
                decoration: _borderBox(),
                width: 350,
                // padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 55,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('id', isEqualTo: id)
                            .snapshots(),
                        builder: ((context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final documents = snapshot.data!.docs;

                          return ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children:
                                documents.map((e) => _getName(e)).toList(),
                          );
                        }),
                      ),
                    ),
                    // Expanded(
                    //   child: SizedBox(
                    //     height: 30,
                    //     width: 20,
                    //     child: IconButton(
                    //       onPressed: () async {
                    //         UserRepository usrr = UserRepository();
                    //         UserModel user = await usrr.getUserInfo();
                    //         Get.to(EditMemberInfo(user: user));
                    //       },
                    //       icon: const Icon(
                    //         Icons.arrow_forward_ios,
                    //         size: 15,
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     TextButton(
                    //         onPressed: () {
                    //           Get.to(const AllCheckupHistory());
                    //         },
                    //         child: const Text('전체기록 보기')),
                    //   ],
                    // ),
                  ],
                ),
              ),

              _sizedBox(),
              // Container(
              //   decoration: _borderBox(),
              //   width: 350,
              // child: _calendar(),
              // ),
              const Text(
                '나의 건강상태 확인하러 가기',
                style: TextStyle(fontSize: 20),
              ),
              Container(
                  height: 150,
                  width: 250,
                  child: Image.asset('images/rating.png')),
              // Container(
              //   height: 50,
              //   width: 200,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       Get.to(Survey());
              //     },
              //     child: const Text(
              //       '확인하러 가기',
              //       style: TextStyle(
              //           color: Colors.white,
              //           fontSize: 20,
              //           fontWeight: FontWeight.bold),
              //     ),
              //   ),
              // ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _goToSurvey(DiabetesSurveyPage(surveyName: '당뇨병 검사'), '당뇨병'),
                  _goToSurvey(StrokeSurveyPage(surveyName: '뇌졸중 검사'), '뇌졸중'),
                  _goToSurvey(DementiaSurvey(), '치매'),
                ],
              ),
              _sizedBox(),
              // _head('신체정보'),
              // const SizedBox(height: 3),
              // Container(
              //   decoration: _borderBox(),
              //   height: 200,
              //   width: 350,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       SizedBox(
              //         height: 100,
              //         child: StreamBuilder<QuerySnapshot>(
              //           stream: FirebaseFirestore.instance
              //               .collection('users')
              //               .where('id', isEqualTo: id)
              //               .snapshots(),
              //           builder: ((context, snapshot) {
              //             if (!snapshot.hasData) {
              //               return const Center(
              //                 child: CircularProgressIndicator(),
              //               );
              //             }
              //             final documents = snapshot.data!.docs;

              //             return ListView(
              //               physics: const NeverScrollableScrollPhysics(),
              //               children:
              //                   documents.map((e) => _getBodyinfo(e)).toList(),
              //             );
              //           }),
              //         ),
              //       ),
              //       _button(const BodyInfo(), '입력하러 가기'),
              //     ],
              //   ),
              // ),
              _sizedBox(),
              _head('조회하기'),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: _borderBox(),
                    height: 80,
                    width: 350,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 170,
                          padding: const EdgeInsets.all(5.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(const CheckupCalendar());
                            },
                            child: const Text(
                              '검진기록',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                        Container(
                          height: 120,
                          width: 170,
                          padding: const EdgeInsets.all(5.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(const HosMedView());
                            },
                            child: const Text(
                              '내원/투약이력',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              _sizedBox(),
              _head('뉴스'),
              const SizedBox(
                height: 3,
              ),
              _news(),
            ],
          ),
        ),
      ),
    );
  }
}
