import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/screens/shared/raised_gradient_button.dart';
import 'package:hdlive_latest/screens/verifications/social_set_gender_and_country.dart';
import 'package:hdlive_latest/screens/verifications/sub_widgets/circle_logo.dart';
import 'package:hdlive_latest/screens/verifications/terms_condition.dart';

class SocialTermsCondition extends StatefulWidget {
  var data;
  SocialTermsCondition({this.data});

  @override
  _SocialTermsConditionState createState() => _SocialTermsConditionState();
}

class _SocialTermsConditionState extends State<SocialTermsCondition> {
  bool agreed = false;

  bool loading = false;

  File? _image;

  @override
  void initState() {
    super.initState();
  }

  changeProfilePic() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path??"");
      setState(() {
        _image = file;
      });
    } else {
      // User canceled the picker
    }
  }

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
                                        fontSize: 10.sp, color: Colors.white),
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
                                    fontSize: 18, color: Colors.black),
                              ),
                              SizedBox(
                                height: height * 0.008,
                              ),
                              Center(
                                  child: Text(
                                "In order to use LOVELLO, you need to read and agree to the following terms",
                                style: TextStyle(
                                    fontSize: width * .0275,
                                    color: Colors.grey[600]),
                              )),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              TermsWindows(),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      activeColor: Colors.red,
                                      value: agreed,
                                      onChanged: (v) {
                                        print(v);
                                        setState(() {
                                          agreed = v!;
                                        });
                                      },
                                    ),
                                    Text(
                                      "I have read and agree to the above agreement",
                                      style: TextStyle(
                                          fontSize: width * .0275,
                                          color: Colors.grey[600]),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height * 0.02,
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
                                    onPressed: () {
                                      if (agreed) {
                                        widget.data['image'] = _image;
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return SocialSetGenderAndCountry(
                                            image: _image,
                                            data: widget.data,
                                          );
                                        }));
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please agree to our terms/conditions",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0.sp);
                                      }
                                    }),
                              ),
                            ],
                          ),
                        )),
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
                      child: GestureDetector(
                          onTap: changeProfilePic,
                          child: _image != null
                              ? CircleAvatar(
                                  radius: width * 0.125,
                                  backgroundImage: FileImage(_image!),
                                )
                              : Initicon(
                                  text: widget.data['name'],
                                  size: width * 0.25,
                                )),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
