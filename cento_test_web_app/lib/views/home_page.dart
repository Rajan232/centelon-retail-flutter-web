// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../appcolours.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logging/logging.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _player = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse('../assets/music.mp3'))); // Replace with your audio file path
    } catch (e) {
      // Import the logging package
      

      // Initialize the logger
      final logger = Logger('Homepage');

      // Log the error
      logger.severe("Error loading audio source: $e");
    }
    _player.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
        });
      }
    });

    _player.playingStream.listen((playing) {
      setState(() {
        _isPlaying = playing;
      });
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _playPause() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> _nextSong() async {
    await _player.seek(Duration.zero); // Restart the track for simplicity
    await _player.play();
  }

  Future<void> _previousSong() async {
    await _player.seek(Duration.zero); // Restart the track for simplicity
    await _player.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.primaryColor,
      appBar: AppBar(
        toolbarHeight: 75.0,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 10.0),
          child: Text(
            'Background Music Test',
            style: GoogleFonts.robotoMono(
                textStyle: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 30.0,
            )),
          ),
        ),
        backgroundColor: AppColours.primaryColor,
      ),
      body: Center(
        child: Text(
          'Press the buttons to control music',
          style: GoogleFonts.robotoMono(
              textStyle: TextStyle(
                  color: AppColours.textColor,
                  fontSize: 20.0,
                  letterSpacing: 0.15,
                  wordSpacing: 0.25)),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: _playPause,
            backgroundColor: AppColours.buttonColor,
            hoverColor: const Color(0xFFF2F2F2),
            child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _nextSong,
            backgroundColor: AppColours.buttonColor,
            hoverColor: const Color(0xFFF2F2F2),
            child: const Icon(Icons.skip_next),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _previousSong,
            backgroundColor: AppColours.buttonColor,
            hoverColor: const Color(0xFFF2F2F2),
            child: const Icon(Icons.skip_previous),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}