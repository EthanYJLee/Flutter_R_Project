import 'package:flutter/material.dart';

class DUserInfo extends StatefulWidget {
  final PageController pageCont;
  const DUserInfo({super.key, required this.pageCont});

  @override
  State<DUserInfo> createState() => _DUserInfoState();
}

class _DUserInfoState extends State<DUserInfo> {
  late TextEditingController ageCont;
  late TextEditingController heightCont;
  late TextEditingController weightCont;
  int curyear = DateTime.now().year;
  RegExp ageReg = RegExp(r"^[0-9]{4}$"); //숫자만 4자리
  late bool correctYear;
  late bool correctHeight;
  late bool correctWeight;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ageCont = TextEditingController();
    heightCont = TextEditingController();
    weightCont = TextEditingController();
    correctYear = false;
    correctWeight=false;
    correctHeight=false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '신체 정보 입력',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(
              width: 100,
              child: TextField(
                controller: ageCont,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (ageReg.hasMatch(value) && int.parse(value) <= curyear) {
                    setState(() {
                      correctYear = true;
                    });
                  } else {
                    setState(() {
                      correctYear = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: ageCont.text.trim().isEmpty
                      ? '출생년도 4자리'
                      : correctYear
                          ? ''
                          : '출생년도를 정확히 입력하세요.',
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: TextField(
                controller: heightCont,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: '키(cm)',
                ),
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      correctHeight=false;
                    });
                  }else {
                    setState(() {
                      correctHeight=true;
                    });
                  }
                },
              ),
            ),
            SizedBox(
              width: 100,
              child: TextField(
                controller: weightCont,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: '몸무게(kg)',
                ),
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      correctWeight=false;
                    });
                  }else {
                    setState(() {
                      correctWeight=true;
                    });
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: correctYear&&correctHeight&&correctWeight?
              () {
                //if로 한번 더 감싸기(개인정보보호법 둘 다 클릭 완료 시 넘어감)
                if (widget.pageCont.hasClients) {
                  widget.pageCont.animateToPage(
                    2,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                }
              }:null,
              child: const Text(
                '다음',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
