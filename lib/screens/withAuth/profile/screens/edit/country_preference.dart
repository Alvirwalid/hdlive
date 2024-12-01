import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hdlive_latest/bloc/country_bloc/country_bloc.dart';
import 'package:hdlive_latest/models/country_model.dart';
import 'package:hdlive_latest/screens/shared/loading.dart';

class CountryPreference extends StatefulWidget {
  List<int>? preferenceIds;
  List<String>? preferenceCountries;
  final Function? onSave;
  CountryPreference(
      {this.preferenceIds, this.preferenceCountries, this.onSave});
  @override
  _CountryPreferenceState createState() => _CountryPreferenceState();
}

class _CountryPreferenceState extends State<CountryPreference> {
  CountryBloc _bloc = CountryBloc();
  List<int>? ids = [];
  List<String>? names = [];
  @override
  void initState() {
    _bloc.add(FetchCountries());
    ids = widget.preferenceIds;
    names = widget.preferenceCountries;
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
      backgroundColor: Colors.white,
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
          "Preference",
          style: TextStyle(fontSize: 17, color: Colors.black),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              widget.onSave!(ids, names);
              // print(ids);
              // print(names);
            },
            child: Text(
              "Save",
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
      body: Container(
          child: BlocBuilder(
        bloc: _bloc,
        builder: (context, state) {
          if (state is CountryFetching) {
            return Loading();
          } else if (state is CountryFetched) {
            List<CountryModel>? countries = state.countries;
            return Column(
              children: [
                Container(
                    height: 40,
                    child: Center(
                      child: Text(
                        "5 regions can be selected at most",
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                    )),
                Expanded(
                    child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(
                              thickness: 1,
                              height: 0,
                            ),
                        itemBuilder: (context, i) {
                          CountryModel c = countries![i];
                          return ListTile(
                            title: Row(
                              children: [
                                c.flag != null
                                    ? Container(
                                        width: 30,
                                        child: Image.network(
                                          c.flag??"",
                                          width: 30,
                                        ),
                                      )
                                    : Container(
                                        width: 30,
                                        child: Image.asset(
                                          "images/no_flag.jpeg",
                                          width: 30,
                                        ),
                                      ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  c.name??"",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            trailing: Checkbox(
                              activeColor: Colors.red,
                              value: ids?.contains(c.id),
                              onChanged: (val) {
                                if (ids!.contains(c.id)) {
                                  names?.remove(c.name);
                                  setState(() {
                                    ids?.remove(c.id);
                                  });
                                } else {
                                  if (ids!.length < 5) {
                                    names?.add(c.name??"");
                                    setState(() {
                                      ids?.add(c.id??0);
                                    });
                                  }
                                }
                              },
                            ),
                            dense: true,
                            onTap: () {
                              if (ids!.contains(c.id??0)) {
                                names?.remove(c.name);
                                setState(() {
                                  ids?.remove(c.id);
                                });
                              } else {
                                if (ids!.length < 5) {
                                  names?.add(c.name??"");
                                  setState(() {
                                    ids?.add(c.id??0);
                                  });
                                }
                              }
                            },
                          );
                        },
                        itemCount: countries!.length))
              ],
            );
          } else {
            return Container();
          }
        },
      )),
    );
  }
}
