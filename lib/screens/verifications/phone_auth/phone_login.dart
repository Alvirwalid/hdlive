import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hdlive_latest/models/country_model.dart';
import 'package:hdlive_latest/screens/shared/constants.dart';
import 'package:hdlive_latest/screens/verifications/controllers/login_controller.dart';
import 'package:hdlive_latest/screens/verifications/country_select.dart';
import 'package:hdlive_latest/screens/verifications/sub_widgets/circle_logo.dart';

import '../sign_in.dart';
import 'linear_social_button_group_phone.dart';
import 'phone_signup.dart';

class PhoneSignin extends StatefulWidget {
  @override
  _PhoneSigninState createState() => _PhoneSigninState();
}

class _PhoneSigninState extends State<PhoneSignin> {
  TextEditingController _phone = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool showPassword = false;
  onSingInPressed() async {
    if (_formKey.currentState!.validate()) {
      // LoginController(context).doPhoneLogin(phone: _phone.text);
      LoginController(context).newPhoneLogin(phone: country?.iso??""+_phone.text);
    }
  }

  @override
  void dispose() {
    _phone.dispose();

    super.dispose();
  }

  CountryModel? country;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: height - 20,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFFF32408), Color(0xFFA82104)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
              child: Stack(
                children: [
                  Positioned(
                    top: height * 0.08,
                    bottom: height * 0.07,
                    left: 0,
                    right: 10,
                    child: Container(
                      child: Image(
                        fit: BoxFit.fill,
                        image: AssetImage("images/white_box.png"),
                      ),
                    ),
                  ),
                  Positioned(
                    top: height * 0.035,
                    right: width * .07,
                    child: CircleLogo(),
                  ),
                  Positioned(
                    top: height * 0.26,
                    left: 20,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FrontTextInLogin(),
                          SizedBox(
                            height: height * 0.05,
                          ),
                          Container(
                            child: Form(
                              key: _formKey,
                              child: Container(
                                child: Column(
                                  children: [
                                  /*  GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => CountrySelect(
                                              onSelect: (CountryModel c) {
                                                setState(() {

                                                });

                                                Navigator.of(context).pop();
                                              },
                                            )));
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border(bottom: BorderSide(color: Colors.grey))),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                "Set Country",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold, fontSize: 13),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),*/
                                    Container(
                                      width: width * 0.56,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),

                                      child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter.digitsOnly
                                          ],
                                          validator: (val) {
                                            if (val!.isEmpty) {
                                              return "Enter your phone number";
                                            }
                                            return null;
                                          },
                                          controller: _phone,
                                          decoration:
                                              signupInputDecoration.copyWith(
                                            errorStyle: TextStyle(color: Colors.red),
                                            hintText: 'Phone',
                                            prefixIcon: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                child:  GestureDetector(
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
                                                    padding: EdgeInsets.all(10),
                                                    child: Text(country ==null ?"+88": "+${country?.iso??""}",
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                          FontWeight.bold),
                                                    ),
                                                  ),
                                                ),),
                                            prefixIconConstraints:
                                                BoxConstraints(
                                                    minWidth: 0, minHeight: 0),
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: ElevatedButton(
                                        onPressed: onSingInPressed,
                                        style: ButtonStyle(
                                            shape:
                                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                )),
                                            backgroundColor:
                                            MaterialStateProperty.all<Color>(Colors.black)),
                                        child: Text(
                                          "LOGIN",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  /*  Container(
                                      height: 20,
                                      width: width / 2,
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Divider(
                                            thickness: 1,
                                            height: 2,
                                            color: Colors.grey,
                                          )),
                                          Text(
                                            " OR ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Expanded(
                                              child: Divider(
                                            thickness: 1,
                                            height: 2,
                                            color: Colors.grey,
                                          ))
                                        ],
                                      ),
                                    )*/
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // SizedBox(height:height *0.025,),
                          /*SizedBox(
                            height: height * 0.025,
                          ),
                          LinearSocialButtonGroupPhone(),
                          SizedBox(
                            height: height * 0.025,
                          ),
                          PhoneLoginSignupRedirection(),*/
                        ],
                      ),
                    ),
                  ),
                 /* Positioned(
                    top: height * 0.65,
                    left: width * 0.50,
                    child: ElevatedButton(
                      onPressed: onSingInPressed,
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black)),
                      child: Text(
                        "LOGIN",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
