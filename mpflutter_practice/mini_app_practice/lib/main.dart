import 'package:mpcore/mpcore.dart';
import 'package:flutter/widgets.dart';

void main() {
  MPCore().connectToHostChannel(
    body: () {
      runApp(const MyApp());
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MPApp(
      title: 'Counter Mini App',
      color: Colors.blue,
      routes: {
        '/': (context) => const MyHomePage(),
      },
      navigatorObservers: [MPCore.getNavigationObserver()],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MPScaffold(
      name: 'Counter Mini App',
      appBar: MPAppBar(
        context: context,
        title: Text('MINIAPP NEEEEE', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
      ),
      backgroundColor: Color.fromARGB(255, 236, 236, 236),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Counter Mini App, This is second mini app example for counter',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'You have pushed the button this many times:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  '$_counter',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: GestureDetector(
              onTap: _incrementCounter,
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Increment',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }

}