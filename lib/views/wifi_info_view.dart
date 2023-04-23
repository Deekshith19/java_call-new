import 'package:flutter/material.dart';
import 'package:java_call/admin.dart';
import 'package:wifi_scan/wifi_scan.dart';

class WifiInfoViewScreen extends StatelessWidget {
  const WifiInfoViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wifi-Networks Nearby'),
      ),
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      body: SafeArea(
          child: FutureBuilder(
                      future: WiFiScan.instance.startScan(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return FutureBuilder(
                              future: WiFiScan.instance.canGetScannedResults(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData &&
                                    snapshot.data == CanGetScannedResults.yes) {
                                  return FutureBuilder(
                                      future:
                                          WiFiScan.instance.getScannedResults(),
                                      builder: (context, snapshot) {

                                        if(snapshot.connectionState==ConnectionState.done &&snapshot.hasData){
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            padding: const EdgeInsets.all(8),
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (context, index) =>
                                                ListTile(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                       MaterialPageRoute(builder: (context) => LoginPage()),
                                                               );
                                                  },
                                              tileColor: Colors.white,
                                              style: ListTileStyle.list,
                                              leading: CircleAvatar(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 247, 247, 247),
                                                child: Text(
                                                  (index + 1).toString(),
                                                ),
                                              ),
                                              title: Text(
                                                  snapshot.data![index].ssid),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(snapshot
                                                      .data![index].bssid),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                        else {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      
                                      });
                                } else if(snapshot.hasData && snapshot.data!=CanGetScannedResults.yes) {
                                  return Text(snapshot.data!.toString());
                                }
                                else{
                                  return const Center(
                                      child: CircularProgressIndicator()); 
                                }
                              });
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return const Center(
                            child: Text('No data Available'),
                          );
                        }
                      })),
    );
  }
}
