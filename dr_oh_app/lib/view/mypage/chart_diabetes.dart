import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_oh_app/components/line_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChartDiabetes extends StatefulWidget {
  const ChartDiabetes({super.key});

  @override
  State<ChartDiabetes> createState() => _ChartDiabetesState();
}

class _ChartDiabetesState extends State<ChartDiabetes> {
  late String id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = '';
    _initSharedPreferences();
  }

  _initSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('id').toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('당뇨병 차트 기록'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      // 치매 기록 불러오기
                      .collection('result')
                      .where('category', isEqualTo: "당뇨병")
                      .where('userid', isEqualTo: id)
                      // .orderBy('date', descending: true) // 최신 10개 를 위해서 dsc으로 가져오기
                      .limit(10) // 10개만 가져오기
                      .snapshots(includeMetadataChanges: true),

                  // // >>>2st Try<<<
                  // .collection('users')
                  // .doc(data)
                  // .collection('dementia_p')
                  // // .orderBy('date', descending: false)
                  // // .limit(10)
                  // .snapshots(includeMetadataChanges: true),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Text('Error');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Loading');
                    }
                    if (snapshot.data == null) {
                      return const Text('Empty');
                    }
                    List listChart = snapshot.data!.docs.map((e) {
                      return {
                        'dateValue': e['date'],
                        'resultValue': e['result'],
                      };
                    }).toList();

                    return LineChartWidget(id: id, listChart: listChart);
                  }),
              const SizedBox(
                height: 16,
              ),
              // const DementiaBarChart()
            ],
          ),
        ),
      ),
    );
  }
}
