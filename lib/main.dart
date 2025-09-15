import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Calculator(title: 'Calculator - GitHub Copilot'),
    );
  }
}


class Calculator extends StatefulWidget {
  final String title;
  const Calculator({super.key, required this.title});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _expression = '';
  String _accumulator = '';
  String _result = '';
  bool _error = false;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _accumulator = '';
        _result = '';
        _error = false;
      } else if (value == '=') {
        try {
          final exp = Expression.parse(_expression.replaceAll('×', '*').replaceAll('÷', '/'));
          final evaluator = const ExpressionEvaluator();
          final evalResult = evaluator.eval(exp, {});
          _result = evalResult.toString();
          _accumulator = _expression + ' = ' + _result;
          _expression = _result;
          _error = false;
        } catch (e) {
          _result = 'Error';
          _accumulator = _expression + ' = Error';
          _error = true;
        }
      } else {
        if (_error) {
          _expression = '';
          _accumulator = '';
          _result = '';
          _error = false;
        }
        if (_expression == '0' && value != '.') {
          _expression = value;
        } else {
          _expression += value;
        }
        _accumulator = _expression;
      }
    });
  }

  Widget _buildButton(String value, {Color? color, Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.grey[200],
          foregroundColor: textColor ?? Colors.black,
          minimumSize: const Size(64, 64),
          textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        onPressed: () => _onButtonPressed(value),
        child: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              color: Colors.blue[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _accumulator,
                    style: const TextStyle(fontSize: 22, color: Colors.black87),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _error ? _result : (_result.isNotEmpty ? _result : ''),
                    style: TextStyle(
                      fontSize: 32,
                      color: _error ? Colors.red : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton('7'),
                      _buildButton('8'),
                      _buildButton('9'),
                      _buildButton('÷', color: Colors.blue[100], textColor: Colors.blue[900]),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton('4'),
                      _buildButton('5'),
                      _buildButton('6'),
                      _buildButton('×', color: Colors.blue[100], textColor: Colors.blue[900]),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton('1'),
                      _buildButton('2'),
                      _buildButton('3'),
                      _buildButton('-', color: Colors.blue[100], textColor: Colors.blue[900]),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton('0'),
                      _buildButton('.'),
                      _buildButton('C', color: Colors.red[100], textColor: Colors.red[900]),
                      _buildButton('+', color: Colors.blue[100], textColor: Colors.blue[900]),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: SizedBox(
                            height: 64,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[300],
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              onPressed: () => _onButtonPressed('='),
                              child: const Text('='),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
