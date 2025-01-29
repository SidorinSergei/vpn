import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vpn_provider.dart';
import '../views/country_list_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Widget _buildStatusSection(BuildContext context, VPNProvider vpnProvider) {
    Color statusColor;
    String statusText;
    Widget statusIcon;

    switch (vpnProvider.status) {
      case AppVpnStatus.connected:
        statusColor = Colors.green;
        statusText = 'Подключено';
        statusIcon = Icon(
          Icons.check_circle,
          color: statusColor,
          size: 80,
        );
        break;
      case AppVpnStatus.disconnected:
        statusColor = Colors.red;
        statusText = 'Отключено';
        statusIcon = Icon(
          Icons.cancel,
          color: statusColor,
          size: 80,
        );
        break;
      case AppVpnStatus.connecting:
        statusColor = Colors.orange;
        statusText = 'Подключение...';
        statusIcon = const SpinKitFadingCircle(
          color: Colors.orange,
          size: 80.0,
        );
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Неизвестно';
        statusIcon = Icon(
          Icons.help_outline,
          color: statusColor,
          size: 80,
        );
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            statusIcon,
            const SizedBox(height: 10),
            Text(
              'Статус VPN',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 5),
            Text(
              statusText,
              style: TextStyle(
                fontSize: 18,
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedServer(BuildContext context, VPNProvider vpnProvider) {
    if (vpnProvider.selectedCountry == null) {
      return const SizedBox.shrink();
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: ListTile(
        leading: Image.asset(
          vpnProvider.selectedCountry!.flag,
          width: 50,
          height: 50,
          fit: BoxFit.contain,
        ),
        title: Text(
          vpnProvider.selectedCountry!.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('Сервер выбран'),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, VPNProvider vpnProvider) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  CountryListScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            backgroundColor: Colors.indigo,
          ),
          child: const Text('Выбрать регион'),
        ),
        const SizedBox(height: 10),
        vpnProvider.status == AppVpnStatus.connected
            ? ElevatedButton(
          onPressed: () {
            vpnProvider.disconnectVPN();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: const Text('Отключиться'),
        )
            : ElevatedButton(
          onPressed: vpnProvider.selectedCountry != null &&
              vpnProvider.status != AppVpnStatus.connecting
              ? () async {
            await vpnProvider.connectToVPN(
              vpnProvider.selectedCountry!.ovpnFile,
              'xBb3HB9o0uJpuN4J',
              'rbF6tmu4RCXxpUEBCcFHNgoPMmc4c2hX',
            );
          }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: const Text('Подключиться'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0E7FF), Color(0xFFCFDEF3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Consumer<VPNProvider>(
            builder: (context, vpnProvider, child) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            _buildStatusSection(context, vpnProvider),
                            const SizedBox(height: 30),
                            _buildSelectedServer(context, vpnProvider),
                            const SizedBox(height: 20),
                            _buildActionButtons(context, vpnProvider),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
