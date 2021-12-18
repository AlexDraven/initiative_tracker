import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({Key? key}) : super(key: key);

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;

  void increment() {
    setState(() {
      _counter++;
    });
  }

  void decrement() {
    setState(() {
      _counter--;
    });
  }

  void restart() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    const defaultStyle = TextStyle(fontSize: 24, color: Colors.black);

    return Scaffold(
        // backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: const Center(child: Text('DnD Initiative Tracker')),
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Numero de clicks', style: defaultStyle),
              Text('$_counter', style: defaultStyle),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: CustomFloatingActions(
            increaceFn: increment, decreaceFn: decrement, restartFn: restart));
  }
}

class CustomFloatingActions extends StatelessWidget {
  final Function increaceFn;
  final Function decreaceFn;
  final Function restartFn;

  const CustomFloatingActions({
    Key? key,
    required this.increaceFn,
    required this.decreaceFn,
    required this.restartFn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
          onPressed: () => decreaceFn(),
          child: const Icon(Icons.remove),
        ),
        FloatingActionButton(
          onPressed: () => restartFn(),
          child: const Icon(Icons.refresh),
        ),
        FloatingActionButton(
          onPressed: () => increaceFn(),
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
