import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:bot_toast/bot_toast.dart';

/* 점자 */

class Voice1Screen extends StatefulWidget {
  const Voice1Screen({super.key});

  // 상태 관리
  @override
  _VoiceScreen1State createState() => _VoiceScreen1State();
}

String text1 = ' ';

class _VoiceScreen1State extends State<Voice1Screen>{
  FlutterTts ftts = FlutterTts();
  late File _image;
  final picker = ImagePicker();


  @override 
  Positioned build(BuildContext context)  {
    final TextEditingController controller = TextEditingController(text: text1);
    

    Future getImage(ImageSource imageSource) async{
      final pickedFile = await picker.getImage(source: imageSource);

      setState(() {
        _image = File(pickedFile!.path);
        // _image == "null"
        //   ? getImage(ImageSource.camera)
        //   : upload(_image);
      });
    }


    return Positioned(
      child: Container(
        child: Stack(
          children: <Widget>[
            Image.asset(
              'assets/images/voice2.png'),
              Positioned(
                top: 440,
                left: 45,
                child: SizedBox(
                  width: 120,
                  height: 120,
                    child: TextButton(
                      child: const Text(" "),
                      onPressed: () async {
                        // getImage(ImageSource.camera);
                        uploadImageToServer();
                        // text1 = await getTextFromServer();
                        // print('text : '+text1);
                      }
                    ),
                  ),
              ),

              // 슬라이드 추가하기
              Positioned(
                top: 20,
                left: 20,
                child: SizedBox(
                  width: 350,
                  height: 400,
                  // String textf = text1.substring(6);
                  // String textf = text1.substring(6,11); 6-11까지
                  // String textf = text1.substring(11, str.indexOf(''')); 11부터 '까지
                  child: Text(''+text1, //'$text1'
                  style: const TextStyle(
                        fontFamily: 'SF Pro Text', 
                        fontSize: 20, 
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                  ),
                ),
              ),

              Positioned(
                top: 440,
                left: 200,
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: TextButton(
                    child: const Text(" "),
                    onPressed: () async {
                      
                      await ftts.setLanguage("ko-KR"); //en-US ko-KR
                      await ftts.setSpeechRate(0.5); //speed of speech
                      await ftts.setVolume(5.0); //volume of speech
                      await ftts.setPitch(1); //pitc of sound

                      //play text to sp
                      // var result = await ftts.speak("Hello World, this is Flutter Campus.");
                      var result = await ftts.speak(controller.text);
                      if(result == 1){
                          //speaking
                      }else{
                          //not speaking
                      }
                  }, 
                ),
              ),
              ),
            ],
        ),
      ),
    );
  }
}

Future<void> uploadImageToServer() async {
  final picker = ImagePicker();
  final pickedFile = await picker.getImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    File imageFile = File(pickedFile.path);
    // String fileName = imageFile.path.split('/').last;

    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(imageFile.path),
    });

    try {
      Dio dio = new Dio();
      dio.options.headers['Content-Type'] = 'application/json';
      Response response = await dio.post(
          'https://a2c9-14-45-91-84.ngrok-free.app/Braille',
          data: formData
      );
      print(response);
    } catch (e) {
      print(e);
    }
    text1 = await getTextFromServer();
    // String textr = text1.substring(9,text1.indexOf('h'));
    // text1 = textr;
    // String textf = splitText(text1) as String;

    splitText(text1);
    print('text : '+text1);
  }
}

Future<String> getTextFromServer() async {
  try {
    Dio dio = new Dio();
    Response response = await dio.get('https://a2c9-14-45-91-84.ngrok-free.app/Braille/translate');
  //  var jsonbody = json.decode(response.data);
  //  return jsonbody['answer'];
  return response.data.toString();
  } catch (e) {
    print(e);
    return 'error';
  }
}

Future<String> splitText(String texts) async {
// String textr = texts.substring(9,texts.indexOf('h'));
String textr = texts.substring(1,3);
text1 = textr;
return text1;
}