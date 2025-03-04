import 'package:calculator/buttons.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String userInput = '';
  String answer = '';

  final List<String> buttons = [
    'C', '+/-', '%', 'DEL',
    '7', '8', '9', '/',
    '4', '5', '6', 'x',
    '1', '2', '3', '-',
    '0', '.', '=', '+',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    userInput,
                    style: const TextStyle(fontSize: 28, color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    answer,
                    style: const TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GridView.builder(
              itemCount: buttons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              padding: const EdgeInsets.all(15),
              itemBuilder: (context, index) {
                return CustomButton(
                  text: buttons[index],
                  onTap: () => buttonTapped(buttons[index]),
                  color: getButtonColor(buttons[index]),
                  textColor: getTextColor(buttons[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void buttonTapped(String value) {
    setState(() {
      if (value == 'C') {
        userInput = '';
        answer = '';
      } else if (value == 'DEL') {
        if (userInput.isNotEmpty) {
          userInput = userInput.substring(0, userInput.length - 1);
        }
      } else if (value == '=') {
        calculateResult();
      } else {
        userInput += value;
      }
    });
  }

  void calculateResult() {
    try {
      String finalInput = userInput.replaceAll('x', '*');
      Parser p = Parser();
      Expression exp = p.parse(finalInput);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        answer = eval.toString();
      });
    } catch (e) {
      setState(() {
        answer = 'Error';
      });
    }
  }

  Color getButtonColor(String text) {
    if (text == 'C' || text == 'DEL') return Colors.redAccent;
    if (text == '=' || text == '/' || text == 'x' || text == '-' || text == '+') {
      return Colors.orangeAccent;
    }
    return Colors.grey[800]!;
  }

  Color getTextColor(String text) {
    if (text == 'C' || text == 'DEL' || text == '=' || isOperator(text)) {
      return Colors.white;
    }
    return Colors.white70;
  }

  bool isOperator(String x) {
    return (x == '/' || x == 'x' || x == '-' || x == '+');
  }
}

