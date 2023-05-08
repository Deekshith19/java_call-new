import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'dart:developer' as developer;

class Api extends StatefulWidget {
  @override
  _ApiState createState() => _ApiState();
}

class _ApiState extends State<Api> {
  String _result = '';
  List<Widget> cvsText = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('NVD API Example'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _result = 'Loading...';
                    });

                    final vulnerabilities = await createCVEArrayFromXML();
                    print(vulnerabilities);
                    setState(() {
                      _result = 'Done!';
                    });

                    // var url = Uri.https('vuldb.com','/api');
                    var url = Uri.parse('https://vuldb.com/?api');

                    print(url);
                    List<String> cvs = await createCVEArrayFromXML();
                    cvs.sort(
                      (a, b) => b.compareTo(a),
                    );
                    cvsText.clear(); 
                    for (var i = 0; i < 1; i++) {
                      var response = http.post(url, body: {
                        'apikey': 'f8a5513e3ffb7e0de682c423c4a18925',
                        'advancedsearch': 'cve:{$cvs[i]}',
                        'details': '1'
                      }).then((response) {
                        var decodedResponse =
                            jsonDecode(utf8.decode(response.bodyBytes)) as Map;
                        // print(i.toString() +
                        //     "  - " +
                        //     decodedResponse["response"]["version"]);

                            var counterMeasures = decodedResponse[0]['entry']['details']['countermeasure']  ; 
                            print(counterMeasures) ; 
                        setState(
                          () => cvsText.add(
                            Container(
                              color: Colors.orange,
                              child: Text(
                                "version - " +
                                    decodedResponse["response"]["version"],
                              ),
                            ),
                          ),
                        );
                      });
                    }
                    print(cvs);
                    // developer.log(response.body.toString());
                  },
                  child: const Text('Fetch Vulnerabilities'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_result),
              ),
              Column(
                children: cvsText,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<List<String>> createCVEArrayFromXML() async {
    File file = File('/storage/emulated/0/Termux/third.xml');
    String xmlString = await file.readAsString();
    List<String> cve_ids = [];

    xml.XmlDocument doc = xml.XmlDocument.parse(xmlString);

    List<xml.XmlNode> nodes = doc.findAllElements('elem').toList();
    for (var node in nodes) {
      String? key = node.getAttribute('key');
      if (key == 'id') {
        String idsValue = node.text.trim();
        if (idsValue.startsWith('CVE-')) {
          cve_ids.add(idsValue);
        }
      }
    }

    return cve_ids;
  }
}
