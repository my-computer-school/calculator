import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '계산기',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black, // 배경색을 검정으로 변경
      ),
      debugShowCheckedModeBanner: false,
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _output = "0";

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _output = "0";
      } else if (buttonText == "=") {
        _output = _calculateResult();
      } else {
        if (_output == "0") {
          _output = buttonText;
        } else {
          _output += buttonText;
        }
      }
    });
  }

  String _calculateResult() {
    try {
      final expression = _output.replaceAll('×', '*').replaceAll('÷', '/');
      final parsedExpression = Expression.parse(expression);
      final evaluator = const ExpressionEvaluator();
      final result = evaluator.eval(parsedExpression, {});
      return result.toString();
    } catch (e) {
      return "Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(20.0),
                alignment: Alignment.bottomRight,
                child: Text(
                  _output,
                  style: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    buildButtonRow(["7", "8", "9", "÷"]),
                    buildButtonRow(["4", "5", "6", "×"]),
                    buildButtonRow(["1", "2", "3", "-"]),
                    buildButtonRow(["C", "0", "=", "+"]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((button) => _buildButton(button)).toList(),
    );
  }

  Widget _buildButton(String buttonText) {
    Color buttonColor;
    Color textColor;
    
    if (buttonText == "C" || buttonText == "=") {
      buttonColor = Colors.orange;
      textColor = Colors.white;
    } else if (["÷", "×", "-", "+"].contains(buttonText)) {
      buttonColor = Colors.grey[800]!;
      textColor = Colors.white;
    } else {
      buttonColor = Colors.grey[900]!;
      textColor = Colors.white;
    }

    return Container(
      margin: EdgeInsets.all(5),
      child: ElevatedButton(
        onPressed: () => _buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: TextStyle(fontSize: 28.0, color: textColor),
        ),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(20),
          backgroundColor: buttonColor,
          minimumSize: Size(70, 70),
        ),
      ),
    );
  }
}
