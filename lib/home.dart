import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pycon_india_app/custom_theme.dart';
import 'package:pycon_india_app/sponsor_banner.dart';

class PyConIndiaApp extends StatefulWidget {
  const PyConIndiaApp({super.key});

  @override
  State<PyConIndiaApp> createState() => _PyConIndiaAppState();
}

class _PyConIndiaAppState extends State<PyConIndiaApp> {
  List<ConferenceSession> sessions = [];
  List<bool> hasSearchResults = [false, false, false, false];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSessions();
  }

  Future<void> loadSessions() async {
    final jsonData = await rootBundle.loadString('assets/schedule.json');
    final dynamic data = await json.decode(jsonData);

    final loadedSessions = <ConferenceSession>[];
    data.forEach((sessionData) {
      loadedSessions.add(ConferenceSession.fromJson(sessionData));
    });

    setState(() {
      sessions = loadedSessions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PyCon India',
      theme: customTheme,
      home: DefaultTabController(
        length: 4, // Number of days
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Image.network(
              'https://in.pycon.org/2023/_next/static/media/logo.6f81431e.png',
              width: 100,
              height: 40,
            ),
            bottom: TabBar(
              indicatorColor: secondaryColor,
              tabs: [
                _buildTab('Day 1', hasSearchResults[0]),
                _buildTab('Day 2', hasSearchResults[1]),
                _buildTab('Day 3', hasSearchResults[2]),
                _buildTab('Day 4', hasSearchResults[3]),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  // ignore: inference_failure_on_function_invocation
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Search Schedule'),
                        content: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            labelText: 'Enter search query',
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Search'),
                            onPressed: () {
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
          body: TabBarView(
            children: [
              _buildScheduleTab('Day 1', 0),
              _buildScheduleTab('Day 2', 1),
              _buildScheduleTab('Day 3', 2),
              _buildScheduleTab('Day 4', 3),
            ],
          ),
          bottomNavigationBar: const SponsorBanner(),
        ),
      ),
    );
  }

  Tab _buildTab(String text, bool hasSearchResults) {
    return Tab(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(text),
          ),
          if (hasSearchResults)
            Positioned(
              top: 2,
              right: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScheduleTab(String day, int tabIndex) {
    var daySessions = sessions.where((session) => session.day == day).toList();

    if (daySessions.isEmpty) {
      return Center(
        child: Text('No sessions available for $day'),
      );
    }

    // Filter sessions based on search query
    final searchQuery = _searchController.text.toLowerCase();
    if (searchQuery.isNotEmpty) {
      daySessions = daySessions
          .where(
            (session) => session.session.toLowerCase().contains(searchQuery),
          )
          .toList();
      hasSearchResults[tabIndex] = daySessions.isNotEmpty;
    } else {
      hasSearchResults[tabIndex] = false;
    }

    return ListView.builder(
      itemCount: daySessions.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(daySessions[index].session),
          subtitle: Text(daySessions[index].time),
          trailing: FutureBuilder<ConferenceSpeaker>(
            future: _getSpeaker(daySessions[index].speakerId),
            builder: (
              BuildContext context,
              AsyncSnapshot<ConferenceSpeaker> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Icon(Icons.error);
              } else {
                return Text(snapshot.data!.name);
              }
            },
          ),
        );
      },
    );
  }

  Future<ConferenceSpeaker> _getSpeaker(int? speakerId) async {
    final jsonData = await rootBundle.loadString('assets/speakers.json');
    final dynamic data = json.decode(jsonData);

    ConferenceSpeaker? speaker;
    data.forEach((speakerData) {
      if (speakerData['id'] == speakerId) {
        speaker = ConferenceSpeaker.fromJson(speakerData);
      }
    });

    return speaker!;
  }
}

class ConferenceSession {
  ConferenceSession({
    required this.id,
    required this.day,
    required this.time,
    required this.session,
    this.speakerId,
  });

  factory ConferenceSession.fromJson(Map<String, dynamic> json) {
    return ConferenceSession(
      id: json['id'] as int,
      day: json['day'].toString(),
      time: json['time'].toString(),
      session: json['session'].toString(),
      speakerId: json['speakerId'] as int,
    );
  }
  final int id;
  final String day;
  final String time;
  final String session;
  final int? speakerId;
}

class ConferenceSpeaker {
  ConferenceSpeaker({
    required this.id,
    required this.name,
    required this.bio,
    required this.photo,
  });

  factory ConferenceSpeaker.fromJson(Map<String, dynamic> json) {
    return ConferenceSpeaker(
      id: json['id'] as int,
      name: json['name'].toString(),
      bio: json['bio'].toString(),
      photo: json['photo'].toString(),
    );
  }
  final int id;
  final String name;
  final String bio;
  final String photo;
}
