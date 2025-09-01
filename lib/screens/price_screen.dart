import 'package:bitcoin_ticker/services/coins_card.dart';
import 'package:bitcoin_ticker/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../services/coin_data.dart';
import 'dart:io' show Platform;

const List<String> cryptoList = ['bitcoin', 'ethereum', 'litecoin'];

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  NetworkHelper networkHelper = NetworkHelper();

  double btcValue = 0.0;
  double ethValue = 0.0;
  double ltcValue = 0.0;

  String currentCurrency = 'USD';

  bool isLoading = true;

  double parseValue(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  void updateUI(exchangeData, String newCurrency) {
    setState(() {
      isLoading = true;
    });
    setState(() {
      if (exchangeData != null) {
        currentCurrency = newCurrency.toUpperCase();
        btcValue = parseValue(exchangeData['bitcoin'][newCurrency]);
        ethValue = parseValue(exchangeData['ethereum'][newCurrency]);
        ltcValue = parseValue(exchangeData['litecoin'][newCurrency]);
      }
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    main();
  }

  Future main() async {
    updateUI(
      await networkHelper.getData(cryptoList, currentCurrency.toLowerCase()),
      currentCurrency.toLowerCase(),
    );
  }

  @override
  Widget build(BuildContext context) {
    DropdownButton currencyDropdownButton() {
      List<DropdownMenuItem<String>> dropDownList = [];
      for (String currency in currenciesList) {
        dropDownList.add(
          DropdownMenuItem<String>(value: currency, child: Text(currency)),
        );
      }

      return DropdownButton<String>(
        value: currentCurrency,
        items: dropDownList,
        onChanged: (newValue) async {
          if (newValue != null) {
            var data = await networkHelper.getData(
              cryptoList,
              newValue.toLowerCase(),
            );
            updateUI(data, newValue.toLowerCase());
          }
        },
      );
    }

    CupertinoPicker currencyCupertinoPicker() {
      List<Widget> pickerList = [];

      for (String currency in currenciesList) {
        pickerList.add(Text(currency));
      }

      var selectedIndex = 19; // Selecting USD currency by default

      return CupertinoPicker(
        itemExtent: 36.0,
        onSelectedItemChanged: (int newIndex) {
          setState(() {
            selectedIndex = newIndex;
          });
        },
        scrollController: FixedExtentScrollController(
          initialItem: selectedIndex,
        ),
        children: pickerList,
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('🤑 Coin Ticker'), centerTitle: true),
      body: isLoading
          ? Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator()],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                CoinsCard(
                  COIN: 'BTC',
                  coinValue: btcValue.toStringAsFixed(0),
                  CURRENCY: currentCurrency,
                ),
                CoinsCard(
                  COIN: 'ETH',
                  coinValue: ethValue.toStringAsFixed(0),
                  CURRENCY: currentCurrency,
                ),
                CoinsCard(
                  COIN: 'LTC',
                  coinValue: ltcValue.toStringAsFixed(0),
                  CURRENCY: currentCurrency,
                ),
                Expanded(child: SizedBox(child: null)),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 150.0,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: 30.0),
                    color: Colors.lightBlue,
                    child: Platform.isIOS
                        ? currencyCupertinoPicker()
                        : currencyDropdownButton(),
                  ),
                ),
              ],
            ),
    );
  }
}
