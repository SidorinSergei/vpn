import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/country.dart';
import '../widgets/country_item.dart';
import '../providers/vpn_provider.dart';

class CountryListScreen extends StatelessWidget {
   CountryListScreen({Key? key}) : super(key: key);

  final List<Country> countries =  [
    Country(
        name: "Нидерланды",
        flag: 'assets/flags/netherlands_flags_flag_17041.png',
        ovpnFile: 'assets/ovpn_configs/nl-free-91.protonvpn.tcp.ovpn'),
    Country(
        name: 'США',
        flag: 'assets/flags/united_states_flags_flag_17080.png',
        ovpnFile: 'assets/ovpn_configs/us-free-65.protonvpn.udp.ovpn'),
    Country(
        name: 'Япония',
        flag: 'assets/flags/japan_flags_flag_17019.png',
        ovpnFile: 'assets/ovpn_configs/jp-free-29.protonvpn.udp.ovpn')
  ];

  @override
  Widget build(BuildContext context) {
    final vpnProvider = Provider.of<VPNProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выбор страны'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: countries.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 3 / 2,
          ),
          itemBuilder: (context, index) {
            return CountryItem(country: countries[index]);
          },
        ),
      ),
    );
  }
}
