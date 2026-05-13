import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'システムデザイン実践演習',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.cyan)),
      home: const MyHomePage(title: '小林app'),
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
  int _counter = 1;
  String _message = '(message)';
  SharedPreferences? _sp;

  void _setCounter(x) {
    setState(() {
      _counter = x;
    });
    _sp?.setInt('count', _counter);
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((sp) {
      _sp = sp;
      setState(() {
        _counter = _sp?.getInt('count') ?? 1;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Image.network(
                    "https://picsum.photos/seed/$_counter/400/300",
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      FittedBox(
                        child: Text(
                          "count=$_counter",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          child: Text("+1"),
                          onPressed: () => _setCounter(_counter + 1),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          child: Text("-1"),
                          onPressed: () => _setCounter(_counter - 1),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          child: Icon(Icons.refresh),
                          onPressed: () => _setCounter(1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Expanded(child: Text(_message)),
                Expanded(
                  child: TextField(
                    onSubmitted: (s) {
                      final db = FirebaseFirestore.instance;
                      db.collection("app_data").doc("current").set({
                        "message": s,
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
