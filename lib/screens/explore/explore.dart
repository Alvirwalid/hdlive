import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/country_bloc/country_bloc.dart';
import '../../models/country_model.dart';
import '../shared/loading.dart';
import '../withAuth/profile/screens/edit/country_preference.dart';

class Explore extends StatefulWidget {
  const Explore({required Key key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  CountryBloc _bloc = CountryBloc();
  List<int> preferenceIds = [];
  List<String> preferenceNames = [];
  @override
  void initState() {
    _bloc.add(FetchCountries());

    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.sp),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Row(
                children: [
                  Text(
                    'Country & Regions',
                    style: TextStyle(
                        color: Colors.red.shade900,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CountryPreference(
                                preferenceIds: preferenceIds,
                                preferenceCountries: preferenceNames,
                                onSave: (List<int> ids, List<String> names) {
                                  setState(() {
                                    preferenceIds = ids;
                                    preferenceNames = names;
                                  });

                                  Navigator.of(context).pop();
                                },
                              )));
                    },
                    child: Row(
                      children: [
                        Text(
                          'More',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15.sp,
                          color: Colors.black54,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: BlocBuilder(
                bloc: _bloc,
                builder: (context, state) {
                  if (state is CountryFetching) {
                    return Loading();
                  } else if (state is CountryFetched) {
                    List<CountryModel>? countries = state.countries;
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 150.h,
                      child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          padding: EdgeInsets.all(8.sp),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5,
                                  childAspectRatio: 2 / 2.6,
                                  crossAxisCount: 2),
                          itemBuilder: (context, i) {
                            CountryModel c = countries![i];
                            return Container(
                              child: Column(
                                children: [
                                  c.flag != null
                                      ? Container(
                                          width: 30.w,
                                          child: Image.network(
                                            c.flag??"",
                                            width: 30.w,
                                          ),
                                        )
                                      : Container(
                                          width: 30.w,
                                          child: Image.asset(
                                            "images/no_flag.jpeg",
                                            width: 30.w,
                                          ),
                                        ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    c.name??"",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: 8),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
