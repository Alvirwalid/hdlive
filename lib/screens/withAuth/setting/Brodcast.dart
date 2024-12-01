import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hdlive_latest/models/Aboutus_model.dart';
import 'package:hdlive_latest/services/diamond_service/AboutService/about_Service.dart';

import '../../shared/loading.dart';

class BrodcastScreen extends StatelessWidget {
  const BrodcastScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black54,
            )),
        title: Text(
          'BrodcastUser Agreement',
          style: TextStyle(color: Colors.black54),
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<AboutusModel>(
          future: AboutSevice().aboutus(id: '4'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Html(data: """${snapshot.data?.data?[0].description}"""),
              );
            } else {
              return Center(
                // child: CircularProgressIndicator(),
                child: Loading(),
              );
            }
          }),
    );
  }
}
