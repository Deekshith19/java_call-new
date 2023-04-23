import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lan_scanner/lan_scanner.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml.dart' as xml;
import 'package:permission_handler/permission_handler.dart';


class Connected_host extends StatelessWidget {
  const Connected_host({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Connected_Hosts & Vuln Scan',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<HostModel> _hosts = <HostModel>[];
    static const  channel =MethodChannel("Calling");
 

 List<String> cve_ids = [];


   Future<void> hey() async{
    channel.invokeMethod("its");    
    
  }

   Future<List<String>> createCVEArrayFromXML() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('/storage/emulated/0/Termux/third.xml');
    String xmlString = await file.readAsString(); 
    xml.XmlDocument doc = xml.XmlDocument.parse(xmlString);

    List<xml.XmlNode> nodes = doc.findAllElements('elem').toList();
    for (var node in nodes) {
      String? key = node.getAttribute('key');
      if (key == 'id') {
        cve_ids.add(node.text);
      }
    }

    return cve_ids ; 
  }
Future<void> requestPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
  ].request();

  // Check if permission was granted
  if (statuses[Permission.storage] != PermissionStatus.granted) {
    // Permission not granted, handle accordingly
  }
}
Future<void> requestStoragePermission() async {
  final PermissionStatus status = await Permission.manageExternalStorage.request();
  if (status != PermissionStatus.granted) {
    // Handle permission denied case
  }
}
  void functions() async{
    requestPermissions();
    requestStoragePermission();
  await hey();

  //  print('Starting process');
  // await  Future.delayed(Duration(seconds: 120), () {
  //   print('Delayed process completed');
  // });
   
    // var result=await createCVEArrayFromXML();
    // print("\n Below is CVE id's:");
    // print(result);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connected Hosts'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  final scanner = LanScanner(debugLogging: true);

                  final stream = scanner.icmpScan(
                    '192.168.1',
                    progressCallback: (progress) {
                      if (kDebugMode) {
                        print('progress: $progress');
                      }
                    },
                  );

                  stream.listen((HostModel host) {
                    setState(() {
                      _hosts.add(host);
                    });
                  });
                },
                child: const Text('Scan'),
              ),ElevatedButton(onPressed: functions,
              child: const Text("Vuln Scan"),),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final host = _hosts[index];

                  return Card(
                    child: ListTile(
                      title: Text(host.ip),
                    ),
                  );
                },
                itemCount: _hosts.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}