import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../models/country_model.dart';
import '../../services/country_services.dart';
part 'country_event.dart';
part 'country_state.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  CountryBloc() : super(CountryInitial());

  @override
  Stream<CountryState> mapEventToState(
    CountryEvent? event,
  ) async* {
    if(event is FetchCountries){
      yield CountryFetching();
     
      List<CountryModel> returned= await CountryServices.getAllCountries();
      yield CountryFetched(countries: returned,fetchingAllCountries: true);

    }
    if(event is SearchCountries){
      if(event.text.isEmpty){
        yield CountryFetched(countries: event.allCountries!,fetchingAllCountries: false);
      }else{
        List<CountryModel> filtered = event.allCountries!.where((e) => e.name!.toLowerCase().contains(event.text.toLowerCase())).toList();
        yield CountryFetched(countries: filtered,fetchingAllCountries: false);
      }
    }
  }
}
