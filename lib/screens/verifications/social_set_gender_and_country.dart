import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hdlive_latest/models/country_model.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/screens/shared/raised_gradient_button.dart';
import 'package:hdlive_latest/screens/verifications/country_select.dart';
import 'package:hdlive_latest/screens/verifications/sub_widgets/circle_logo.dart';
import 'package:hdlive_latest/screens/verifications/terms_condition.dart';
import 'package:hdlive_latest/services/profile_update_services.dart';
import 'package:hdlive_latest/services/token_manager_services.dart';

class SocialSetGenderAndCountry extends StatefulWidget {
  var data;
  var image;
  SocialSetGenderAndCountry({this.data, this.image});
  @override
  _SocialSetGenderAndCountryState createState() =>
      _SocialSetGenderAndCountryState();
}

class _SocialSetGenderAndCountryState extends State<SocialSetGenderAndCountry> {
  bool loading = false;

  int gender = 2;
  TextEditingController dateofbirth = TextEditingController();
  CountryModel? country;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    dateofbirth.dispose();
    super.dispose();
  }

  Widget _myRadioButton({String? title, int? value, Function? onChanged}) {
    return RadioListTile(
      activeColor: Colors.red,
      value: value,
      groupValue: gender,
      onChanged: onChanged!(),
      title: Text(
        title??"",
        style: TextStyle(color: Colors.grey[500], fontSize: 14),
      ),
    );
  }

  ProfileUpdateServices ser = ProfileUpdateServices();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: loading
            ? Loading()
            : Container(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: height * 0.35,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Color(0xFFCC2206),
                                Color(0xFFA92104)
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // LoginController(context).verifySignup(widget.data);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    "",
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.white),
                                  ),
                                ),
                              ),
                              Center(
                                child: CircleLogoWithRadius(h: 0.065),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              FrontTextInTerms(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(top: 75),
                            child: Column(
                              children: [
                                Text(
                                  widget.data['name'],
                                  style: TextStyle(
                                      fontSize: 18.sp, color: Colors.black),
                                ),
                                SizedBox(
                                  height: height * 0.008,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: _myRadioButton(
                                          title: "MALE",
                                          value: 0,
                                          onChanged: (newValue) {
                                            setState(() => gender = newValue);
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: _myRadioButton(
                                            title: "FEMALE",
                                            value: 1,
                                            onChanged: (newValue) {
                                              setState(() => gender = newValue);
                                            }),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Divider(),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => CountrySelect(
                                                  onSelect: (CountryModel c) {
                                                    setState(() {
                                                      country = c;

                                                      Navigator.of(context)
                                                          .pop();
                                                    });
                                                  },
                                                )));
                                  },
                                  child: Container(
                                    height: 35.h,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: country != null
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(country?.name??"",
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      color: Colors.grey[500])),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              // CachedNetworkImage(
                                              //   imageUrl: countryAssetUrl+countryImage,
                                              //   width: 20,
                                              //   progressIndicatorBuilder: (context, url, downloadProgress) =>
                                              //       Loading(),
                                              // ),
                                            ],
                                          )
                                        : Center(
                                            child: Text(
                                              "COUNTRY",
                                              style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 14.sp),
                                            ),
                                          ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Divider(
                                    thickness: 1,
                                  ),
                                ),
                                Theme(
                                  data: ThemeData(primarySwatch: Colors.red),
                                  child: DateTimePicker(
                                    initialDate: DateTime(1990),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "BIRTHDAY",
                                      hintStyle: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 14.sp),
                                    ),
                                    type: DateTimePickerType.date,
                                    dateMask: 'd MMM, yyyy',
                                    textAlign: TextAlign.center,
                                    controller: dateofbirth,
                                    style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 14.sp),
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime(2050),
                                    icon: Icon(Icons.event),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: RaisedGradientButton(
                                      child: Text(
                                        'NEXT',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: <Color>[
                                          Color(0xFFF33117),
                                          Color(0xFFAA2104)
                                        ],
                                      ),
                                      onPressed: () async {
                                        widget.data['country'] = country;
                                        widget.data['dob'] =
                                            dateofbirth.text.isNotEmpty
                                                ? dateofbirth.text
                                                : null;
                                        print("data   === ${widget.data}");
                                        print("data   === ${country}");
                                        var data = await TokenManagerServices()
                                            .saveData(widget.data);
                                        // LoginController(context).verifySignup(widget.data);
                                        floatingLoading(context);
                                        // var re = await ser.updateProfileInfos(
                                        //     widget.data['name'],
                                        //     widget.data['gender'],
                                        //     dateofbirth.text,
                                        //     widget.data['country_id']
                                        //         .toString(),
                                        //     widget.data['bio'],
                                        //     widget.data['preference_countries'],
                                        //     widget.data['country_code'],
                                        //     widget.data['tags']);
                                        // if (widget.image != null) {
                                        //   await ser
                                        //       .updateProfilePic(widget.image);
                                        // }
                                        // var datas = re['data'];
                                        //
                                        // await TokenManagerServices()
                                        //     .saveData(datas);
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                          "/landing",
                                          (Route<dynamic> route) => false,
                                        );
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: height * .05,
                          child: Text(
                            "HD Live targets not for children, instead, you need to be over the minimum age as specified in User Agreemen",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: width * .0275,
                                color: Colors.grey[600]),
                          ),
                        )
                      ],
                    ),
                    Positioned(
                        top: height * 0.35 - 50,
                        left: width / 2 - width * 0.125,
                        // child: CustomHexagon(),
                        child: widget.data['image'] != null
                            ? CircleAvatar(
                                radius: width * 0.125,
                                backgroundImage:
                                    FileImage(widget.data['image']),
                              )
                            : Initicon(
                                text: widget.data['name'],
                                size: width * 0.25,
                              ))
                  ],
                ),
              ),
      ),
    );
  }
}
