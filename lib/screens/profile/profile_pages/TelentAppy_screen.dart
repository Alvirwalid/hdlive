import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hdlive_latest/models/Dropdown_model.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/services/dropdown_servicve.dart';
import 'package:hdlive_latest/services/token_manager_services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class TeletApply extends StatefulWidget {
  TeletApply({Key? key}) : super(key: key);

  @override
  State<TeletApply> createState() => _TeletApplyState();
}

class _TeletApplyState extends State<TeletApply> {
  TextEditingController name = TextEditingController();
  TextEditingController fathername = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController postalCode = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController nationalId = TextEditingController();
  TextEditingController hdLiveId = TextEditingController();
  TextEditingController agencyNumber = TextEditingController();
  TextEditingController agencyName = TextEditingController();
  TextEditingController agencyid = TextEditingController();
  File? nationalImageOne;
  File? nationalImageTwo;
  File? selftokenPic;
  String? _extension;

  String? _pickingType;

  @override
  void initState() {
    getdropdown();
    super.initState();
  }

  getdropdown() async {
    data = (await DropdownService().agencyname())!;
    setState(() {});
  }

  DropdownModel? data;

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
          "Telent Application",
          style: TextStyle(
              color: Colors.red.shade900,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                cursorColor: Colors.red,
                controller: name,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  labelText: '*Please your real name',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Phone number (+x xxx-xxx-xxxx)';
                  }
                  return null;
                },
              ),
              TextFormField(
                cursorColor: Colors.red,
                controller: fathername,
                decoration: const InputDecoration(
                  focusColor: Colors.red,
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  labelText: '*Please your Fathers Name',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                validator: ( value) {
                  if (value!.isEmpty) {
                    return 'Phone number (+x xxx-xxx-xxxx)';
                  }
                  return null;
                },
              ),
              TextFormField(
                cursorColor: Colors.red,
                controller: mobile,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  labelText: '*Please your Mobile number/whatsapp number',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                validator: ( value) {
                  if (value!.isEmpty) {
                    return 'Phone number (+x xxx-xxx-xxxx)';
                  }
                  return null;
                },
              ),
              TextFormField(
                cursorColor: Colors.red,
                controller: address,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  labelText: '*Please your address',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                validator: ( value) {
                  if (value!.isEmpty) {
                    return 'Phone number (+x xxx-xxx-xxxx)';
                  }
                  return null;
                },
              ),
              TextFormField(
                cursorColor: Colors.red,
                controller: country,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  labelText: '*Selected Country',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                validator: ( value) {
                  if (value!.isEmpty) {
                    return 'Phone number (+x xxx-xxx-xxxx)';
                  }
                  return null;
                },
              ),
              TextFormField(
                cursorColor: Colors.red,
                controller: postalCode,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  labelText: '*Please your Postal Code',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                validator: ( value) {
                  if (value!.isEmpty) {
                    return 'Phone number (+x xxx-xxx-xxxx)';
                  }
                  return null;
                },
              ),
              TextFormField(
                cursorColor: Colors.red,
                controller: Email,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  labelText: '*Please your Email Address',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                validator: ( value) {
                  if (value!.isEmpty) {
                    return 'Phone number (+x xxx-xxx-xxxx)';
                  }
                  return null;
                },
              ),
              TextFormField(
                cursorColor: Colors.red,
                controller: nationalId,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  labelText: '*Please your National id number',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                validator: ( value) {
                  if (value!.isEmpty) {
                    return 'Phone number (+x xxx-xxx-xxxx)';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.black38,
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: GestureDetector(
                  onTap: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();

                    if (result != null) {
                      setState(() {
                        nationalImageOne = File(result.files.single.path??"");
                      });
                      print("nationalimage${nationalImageOne?.path}");
                    } else {
                      // User canceled the picker
                    }
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "*Please upload National id image One(Front Side)",
                              style: TextStyle(
                                  fontSize: 13.sp, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: nationalImageOne != null
                            ? Image.file(
                                nationalImageOne!,
                                fit: BoxFit.fill,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                              )
                            : Icon(
                                Icons.add,
                                color: Colors.red,
                                size: 50,
                              ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.black38,
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: GestureDetector(
                  onTap: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();

                    if (result != null) {
                      setState(() {
                        nationalImageTwo = File(result.files.single.path??"");
                      });
                    } else {
                      // User canceled the picker
                    }
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "*Please upload National id image Two(Back Side)",
                              style: TextStyle(
                                  fontSize: 13.sp, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: nationalImageTwo != null
                            ? Image.file(
                                nationalImageTwo!,
                                fit: BoxFit.fill,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                              )
                            : Icon(
                                Icons.add,
                                color: Colors.red,
                                size: 50,
                              ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                color: Colors.black38,
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: GestureDetector(
                  onTap: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();

                    if (result != null) {
                      setState(() {
                        selftokenPic = File(result.files.single.path??"");
                      });
                    } else {
                      // User canceled the picker
                    }
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "*Upload self Token Photo",
                              style: TextStyle(
                                  fontSize: 20.sp, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: selftokenPic != null
                            ? Image.file(
                                selftokenPic!,
                                fit: BoxFit.fill,
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                              )
                            : Icon(
                                Icons.add,
                                color: Colors.red,
                                size: 50,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              TextFormField(
                cursorColor: Colors.red,
                controller: hdLiveId,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  labelText: '*Please your HDLive id number',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                validator: ( value) {
                  if (value!.isEmpty) {
                    return 'Invalid Id number';
                  }
                  return null;
                },
              ),
              TextFormField(
                cursorColor: Colors.red,
                controller: agencyNumber,
                decoration: const InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  labelText: '*Please your Agency Number',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                validator: ( value) {
                  if (value!.isEmpty) {
                    return 'Invalid Agency Number';
                  }
                  return null;
                },
              ),
              data == null
                  ? Center(
                      // child: CircularProgressIndicator(),
                      child: Loading(),
                    )
                  : DropdownButton<String>(
                      itemHeight: 50,
                      selectedItemBuilder: (BuildContext context) {
                        return data!.data!.map((item) {
                          return Text(item.agencyName??"");
                        }).toList();
                      },
                      isDense: true,
                      isExpanded: true,
                      onTap: () async {},
                      hint: const Text('Select Agency Name'),
                      value: _pickingType,
                      items: data!.data!.map<DropdownMenuItem<String>>((e) {
                        return DropdownMenuItem(
                            enabled: true,
                            value: e.agencyId,
                            child: Text(e.agencyName??""));
                      }).toList(growable: true),
                      onChanged: (value) {
                        Datum i = data!.data!.where((element) => element.agencyId!.contains(value!)).first;

                        agencyName.text = i.agencyName??"";
                        print('Agency NAme === ${agencyName.text}');
                        _pickingType = value;
                        print('Agency Name  ==== ${_pickingType}');
                        agencyid.text = value??"";
                        setState(() {});
                      }),
              // TextFormField(
              //   onTap: () {},
              //   cursorColor: Colors.red,
              //   controller: agencyName,
              //   decoration: const InputDecoration(
              //     focusedBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(color: Colors.red)),
              //     labelText: '*Please your Agency Name',
              //     labelStyle: TextStyle(color: Colors.black),
              //   ),
              //   validator: (String value) {
              //     if (value.isEmpty) {
              //       return 'Invalid Agency Name';
              //     }
              //     return null;
              //   },
              // ),
              TextFormField(
                cursorColor: Colors.red,
                controller: agencyid,
                decoration: const InputDecoration(
                  enabled: false,
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  labelText: '*Please your Agency id',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                validator: ( value) {
                  if (value!.isEmpty) {
                    return 'Invalid Agency id';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  var i = await TokenManagerServices().getData();
                  print("user====${i.userId}");

                  Map<String, dynamic> formdataMap = {
                    "real_name": name.text,
                    "father_name": fathername.text,
                    "whatsapp_number": mobile.text,
                    "address": address.text,
                    "country": country.text,
                    "postal_code": postalCode.text,
                    "email": Email.text,
                    "national_id_no": nationalId.text,
                    "hdlive_id": hdLiveId.text,
                    'agency_code': agencyNumber.text,
                    "agency_name": agencyName.text,
                    "agency_id": agencyid.text,
                    "user_id": i.userId,
                    "national_image_one": nationalImageOne != null
                        ? await MultipartFile.fromFile(nationalImageOne?.path??"",
                            filename: path.basename(nationalImageOne?.path??""))
                        : null,
                    "national_image_two": nationalImageTwo != null
                        ? await MultipartFile.fromFile(nationalImageTwo?.path??"",
                            filename: path.basename(nationalImageTwo?.path??""))
                        : null,
                    "self_token_photo": selftokenPic != null
                        ? await MultipartFile.fromFile(selftokenPic?.path??"",
                            filename: path.basename(selftokenPic?.path??""))
                        : null,
                  };

                  FormData formData = FormData.fromMap(formdataMap);
                  var request = new http.MultipartRequest(
                      "POST",
                      Uri.parse(
                          'http://hdlive.cc/index.php/Apis/universal/storeTelent'));
                  request.fields['real_name'] = name.text;
                  request.fields['father_name'] = fathername.text;
                  request.fields['whatsapp_number'] = mobile.text;
                  request.fields['address'] = address.text;
                  request.fields['country'] = country.text;
                  request.fields['postal_code'] = postalCode.text;
                  request.fields['email'] = Email.text;
                  request.fields['national_id_no'] = nationalId.text;
                  request.fields['hdlive_id'] = hdLiveId.text;
                  request.fields['agency_code'] = agencyNumber.text;
                  request.fields['agency_name'] = agencyName.text;
                  request.fields['agency_id'] = agencyid.text;
                  request.fields['user_id'] = i.userId!;
                  await http.MultipartFile.fromPath(
                      'national_image_one', nationalImageOne?.path??"");
                  await http.MultipartFile.fromPath(
                      'national_image_two', nationalImageTwo?.path??"");
                  await http.MultipartFile.fromPath(
                      'self_token_photo', selftokenPic?.path??"");

                  request.send().then((response) {
                    if (response.statusCode == 200) {
                      print("resoponce====>${response}");
                      print('UPLOAD Successfully !!');
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('From Uploaded !')));
                      Navigator.pop(context);
                    }
                  });
                  // final response = http.MultipartRequest(
                  //   Uri.parse(
                  //       'http://hdlive.cc/index.php/Apis/universal/storeTelent'),
                  // // );
                  // if (response.statusCode == 200) {
                  //   var data = json.decode(response.body);
                },
                child: Container(
                  child: Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red,
                  ),
                  height: 50.h,
                  width: MediaQuery.of(context).size.width * 0.7,
                ),
              ),
              SizedBox(
                height: 20.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
