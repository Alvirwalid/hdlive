import 'package:flutter/material.dart';
import '../landing/appintro.dart';
import '../landing/splash.dart';
import '../models/signup_data_model.dart';
import '../screens/verifications/phone_auth/email_signin.dart';
import '../screens/verifications/phone_auth/phone_login.dart';
import '../screens/verifications/phone_auth/phone_signup.dart';
import '../screens/verifications/set_gender_and_country.dart';
import '../screens/verifications/sign_in.dart';
import '../screens/verifications/sign_up.dart';
import '../screens/verifications/signup_with_otp.dart';
import '../screens/verifications/terms_condition.dart';
import '../screens/withAuth/Wallet/wallet.dart';
import '../screens/withAuth/botom_navigator.dart';
import '../screens/withAuth/go_live/go_live_landing.dart';
import '../screens/withAuth/profile/screens/edit/new_edit_profile_landing.dart';
import '../screens/withAuth/profile/screens/profile.dart';
import '../screens/withAuth/setting/SettingScreen.dart';
import '../screens/withAuth/setting/user_blocked_screen.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SpashScreen());
      case '/app_intro':
        return MaterialPageRoute(builder: (_) => AppIntroPage());
      case '/login':
        return MaterialPageRoute(builder: (_) => NewSignInDesign());
      case '/sign_up':
        return MaterialPageRoute(builder: (_) => NewSignupDesign());
      case '/signup_otp':
        var arg = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => SingupWithOTP(
                  data: arg is SignupDataModel ? arg : null,
                ));
      case '/terms_condition':
        var arg = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => TermsCondition(
                  data: arg as SignupDataModel,
                ));
      case '/set_gender_country':
        var arg = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => SetGenderAndCountry(
                  data: arg is SignupDataModel ? arg : null,
                ));
      case '/landing':
        return MaterialPageRoute(builder: (_) => BottomNavigation());

      //phone signup
      case '/phone_signup':
        return MaterialPageRoute(builder: (_) => PhoneSignup());
      case '/phone_signin':
        return MaterialPageRoute(builder: (_) => PhoneSignin());

      case '/email_signin':
        return MaterialPageRoute(builder: (_) => EmailSignIn());

      //profile
      case '/profile':
        return MaterialPageRoute(builder: (_) => Profile());
      case '/edit_profile_landing':
        return MaterialPageRoute(builder: (_) => NewEditProfileLanding());

      //wallet
      case '/wallet':
        return MaterialPageRoute(builder: (_) => Wallet());
      case '/live_landing':
        return MaterialPageRoute(builder: (_) => GoLiveLanding());
      case '/Setting':
        return MaterialPageRoute(builder: (_) => SettingSreen());

      case '/BlockList':
        return MaterialPageRoute(builder: (_) => UserBlockedScreen());

    }
  }

}
