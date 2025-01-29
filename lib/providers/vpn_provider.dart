import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';
import '../models/country.dart';

enum AppVpnStatus {
  connected,
  disconnected,
  connecting,
  unknown,
}

class VPNProvider extends ChangeNotifier {
  late OpenVPN _engine;
  AppVpnStatus _status = AppVpnStatus.disconnected;
  String? _stage;
  Country? _selectedCountry;

  AppVpnStatus get status => _status;
  String? get stage => _stage;
  Country? get selectedCountry => _selectedCountry;

  VPNProvider() {
    _initVPN();
  }

  void _initVPN() {
    _engine = OpenVPN(
      onVpnStageChanged: (data, raw) {
        _stage = raw;
        switch (_stage) {
          case 'noprocess':
          case 'vpn_generate_config':
          case 'tcp_connect':
          case 'wait_connection':
          case 'authenticating':
          case 'get_config':
            _status = AppVpnStatus.connecting;
            break;
          case 'assign_ip':
          case 'connected':
            _status = AppVpnStatus.connected;
            break;
          case 'disconnected':
            _status = AppVpnStatus.disconnected;
            break;
          default:
            _status = AppVpnStatus.unknown;
        }

        notifyListeners();
      },
    );

    _engine.initialize(
      groupIdentifier: "group.com.example.vpn",
      providerBundleIdentifier: "com.example.vpn",
      localizedDescription: "VPN Connection",
    );
  }

  Future<void> connectToVPN(String ovpnFile, String userName, String password) async {
    try {
      String config = await rootBundle.loadString(ovpnFile);
      _status = AppVpnStatus.connecting;
      notifyListeners();
      await _engine.connect(
        config,
        'VPN Server',
        username: userName,
        password: password,
        certIsRequired: true,
      );
      // Статус обновляется через onVpnStageChanged
    } catch (e) {
      print('Error connection to VPN: $e');
      _status = AppVpnStatus.unknown;
      notifyListeners();
    }
  }

  void disconnectVPN() {
    _engine.disconnect();
    _status = AppVpnStatus.disconnected;
    _selectedCountry = null;
    notifyListeners();
  }

  void selectCountry(Country country) {
    _selectedCountry = country;
    notifyListeners();
  }
}
