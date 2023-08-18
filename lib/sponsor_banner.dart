import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SponsorBanner extends StatefulWidget {
  const SponsorBanner({super.key});

  @override
  State<SponsorBanner> createState() => _SponsorBannerState();
}

class _SponsorBannerState extends State<SponsorBanner> {
  int _currentIndex = 0;
  List<Sponsor> _sponsors = [];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadSponsors();
    _startBannerAnimation();
  }

  Future<void> _loadSponsors() async {
    final jsonData = await rootBundle.loadString('assets/sponsors.json');
    final dynamic data = json.decode(jsonData);

    final sponsors = <Sponsor>[];
    data.forEach((sponsorData) {
      sponsors.add(Sponsor.fromJson(sponsorData));
    });

    setState(() {
      _sponsors = sponsors;
    });
  }

  void _startBannerAnimation() {
    const bannerDuration = Duration(seconds: 5);
    _timer = Timer.periodic(bannerDuration, (_) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _sponsors.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Colors.grey[300],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_sponsors[_currentIndex].level} Sponsor',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Image.network(
              _sponsors[_currentIndex].logo,
              width: 100,
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}

class Sponsor {
  Sponsor({required this.name, required this.logo, required this.level});

  factory Sponsor.fromJson(Map<String, dynamic> json) {
    return Sponsor(
      name: json['name'].toString(),
      logo: json['logo'].toString(),
      level: json['level'].toString(),
    );
  }
  final String name;
  final String logo;
  final String level;
}
