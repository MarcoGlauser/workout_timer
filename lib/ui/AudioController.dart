

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';

class AudioController{
  final int totalTimeInSeconds;
  final PriorityQueue<double> _queue = PriorityQueue((e1, e2) => (e2*1000-e1*1000).toInt());
  final AudioCache audioPlayer = AudioCache(fixedPlayer: AudioPlayer(mode: PlayerMode.LOW_LATENCY));
  final Map<double, String> audioFiles = {};
  AudioController(this.totalTimeInSeconds);

  void addSignal(int secondsBeforeEnd, String soundFile){
    final double progressToPlay = secondsBeforeEnd/totalTimeInSeconds;
    audioPlayer.load(soundFile);
    _queue.add(progressToPlay);
    audioFiles[progressToPlay] = soundFile;
  }

  void checkSoundToPlay(double progress) async{
    if(_queue.isNotEmpty && progress <= _queue.first){
      audioPlayer.play(audioFiles[_queue.first]);
      _queue.removeFirst();
    }
  }

}