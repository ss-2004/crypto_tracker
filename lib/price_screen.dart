import 'package:crypto_tracker/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  PriceScreen(
      {this.exchangeRateBTC, this.exchangeRateETH, this.exchangeRateLTC});

  final exchangeRateBTC;
  final exchangeRateETH;
  final exchangeRateLTC;

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = "AUD";

  String btcRate = "?";
  String ethRate = "?";
  String ltcRate = "?";

  void getData() async {
    double btc;
    double eth;
    double ltc;
    try {
      btc = await CoinData().getCoinData("BTC", selectedCurrency);
      eth = await CoinData().getCoinData("ETH", selectedCurrency);
      ltc = await CoinData().getCoinData("LTC", selectedCurrency);
      setState(() {
        btcRate = btc.toStringAsFixed(0);
        ethRate = eth.toStringAsFixed(0);
        ltcRate = ltc.toStringAsFixed(0);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget androidList() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String curr in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(curr),
        value: curr,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getData();
        });
      },
    );
  }

  Widget iOSList() {
    List<Widget> pickerItems = [];
    for (String curr in currenciesList) {
      pickerItems.add(Text(curr));
    }

    return CupertinoPicker(
      backgroundColor: selectorColor,
      magnification: 1.25,
      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
          // background: Colors.grey[900],
          ),
      looping: true,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
        });
        getData();
      },
      children: pickerItems,
    );
  }

  Widget currencySelector() {
    if (Platform.isIOS || Platform.isMacOS) {
      return iOSList();
    } else {
      return androidList();
    }
  }

  Widget infoCard(String cryptoName, String currName, String exRate) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: infoCardColor,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 60.0,
                height: 60.0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image(
                    image: AssetImage("images/$cryptoName.png"),
                  ),
                ),
                decoration: BoxDecoration(
                  color: selectorColor,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              Text(
                '$exRate $currName',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 35.0,
                  color: Colors.grey[900],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: titleBarColor,
      appBar:
          AppBar(title: Text('Crypto Tracker'), backgroundColor: appBarColor),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          infoCard("BTC", selectedCurrency, btcRate),
          infoCard("ETH", selectedCurrency, ethRate),
          infoCard("LTC", selectedCurrency, ltcRate),
          Expanded(
            child: Container(),
            flex: 1,
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            child: currencySelector(),
          ),
        ],
      ),
    );
  }
}
