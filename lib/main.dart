import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        // Removed useMaterial3 as it's no longer supported
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> ringtones = [];
  final player = FlutterSoundPlayer();

  @override
  void initState() {
    super.initState();
    _requestPermission();

  }

  Future<void> _requestPermission() async {
    if (await Permission.storage.request().isGranted) {
      // Permission is granted
    } else {
      // Permission is denied
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ringtones"),
      ),
      body: Center(
        child: Column(
          children: [
            if (ringtones.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: ringtones.length,
                  itemBuilder: (_, index) {
                    final ringtone = ringtones[index];
                    return Card(
                      child: ListTile(
                        onTap: () async {
                          print('URI: /system/media/audio/ringtones/$ringtone.ogg');
                          await player.openPlayer();
                          await player.startPlayer(
                            fromURI: 'content://media/internal/audio/media/ringtones/$ringtone.ogg',
                            codec: Codec.pcm16,
                          );
                        },


                        title: Text(ringtone),
                      ),
                    );
                  },
                ),
              ),
            ElevatedButton(
              onPressed: () async {
                const channel = MethodChannel("flutter_channel");
                final List<dynamic>? result =
                await channel.invokeMethod("getRingtones");
                if (result != null) {
                  setState(() {
                    ringtones = result.cast<String>();
                  });
                }
              },
              child: const Text("Get Ringtones"),
            ),
            ElevatedButton(
              onPressed: _requestPermission,
              child: const Text('Request Permission'),
            ),
          ],
        ),
      ),
    );
  }

}
