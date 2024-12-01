part of 'country_bloc.dart';

@immutable
abstract class CountryState {}

class CountryInitial extends CountryState {}
class CountryFetching extends CountryState {}
class CountryFetched extends CountryState{
  final List<CountryModel>? countries;
  final bool? fetchingAllCountries;
  CountryFetched({this.countries,this.fetchingAllCountries});
}

class CountryError extends CountryState{}