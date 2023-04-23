import 'package:get/get.dart';
import 'package:music_app/core/controllers/audio_controller.dart';

abstract class DepedencyInjection {
  static init() {
    Get.put<AudioController>(AudioController());
  }
}

final audioCtrl = Get.find<AudioController>();
