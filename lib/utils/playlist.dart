// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class AudioModel {
  String audioUrl;
  String id;
  String title;
  String artist;
  String artUri;
  AudioModel({
    required this.audioUrl,
    required this.id,
    required this.title,
    required this.artist,
    required this.artUri,
  });
}

final audioList = <AudioModel>[
  AudioModel(
    audioUrl: 'asset:///assets/audio/slipknot_duality.mp3',
    id: '0',
    title: 'Duality',
    artist: 'Slipknot',
    artUri: 'https://cdn.mos.cms.futurecdn.net/9jthvMFCoeecPC6Y7fogFS.jpg',
  ),
  AudioModel(
    audioUrl: 'https://audionautix.com/Music/30SecondClassical.mp3',
    id: '1',
    title: '30 Seconds Classical',
    artist: 'Classical Music',
    artUri:
        'https://imgs.classicfm.com/images/236642?width=1600&crop=4_3&signature=ayHl9Cjp-yPQUpr5mOZJTfF1Qng=',
  ),
  AudioModel(
    audioUrl: 'https://audionautix.com/Music/AMomentsReflection.mp3',
    id: '2',
    title: 'AMomentsReflection',
    artist: 'Classical Music',
    artUri:
        'https://imgs.classicfm.com/images/236642?width=1600&crop=4_3&signature=ayHl9Cjp-yPQUpr5mOZJTfF1Qng=',
  ),
  AudioModel(
    audioUrl: 'https://audionautix.com/Music/ABrighterHeart.mp3',
    id: '3',
    title: 'ABrighterHeart',
    artist: 'Classical Music',
    artUri:
        'https://imgs.classicfm.com/images/236642?width=1600&crop=4_3&signature=ayHl9Cjp-yPQUpr5mOZJTfF1Qng=',
  ),
  AudioModel(
    audioUrl: 'https://audionautix.com/Music/ATallShip.mp3',
    id: '4',
    title: 'ATallShip',
    artist: 'Classical Music',
    artUri:
        'https://imgs.classicfm.com/images/236642?width=1600&crop=4_3&signature=ayHl9Cjp-yPQUpr5mOZJTfF1Qng=',
  ),
  AudioModel(
    audioUrl: 'https://audionautix.com/Music/AlienSunset.mp3',
    id: '5',
    title: 'AlienSunset',
    artist: 'Classical Music',
    artUri:
        'https://imgs.classicfm.com/images/236642?width=1600&crop=4_3&signature=ayHl9Cjp-yPQUpr5mOZJTfF1Qng=',
  ),
  AudioModel(
    audioUrl: 'https://audionautix.com/Music/Antarctica.mp3',
    id: '6',
    title: 'Antarctica',
    artist: 'Classical Music',
    artUri:
        'https://imgs.classicfm.com/images/236642?width=1600&crop=4_3&signature=ayHl9Cjp-yPQUpr5mOZJTfF1Qng=',
  ),
  AudioModel(
    audioUrl: 'https://audionautix.com/Music/AshesOfAnEmpire.mp3',
    id: '7',
    title: 'AshesOfAnEmpire',
    artist: 'Classical Music',
    artUri:
        'https://imgs.classicfm.com/images/236642?width=1600&crop=4_3&signature=ayHl9Cjp-yPQUpr5mOZJTfF1Qng=',
  ),
];
ConcatenatingAudioSource get playlist => ConcatenatingAudioSource(
      children: audioList
          .map((e) => AudioSource.uri(Uri.parse(e.audioUrl),
              tag: MediaItem(
                id: e.id,
                title: e.title,
                artist: e.artist,
                artUri: Uri.parse(e.artUri),
              )))
          .toList(),
    );
