import 'dart:convert';

import 'package:mini_app_form/widgets/custom_button.dart';
import 'package:mpcore/channel/channel_io.dart';
import 'package:mpcore/mpcore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

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
  final TextEditingController nameController = TextEditingController();
  final platform = MethodChannel('com.example.miniapp/channel');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['name'] != null) {
      nameController.text = args['name'];
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MPScaffold(
      name: 'Counter Mini App',
      backgroundColor: Color.fromARGB(255, 236, 236, 236),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Hello World'),
                SizedBox(height: 16),
                Text("Vui long nhap thong tin")
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.red,
            width: 300,
            height: 100,
            child: MPEditableText(
              controller: nameController,
              focusNode: FocusNode(),
              style: TextStyle(fontSize: 16, color: Colors.white),
              placeholder: "Nhap ten",
              placeholderStyle:
                  TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.5)),
              onSubmitted: (value) {
                print(value);
              },
            ),
          ),
          CustomButton(
            text: "Submit",
            onPressed: () {
              sendDataToHost(nameController.text);
            },
            color: Colors.blue,
            textColor: Colors.white,
            fontSize: 16,
          )
        ],
      ),
    );
  }

  void sendDataToHost(String name) {
    platform.invokeMethod('listen', {'name': name});
  }
}
