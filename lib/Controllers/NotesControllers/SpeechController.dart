import 'dart:async';

import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:math';


class SpeechController extends GetxController {

  final SpeechToText _speechToText = SpeechToText();
  RxBool speechEnabled = false.obs;
  
  RxList<double> waveformData = <double>[].obs;
  RxBool isListening = false.obs;
  RxString wordsSpoken = "".obs;
  
  Timer? _animationTimer;
  DateTime? _lastWordTime;
  String _lastText = "";

      @override
    void onInit(){
      super.onInit();
      initSpeech();
    }


  void initSpeech()async{
      speechEnabled.value = await _speechToText.initialize();
    }
  
  void startListening() async {

    await _speechToText.listen(
      onResult: (result) {
        wordsSpoken.value = result.recognizedWords;
        
        // Detect when new words are added
        if (result.recognizedWords.length > _lastText.length) {
          _lastWordTime = DateTime.now();
          // Add a spike to waveform when speech is detected
          _addSpeechSpike(result.confidence);
        }
        _lastText = result.recognizedWords;
      },
    );
    
    // Start animation loop
    _startWaveformAnimation();
    isListening.value = true;
  }
  
  void _startWaveformAnimation() {
    waveformData.clear();
    
    // Initialize with baseline
    for (int i = 0; i < 30; i++) {
      waveformData.add(0.15);
    }
    
    _animationTimer = Timer.periodic(Duration(milliseconds: 80), (timer) {
      if (!isListening.value) {
        timer.cancel();
        return;
      }
      
      double baseValue = 0.15;
      
      // Check if speech was recently detected
      if (_lastWordTime != null) {
        final elapsed = DateTime.now().difference(_lastWordTime!);
        if (elapsed.inMilliseconds < 500) {
          // Recent speech - keep amplitude higher
          baseValue = 0.4;
        }
      }
      
      // Add natural variations
      double timeFactor = sin(DateTime.now().millisecondsSinceEpoch / 400);
      double randomFactor = (Random().nextDouble() - 0.5) * 0.2;
      
      double newValue = (baseValue + timeFactor * 0.2 + randomFactor).clamp(0.1, 0.8);
      waveformData.add(newValue);
      
      if (waveformData.length > 40) {
        waveformData.removeAt(0);
      }
    });
  }
  
  void _addSpeechSpike(double confidence) {
    if (waveformData.isEmpty) return;
    
    // Add a spike based on speech confidence
    double spikeHeight = 0.3 + (confidence * 0.4);
    
    // Update the last few bars with spike
    int barsToAffect = 8;
    for (int i = waveformData.length - 1; 
         i >= 0 && i >= waveformData.length - barsToAffect; 
         i--) {
      double distance = (waveformData.length - 1 - i) / barsToAffect.toDouble();
      double spikeValue = spikeHeight * (1 - distance);
      waveformData[i] = spikeValue.clamp(0.0, 1.0);
    }
  }
  
  void stopListening() async {
    await _speechToText.stop();
    _animationTimer?.cancel();
    waveformData.clear();
    isListening.value = false;
  }
}



// class SpeechController extends GetxController{

//     final SpeechToText _speechToText = SpeechToText();
//     SpeechToText get speechToText => _speechToText;

//     RxBool speechEnabled = false.obs;
//     RxString wordsSpoken = "".obs;
//     RxDouble confidenceLevel = 0.0.obs;
//     RxBool isListening = false.obs;

//     final audioRecorder = AudioRecorder();
//      // For amplitude streaming
//     StreamSubscription<Amplitude>? _amplitudeSubscription;
//     RxDouble amplitude = 0.0.obs;
//     RxList<double> waveformData = <double>[].obs;
//     final int maxWaveformPoints = 40; // Number of points to display


//     @override
//     void onInit(){
//       super.onInit();
//       initSpeech();
//     }

//     void initSpeech()async{
//       speechEnabled.value = await speechToText.initialize();
//     }

//     void startListening() async{

//       bool hasPermission = await audioRecorder.hasPermission();
//       if(!hasPermission){
//         return;
//       }
      
//         await audioRecorder.start(
//           const RecordConfig(
//             encoder: AudioEncoder.pcm16bits,
//             bitRate: 128000,
//             numChannels: 1
//           ),
//         );    

//       _amplitudeSubscription = audioRecorder.onAmplitudeChanged(const Duration(milliseconds:70)).listen((amp){
//           double normalizedAmplitude = (amp.current / 100).clamp(0.0, 1.0);
//           // Update waveform data
//           waveformData.add(normalizedAmplitude);

//           if(waveformData.length > maxWaveformPoints){
//              waveformData.removeAt(0);
//            }
//        });

//       bool available = await speechToText.initialize(
//          onStatus: (status){
//             if(status=="listening"){
//                isListening.value = true;
//              }
//             if(status=="notListening"){
//                isListening.value=false;
//              }
//           },
//          onError: (error){
//            stopListening();
//          }
//       );

//       if (!available) {
//         speechEnabled.value = false;
//         stopListening();
//         return;
//       }

//       await speechToText.listen(onResult: onSpeechResult);
//       isListening.value = true;
//       confidenceLevel.value = 0.0;
    
//     }


//     void onSpeechResult(result) async{
//       wordsSpoken.value = "${result.recognizedWords}";
//       confidenceLevel.value = result.confidence;
//     }

//     void stopListening() async{
//        await speechToText.stop();
//        await audioRecorder.stop();
//        _amplitudeSubscription?.cancel();
//        _amplitudeSubscription = null;

//        waveformData.clear();
//        isListening.value = false;
//     }


//      @override
//   void onClose() {
//     _amplitudeSubscription?.cancel();
//     audioRecorder.dispose();
//     _speechToText.cancel();
//     super.onClose();
//   }

// }

