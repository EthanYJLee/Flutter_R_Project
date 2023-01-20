import 'package:dr_oh_app/components/logout_btn.dart';
import 'package:dr_oh_app/repository/localdata/user_repository.dart';
import 'package:flutter/material.dart';

class BodyInfo extends StatefulWidget {
  const BodyInfo({super.key});

  @override
  State<BodyInfo> createState() => _BodyInfoState();
}

class _BodyInfoState extends State<BodyInfo> {
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController bpController = TextEditingController();
  bool correctheight = false;
  bool correctweight = false;
  late double selectedHeight = 150;
  late double selectedWeight = 75;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    heightController.text = selectedHeight.toString();
    weightController.text = selectedWeight.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(248, 178, 200, 235),
      appBar: AppBar(
        title: const Text('신체정보 입력'),
        elevation: 1,
        actions: const [LogoutBtn()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: Column(
                    children: [
                      const Text(
                        '키를 입력하세요',
                        style: TextStyle(fontSize: 24),
                      ),
                      TextField(
                        controller: heightController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          hintText: '키(cm)',
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              correctheight = true;
                            });
                          } else {
                            setState(() {
                              correctheight = false;
                            });
                          }
                        },
                      ),
                      SliderTheme(
                        data: const SliderThemeData(
                          trackHeight: 5,
                        ),
                        child: Slider(
                            value: selectedHeight,
                            min: 100,
                            max: 220,
                            divisions: 120,
                            activeColor:
                                const Color.fromARGB(255, 96, 139, 109),
                            label: selectedHeight.round().toStringAsFixed(0),
                            onChanged: ((value) {
                              setState(() {
                                correctheight = true;
                                heightController.text = value.toString();
                                selectedHeight = value.toDouble();
                              });
                            })),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                  width: 350,
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: Column(
                    children: [
                      const Text(
                        '몸무게를 입력하세요',
                        style: TextStyle(fontSize: 24),
                      ),
                      TextField(
                        controller: weightController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          hintText: '몸무게(kg)',
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              correctweight = true;
                            });
                          } else {
                            setState(() {
                              correctweight = false;
                            });
                          }
                        },
                      ),
                      SliderTheme(
                        data: const SliderThemeData(
                          trackHeight: 5,
                        ),
                        child: Slider(
                            value: selectedWeight,
                            min: 30,
                            max: 130,
                            divisions: 100,
                            activeColor:
                                const Color.fromARGB(255, 96, 139, 109),
                            label: selectedWeight.round().toStringAsFixed(0),
                            onChanged: ((value) {
                              setState(() {
                                correctweight = true;
                                weightController.text = value.toString();
                                selectedWeight = value.toDouble();
                              });
                            })),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                    onPressed: correctheight && correctweight
                        ? () {
                            UserRepository usrr = UserRepository();
                            usrr.addAction(heightController.text.trim(),
                                weightController.text.trim());
                            _showDialog(context);
                          }
                        : null,
                    child: const Text('저장'))
              ],
            ),
          ],
        ),
      ),
    );
  }

  _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            title: const Text('입력 결과'),
            content: const Text(
              '입력이 완료되었습니다.',
            ),
            actions: [
              TextButton(
                onPressed: (() {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                }),
                child: const Text(
                  'OK',
                ),
              ),
            ],
          );
        }));
  }
}
