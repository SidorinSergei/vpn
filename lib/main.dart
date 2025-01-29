import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late OpenVPN engine;
  VpnStatus? status;
  String? stage;
  bool _granted = false;

  @override
  void initState() {
    super.initState();
    engine = OpenVPN(
      onVpnStatusChanged: (data) {
        print("VPN Status: ${data?.toJson()}");
        setState(() {
          status = data;
        });
      },
      onVpnStageChanged: (data, raw) {
        print("VPN Stage Changed: $data | Raw: $raw");
        setState(() {
          stage = raw;
        });
      },
    );

    engine.initialize(
      groupIdentifier: "group.com.example.vpn",
      providerBundleIdentifier: "com.example.vpn",
      localizedDescription: "VPN Connection",
      lastStage: (stage) {
        setState(() {
          this.stage = stage.name;
        });
      },
      lastStatus: (status) {
        setState(() {
          this.status = status;
        });
      },
    );
  }

  Future<void> initPlatformState() async {
    try {
      print("Loading VPN configuration...");
      String config = await rootBundle.loadString('assets/ovpn_configs/nl-free-91.protonvpn.tcp.ovpn');

      print("Starting VPN connection...");
      await engine.connect(
        config,
        "VPN Server",
        username: "xBb3HB9o0uJpuN4J",
        password: "rbF6tmu4RCXxpUEBCcFHNgoPMmc4c2hX",
        certIsRequired: true,
      );
      print("VPN connection started.");
    } catch (e) {
      print("Error during VPN connection: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('VPN Example App'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("VPN Stage: ${stage ?? 'Unknown'}"),
              Text("VPN Status: ${status?.toJson().toString() ?? 'Unknown'}"),
              TextButton(
                child: const Text("Start"),
                onPressed: () {
                  print("Start button pressed.");
                  initPlatformState();
                },
              ),
              TextButton(
                child: const Text("STOP"),
                onPressed: () {
                  print("VPN Disconnecting...");
                  engine.disconnect();
                },
              ),
              if (Platform.isAndroid)
                TextButton(
                  child: Text(_granted ? "Granted" : "Request Permission"),
                  onPressed: () {
                    engine.requestPermissionAndroid().then((value) {
                      setState(() {
                        _granted = value;
                      });
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
