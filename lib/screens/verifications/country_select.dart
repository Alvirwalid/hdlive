import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hdlive_latest/bloc/country_bloc/country_bloc.dart';
import 'package:hdlive_latest/models/country_model.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';
import 'package:hdlive_latest/screens/shared/urls.dart';

class CountrySelect extends StatefulWidget {
  final Function? onSelect;

  CountrySelect({this.onSelect});

  @override
  _CountrySelectState createState() => _CountrySelectState();
}

class _CountrySelectState extends State<CountrySelect> {
  TextEditingController searchController = TextEditingController();

  CountryBloc _bloc = CountryBloc();
  List<CountryModel> allCountries = [];
  @override
  void initState() {
    _bloc.add(FetchCountries());

    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_sharp,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Select Country/Region",
          style: TextStyle(fontSize: 17.sp, color: Colors.black),
        ),
      ),
      body: Container(
          child: BlocBuilder(
        bloc: _bloc,
        builder: (context, state) {
          if (state is CountryFetching) {
            return Loading();
          } else if (state is CountryFetched) {
            List<CountryModel>? countries = state.countries;
            if (state.fetchingAllCountries!) {
              allCountries = countries!;
            }
            return Column(
              children: [
                Container(
                  height: 40.h,
                  color: Colors.grey,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    child: TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none),
                          prefixIcon: Icon(
                            Icons.search,
                            size: 14,
                            color: Colors.grey,
                          ),
                          fillColor: Colors.white,
                          hintText: "Search",
                          filled: true),
                      onChanged: (val) {
                        _bloc.add(SearchCountries(
                            allCountries: allCountries, text: val));
                      },
                    ),
                  ),
                ),
                Expanded(
                    child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(
                              thickness: 1,
                              height: 0,
                            ),
                        itemBuilder: (context, i) {
                          CountryModel c = countries?[i]??CountryModel();
                          if (c.flag != null) {
                            print(countryAssetUrl + c.flag!);
                          }
                          return ListTile(
                            title: Text(
                              c.name??"",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: c.flag != null
                                  ? Image.network(
                                      c.flag??"",
                                      height: 20.h,
                                      width: 20.w,
                                    )
                                  : Container(
                                      width: 30,
                                      child: Image.asset(
                                        "images/no_flag.jpeg",
                                        width: 30,
                                      ),
                                    ),
                            ),
                            dense: true,
                            onTap: () {
                              widget.onSelect!(c);
                              //     Navigator.of(context).pop();
                            },
                          );
                        },
                        itemCount: countries?.length??0))
              ],
            );
          } else {
            return Container(
              color: Colors.black38,
            );
          }
        },
      )),
    );
  }
}
