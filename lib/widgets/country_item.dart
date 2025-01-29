import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/country.dart';
import '../providers/vpn_provider.dart';

class CountryItem extends StatelessWidget {
  final Country country;

  const CountryItem({Key? key, required this.country}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vpnProvider = Provider.of<VPNProvider>(context);
    bool isSelected = vpnProvider.selectedCountry?.name == country.name;

    return GestureDetector(
      onTap: () {
        vpnProvider.selectCountry(country);
        Navigator.pop(context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isSelected
              ? LinearGradient(
            colors: [Colors.tealAccent.shade200, Colors.tealAccent.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : LinearGradient(
            colors: [Colors.indigo.shade300, Colors.indigo.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? Colors.tealAccent.withOpacity(0.4) : Colors.indigo.withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    country.flag,
                    width: 60,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  country.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            if (isSelected)
              Positioned(
                top: 10,
                right: 10,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white.withOpacity(0.9),
                  size: 26,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
