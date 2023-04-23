import 'package:flutter/material.dart';
import 'package:java_call/admin.dart';
import 'package:wifi_scan/wifi_scan.dart';

class WifiInfoViewScreen extends StatelessWidget {
  const WifiInfoViewScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WiFi Networks Nearby'),
        backgroundColor: Colors.pink[800],
      ),
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: FutureBuilder(
          future: WiFiScan.instance.startScan(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return FutureBuilder(
                future: WiFiScan.instance.canGetScannedResults(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData &&
                      snapshot.data == CanGetScannedResults.yes) {
                    return FutureBuilder(
                      future: WiFiScan.instance.getScannedResults(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(8),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) => Card(
                              color: Colors.grey[800],
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginPage()),
                                  );
                                },
                                leading: const Text(
                                  '>',
                                  style: TextStyle(
                                    color: Colors.pinkAccent,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Monospace',
                                  ),
                                ),
                                title: Text(
                                  snapshot.data![index].ssid,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Monospace',
                                  ),
                                ),
                                subtitle: Text(
                                  snapshot.data![index].bssid,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Monospace',
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const Center(
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.pinkAccent,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  } else if (snapshot.hasData && snapshot.data != CanGetScannedResults.yes) {
                    return Text(
                      snapshot.data!.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Monospace',
                      ),
                    );
                  } else {
                    return const Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.pinkAccent,
                          ),
                        ),
                      ),
                    );
                  }
                },
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.pinkAccent,
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text(
                  'No data available',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Monospace',
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}