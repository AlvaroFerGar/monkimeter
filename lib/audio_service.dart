import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  final AudioPlayer _audioPlayer = AudioPlayer();

  factory AudioService() {
    return _instance;
  }

  AudioService._internal();

  Future<void> playAudio(String audioPath) async {
    try {
      await _audioPlayer.setSource(AssetSource(audioPath));
      await _audioPlayer.resume();
      print('Audio playing successfully');
    } catch (e) {
      print('Error playing audio: $e');
    }
  }
}