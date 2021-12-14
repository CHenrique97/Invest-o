import 'package:flutter/material.dart';
import './pill.dart';
import './graph.dart';

void main() {
  runApp(InvestmentPortal());
}

class InvestmentPortal extends StatelessWidget {
  final financeData = [
    {
      "index": 0,
      "name": "stock",
      "data": {"percentage": 20, "color": "Blue"}
    },
    {
      "index": 1,
      "name": "savings",
      "data": {"percentage": 45, "color": "Red"}
    },
    {
      "index": 2,
      "name": "funds",
      "data": {"percentage": 35, "color": "Yellow"}
    },
    {
      "index": 3,
      "name": "dividends",
      "data": {"percentage": 5, "color": "Orange"}
    },
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: const Color(0x00a9a9a9),
          body: Center(
            child: DonutAutoLabelChart.withSampleData(),
          )),
    );
  }
}
