import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_oh_app/components/logout_btn.dart';
import 'package:dr_oh_app/model/medication_model.dart';
import 'package:dr_oh_app/viewmodel/my_history_view_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Medication extends StatefulWidget {
  const Medication({super.key});

  @override
  State<Medication> createState() => _MedicationState();
}

class _MedicationState extends State<Medication> {
  DateTimeRange? _selectedDateRange;
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _hospitalController = TextEditingController();
  TextEditingController _diseaseController = TextEditingController();
  TextEditingController _pillController = TextEditingController();
  String? _id;
  String? _docId;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _getDocId(String id) async {
    var data = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: id)
        .get();
    setState(() {
      _docId = data.docs.first.id;
      print(_docId);
    });
  }

  _initSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _id = prefs.getString('id')!;
      print(_id);
    });
    _getDocId(_id!);
  }

  Widget _customTextfield(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TextField(
        controller: controller,
        cursorColor: const Color.fromARGB(255, 254, 97, 30),
        decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          hintText: label,
        ),
      ),
    );
  }

  Widget _dateTextfield(dynamic controller, String hint) {
    return SizedBox(
      width: 165,
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: () {
          _showDateRangePickerPop();
        },
        decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          hintText: hint,
        ),
      ),
    );
  }

  Widget _getMedication(DocumentSnapshot doc) {
    final medication = doc.data().toString().contains('firstDate')
        ? MedicationModel(
            firstDate: doc['firstDate'],
            lastDate: doc['lastDate'],
            hospital: doc['hospital'],
            disease: doc['disease'],
            pill: doc['pill'],
          )
        : MedicationModel(
            firstDate: '',
            lastDate: '',
            hospital: '',
            disease: '',
            pill: '',
          );
    return ListTile(
      title: medication.firstDate.toString().isNotEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  width: 350,
                  decoration: BoxDecoration(
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
                  ),
                  child: Text(
                    '${medication.firstDate} ~ ${medication.lastDate}\n병원명: ${medication.hospital}\n병명: ${medication.disease}\n처방의약품명: ${medication.pill}',
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            )
          : Column(
              children: const [
                Text(
                  '내원이력이 없습니다.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 178, 200, 235),
      appBar: AppBar(
        title: const Text('투약이력'),
        elevation: 1,
        actions: const [LogoutBtn()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(_docId)
                    .collection('Medication')
                    .snapshots(),
                builder: ((context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final documents = snapshot.data!.docs;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children:
                            documents.map((e) => _getMedication(e)).toList(),
                      ),
                    ],
                  );
                })),
            Card(
              child: Column(
                children: [
                  Wrap(
                    direction: Axis.horizontal,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _dateTextfield(_startDateController, '시작일'),
                          _dateTextfield(_endDateController, '종료일'),
                        ],
                      )
                    ],
                  ),
                  _customTextfield(_hospitalController, '병원명'),
                  _customTextfield(_diseaseController, '병명'),
                  _customTextfield(_pillController, '처방의약품명'),
                  ElevatedButton(
                    onPressed: () {
                      MedicationModel medicationModel = MedicationModel(
                        firstDate: _startDateController.text
                            .toString()
                            .substring(0, 10),
                        lastDate:
                            _endDateController.text.toString().substring(0, 10),
                        hospital: _hospitalController.text,
                        disease: _diseaseController.text,
                        pill: _pillController.text,
                      );
                      MyHistoryViewModel.to
                          .addMedication(medicationModel, _id!);
                      Navigator.pop(context);
                    },
                    child: const Text('추가'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDateRangePickerPop() async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      currentDate: DateTime.now(),
      saveText: 'Done',
    );

    if (result != null) {
      // Rebuild the UI
      setState(() {
        _selectedDateRange = result;
        _startDateController.text = result.start.toString().substring(0, 10);
        _endDateController.text = result.end.toString().substring(0, 10);
      });
    }
  }
}
