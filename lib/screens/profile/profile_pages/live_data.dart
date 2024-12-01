import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hdlive/models/Brodcast_Model.dart';
import 'package:hdlive/models/beans_model.dart';
import 'package:hdlive/models/livedatamodel.dart';
import 'package:hdlive/screens/profile/profile_pages/progressbar_widget/progress_widget.dart';
import 'package:hdlive/screens/shared/loading.dart';
import 'package:hdlive/services/brodcast_service.dart';
import 'package:hdlive/services/profile_update_services.dart';
import 'package:hdlive/services/token_manager_services.dart';
import 'package:intl/intl.dart';

import 'chart_data.dart';

class LiveData extends StatefulWidget {
  LiveData({this.id});

  String? id;

  @override
  State<LiveData> createState() => _LiveDataState();
}

class _LiveDataState extends State<LiveData> {
  String? dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();

  TextEditingController _timeController = TextEditingController();
  BeansModel? beansModel;
  bool loading = true;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        backgroundColor: Colors.white,
        title: Text(
          "Live Data",
          style: TextStyle(
              color: Colors.red.shade900,
              fontSize: 25.sp,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<LiveDataModel>(
                future: BrodcastService().getLiveData(widget.id!).then((e)=>e??LiveDataModel()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                "Monthly Report",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 23.sp),
                              ),
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            Container(
                              height: 50.h,
                              width: 150.w,
                              child: Theme(
                                data: ThemeData(primarySwatch: Colors.red),
                                child: DateTimePicker(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Pick Date",
                                    hintStyle: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onChanged: (val) {},
                                  type: DateTimePickerType.date,
                                  dateMask: 'd MMM, yyyy',
                                  initialDate: DateTime.now(),
                                  controller: _dateController,
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2050),
                                  icon: Icon(Icons.event),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.black54,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Beans',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade900),
                          ),
                        ),
                        Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: double.infinity,
                            child: ChartWidget()),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            "Monthly Report",
                            style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade900),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.black26,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'The Minimum target For This Month has not been \n reached yet. Please go for it.',
                            style: TextStyle(color: Colors.black45),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              Text(
                                'Audio Days(s)',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '(${snapshot.data?.data?.totalAudioDays}/15 days)',
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /*Text(
                                "0 d",
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 15),
                              ),*/
                              Expanded(child: MyDeliveryProgress(sliderValue:getSliderValue(snapshot.data!.data!.totalAudioDays!.replaceAll(" days", ""),15))),
                              Text(
                                "1 mth",
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              Text(
                                'Audio Live',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18.sp),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '(${snapshot.data?.data?.totalAudioHours}/50 hours)',
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.sp),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                             /* Text(
                                "0 d",
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 15.sp),
                              ),*/
                              Expanded(child: MyDeliveryProgress(sliderValue:getHoursToValue(snapshot?.data?.data?.totalAudioHours??"",50))),
                              Text(
                                "1 mth",
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 15.sp),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              Text(
                                'Beans',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18.sp),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Total - ${snapshot.data?.data?.totalBaans}',
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.sp),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /*Text(
                                "0 d",
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 15.sp),
                              ),*/
                              Expanded(child: MyDeliveryProgress(sliderValue:getSliderValue(snapshot.data!.data!.totalBaans.toString().replaceAll(",", ""),100000))),
                              Text(
                                "1 mth",
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 15.sp),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              Text(
                                'Video Days(s)',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '(${snapshot.data?.data?.totalVideoDays}/15 days)',
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                             /* Text(
                                "0 d",
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 15),
                              ),*/
                              Expanded(child: MyDeliveryProgress(sliderValue:getSliderValue(snapshot.data!.data!.totalVideoDays!.replaceAll(" days", ""),15))),
                              Text(
                                "1 mth",
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              Text(
                                'Video Live',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 18.sp),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '(${snapshot.data!.data!.totalVideoHours}/30 hours)',
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.sp),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            /*  Text(
                                "0 d",
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 15.sp),
                              ),*/
                              Expanded(child: MyDeliveryProgress(sliderValue:getHoursToValue(snapshot?.data?.data?.totalVideoHours??"",30))),
                              Text(
                                "1 mth",
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 15.sp),
                              ),
                            ],
                          ),
                        ),


                        // Row(
                        //   children: [
                        //     Text(
                        //       'Time',
                        //       textAlign: TextAlign.start,
                        //       style: TextStyle(
                        //           fontSize: 28.sp,
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.red.shade900),
                        //     ),
                        //     SizedBox(
                        //       width: 10.w,
                        //     ),
                        //     Text(
                        //       '0/40 hours',
                        //       style: TextStyle(
                        //           color: Colors.black45,
                        //           fontWeight: FontWeight.w400,
                        //           fontSize: 15.sp),
                        //     ),
                        //   ],
                        // ),
                        // Container(
                        //     height: MediaQuery.of(context).size.height * 0.2,
                        //     width: MediaQuery.of(context).size.width,
                        //     child: ChartWidget2()),
                      ],
                    );
                  } else {
                    return Loading();
                  }
                },
              ),
      ),
    );
  }

  Future<void> initialize() async {
    var i = await TokenManagerServices().getData();
    beansModel =
        await ProfileUpdateServices().getBeansInfo("monthly", i.userId??"");
    setState(() {
      loading = false;
    });
  }

  double getSliderValue(String work, int total) {
    double i  = 0.0;
   i = (double.parse(work) *100);
    i = i / total;
    return i;
  }

  double getHoursToValue(String work, int total) {
    int idx = work.indexOf(" ");
    if(!work.contains("H")){
      String min = work.substring(idx + 1).trim().replaceAll("Min", "");
      double totalValue = double.parse(min);
      totalValue = totalValue/60;
      double i  = 0.0;
      i = (totalValue *100);
      i = i / total;
      return i;
    }else {
      String hour = work.substring(0, idx).trim().replaceAll("H", "");
      String min = work.substring(idx + 1).trim().replaceAll("Min", "");
      double totalValue = (double.parse(hour) * 60) +double.parse(min);
      totalValue = totalValue/60;
      double i  = 0.0;
      i = (totalValue *100);
      i = i / total;
      return i;
    }

   return 0;
  }
}
