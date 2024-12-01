part of 'country_bloc.dart';

@immutable
abstract class CountryEvent {}
class FetchCountries extends CountryEvent{}
class SearchCountries extends CountryEvent{
  final List<CountryModel>? allCountries;
  final String text;
  SearchCountries({required this.text,this.allCountries});
}
