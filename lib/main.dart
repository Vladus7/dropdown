import 'package:dropdown/countries.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp (
        home: Scaffold(
          appBar: AppBar(
            title: Text('qwerty'),
          ),
          body:CountryPickerDropdown(),
        ));
  }
}



class CountryPickerUtils {
  static Country getCountryByIsoCode(String isoCode) {
    final _countries =
    countriesList.map((item) => Country.fromMap(item)).toList();
    try {
      return _countries
          .where((country) =>
      country.isoCode.toLowerCase() == isoCode.toLowerCase())
          .toList()[0];
    } catch (error) {
      throw Exception("The initialValue provided is not a supported iso code!");
    }
  }

  static String getFlagImageAssetPath(String isoCode) {
    return "assets/${isoCode.toLowerCase()}.png";
  }

  static Widget getDefaultFlagImage(Country country) {
    return Image.asset(
      CountryPickerUtils.getFlagImageAssetPath(country.isoCode),
      height: 20.0,
      width: 30.0,
      fit: BoxFit.fill,
      package: "C:\Users\admin\AndroidStudioProjects\dropdown",
    );
  }
}

class Country {
  Country(this.isoCode, this.phoneCode, this.name);
  final String name;
  final String isoCode;
  final String phoneCode;

  Country.fromMap(Map<String, String> map)
      : name = map['name'],
        isoCode = map['isoCode'],
        phoneCode = map['phoneCode'];
}

typedef Widget ItemBuilder(Country country);

class CountryPickerDropdown extends StatefulWidget {
  CountryPickerDropdown(
      {this.itemBuilder, this.initialValue, this.onValuePicked});
  final ItemBuilder itemBuilder;
  final String initialValue;
  final ValueChanged<Country> onValuePicked;

  @override
  _CountryPickerDropdownState createState() => _CountryPickerDropdownState();
}

class _CountryPickerDropdownState extends State<CountryPickerDropdown> {
  List<Country> _countries;
  Country _selectedCountry;

  @override
  void initState() {
    _countries = countriesList.map((item) => Country.fromMap(item)).toList();
    if (widget.initialValue != null) {
      try {
        _selectedCountry = _countries
            .where((country) =>
        country.isoCode == widget.initialValue.toUpperCase())
            .toList()[0];
      } catch (error) {
        throw Exception(
            "The initialValue provided is not a supported iso code!");
      }
    } else {
      _selectedCountry = _countries[0];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<Country>> items = _countries
        .map((country) => DropdownMenuItem<Country>(
        value: country,
        child: widget.itemBuilder != null
            ? widget.itemBuilder(country)
            : _buildDefaultMenuItem(country)))
        .toList();

    return Row(
      children: <Widget>[
        DropdownButtonHideUnderline(
          child: DropdownButton<Country>(
            isDense: true,
            onChanged: (value) {
              setState(() {
                _selectedCountry = value;
                widget.onValuePicked(value);
              });
            },
            items: items,
            value: _selectedCountry,
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultMenuItem(Country country) {
    return Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(
          width: 8.0,
        ),
        Text("${country.name}"),
      ],
    );
  }
}