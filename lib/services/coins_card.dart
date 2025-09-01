import 'package:flutter/material.dart';

class CoinsCard extends StatelessWidget {
  final String CURRENCY;
  String coinValue;
  final String COIN;

  CoinsCard({
    required this.COIN,
    required this.coinValue,
    required this.CURRENCY,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $COIN = $coinValue $CURRENCY',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
