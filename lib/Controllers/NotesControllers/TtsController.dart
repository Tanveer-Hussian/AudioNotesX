import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class TtsController extends GetxController{

   FlutterTts flutterTts = FlutterTts();
   Map? _currentVoice;

   RxInt currentWordStart = 0.obs;
   RxInt currentWordEnd = 0.obs;
   
   @override  
   void onInit(){
      super.onInit();
      initTTs();
    }

   void initTTs() async{
      await flutterTts.awaitSpeakCompletion(true);

      flutterTts.setProgressHandler((text, start, end, word){
          currentWordStart.value = start;
          currentWordEnd.value = end;
       });

      flutterTts.setCompletionHandler((){
         resetHighlight();
       }); 

      flutterTts.getVoices.then((value){
         try{
            List<Map> _voices = List<Map>.from(value);
             // Selecting english voices 
            _voices = _voices.where((voice)=> voice['name'].contains('en')).toList();
            _currentVoice = _voices.first; 
             setVoice(_currentVoice!);          
         }catch (e){
           print(e.toString());
         } 
      });
   } 

   void setVoice(Map voice){
     flutterTts.setVoice({"name": voice["name"], "locale":voice['locale']});
   }

   void resetHighlight() {
     currentWordStart.value = 0;
     currentWordEnd.value = 0;
   }


}
