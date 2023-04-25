import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String _secondsText = "";
  GameState gameState = GameState.readyToStart;
  Timer? _waitingTimer;
  Timer? _stoppableTimer;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF282E3D),
      body: Stack(
        children: [
          const Align(
            alignment: Alignment(0, -0.9),
            child: Text("Test your\nreaction speed",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 38,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  decorationColor: Colors.black),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ColoredBox(
              color: const Color(0xFF6D6D6D),
              child: SizedBox(
                height: 140,
                width: 300,
                child: Center(
                  child: Text(_secondsText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.9),
            child: GestureDetector(
              onTap:() {
                setState(() {
                  switch(gameState) {
                    case GameState.readyToStart:
                      gameState = GameState.waiting;
                      _secondsText = "";
                      _startWaitingTimer();
                      break;
                    case GameState.waiting:
                      break;
                    case GameState.canBeStopped:
                      gameState = GameState.readyToStart;
                      _stoppableTimer?.cancel();
                      break;
                  }
                });
              },
              child: ColoredBox(
                color: _getButtonColor(),
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Center(
                    child: Text(_getButtonText(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText() {
    switch(gameState) {
      case GameState.readyToStart:
        return "START";
      case GameState.waiting:
        return "WAIT";
      case GameState.canBeStopped:
        return "STOP";
    }
  }

  Color _getButtonColor() {
    switch(gameState) {
      case GameState.readyToStart:
        return Color(0xFF40CA88);
      case GameState.waiting:
        return Color(0xFFE0982D);
      case GameState.canBeStopped:
        return Color(0xFFE02D47);
    }
  }

  void _startWaitingTimer() {
    final int random = Random().nextInt(4000) + 1000;
    _waitingTimer = Timer(Duration(milliseconds: random), () {
      setState(() {
        gameState = GameState.canBeStopped;
      });
      _startStoppableTimer();
    });
  }

  void _startStoppableTimer() {
    _stoppableTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        _secondsText = "${timer.tick * 16} ms";
      });
    });
  }

  @override
  void dispose() {
    _waitingTimer?.cancel();
    _stoppableTimer?.cancel();
    super.dispose();
  }
}

enum GameState {
  readyToStart, waiting, canBeStopped
}