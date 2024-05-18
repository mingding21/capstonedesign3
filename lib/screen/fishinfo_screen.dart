import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import '../process/TextTranslator.dart';

class FishInfoScreen extends StatefulWidget {
  final String fishName;

  const FishInfoScreen({Key? key, required this.fishName}) : super(key: key);

  @override
  _FishInfoScreenState createState() => _FishInfoScreenState();
}

class _FishInfoScreenState extends State<FishInfoScreen> {
  late Future<String> imageUrl;
  late Future<String> summary;

  @override
  void initState() {
    super.initState();
    imageUrl = fetchImageUrl(widget.fishName);
    summary = fetchSummary(widget.fishName);
  }

  Future<String> fetchImageUrl(String fishName) async {
    String url;

    if (fishName == "Gilt-Head Bream") {
      //1
      url = 'https://d1iraxgbwuhpbw.cloudfront.net/tools/uploadphoto/uploads/sparus_aurata_sardegna2011_4610.jpg';
    } else if (fishName == "Sea Bass") {
      //2
      url = 'https://upload.wikimedia.org/wikipedia/commons/f/f2/Suzuki201302.jpg';
    } else if (fishName == "Black Sea Sprat") {
      //3
      url = 'https://upload.wikimedia.org/wikipedia/commons/f/f8/3_specimens_of_Clupeonella_cultriventris.jpg';
    } else if (fishName == "Red Sea Bream") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/b/b9/Pagrus_major_Red_seabream_ja01.jpg';
       //4
    } else if (fishName == "Houres Mackerel") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/d/d9/MaAji.jpg';
      //5
    } else if (fishName == "Red Mullet") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/e/ef/%C3%89douard_Manet_-_Rouget_et_Anguille.jpg';
      //6
    } else if (fishName == "Trout") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/2/2e/Salmo_trutta.jpg';
      //7
    } else if (fishName == "Shrimp") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/b/b9/Palaemon_serratus_Croazia.jpg';
      //8
    } else if (fishName == "Striped Red Mullet") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/6/6f/Mullus_surmuletus.jpg';
      //9
    } else {
      url = 'https://via.placeholder.com/150x200';
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return url; // 페이지의 URL 반환
    } else {
      return 'https://via.placeholder.com/150x200'; // 오류 발생 시 기본 이미지 URL 반환
    }
  }

  Future<String> fetchSummary(String fishName) async {
    String url;
    var p ;
    if (fishName == "Gilt-Head Bream") {
      print('페이지 접속');
      url = 'https://en.wikipedia.org/wiki/Japanese_jack_mackerel';
      p = 1; //1
    } else if (fishName == "Sea Bass") {
      url = 'https://en.wikipedia.org/wiki/Japanese_sea_bass';
      p = 1; //2
    } else if (fishName == "Black Sea Sprat") {
      url = 'https://en.wikipedia.org/wiki/Black_Sea_sprat';
      p = 1; //3
    } else if (fishName == "Red Sea Bream") {
      url = 'https://en.wikipedia.org/wiki/Pagrus_major';
      p = 1; //4
    } else if (fishName == "Houres Mackerel") {
      url = 'https://en.wikipedia.org/wiki/Japanese_jack_mackerel';
      p = 1; //5
    } else if (fishName == "Red Mullet") {
      url = 'https://en.wikipedia.org/wiki/Red_mullet';
      p = 1; //6
    } else if (fishName == "Trout") {
      url = 'https://en.wikipedia.org/wiki/Trout';
      p = 2; //7
    } else if (fishName == "Shrimp") {
      url = 'https://en.wikipedia.org/wiki/Shrimp';
      p = 1; //8
    } else if (fishName == "Striped Red Mullet") {
      url = 'https://en.wikipedia.org/wiki/Striped_red_mullet';
      p = 1; //9
    } else {
      url = 'https://en.wikipedia.org/wiki/Main_Page';
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var document = parser.parse(response.body);
      print("url");

      var paragraphs = document.querySelectorAll('#mw-content-text > div.mw-content-ltr.mw-parser-output > p');
      for (var i = 0; i < paragraphs.length; i++) {
        print('Paragraph ${i + 1}: ${paragraphs[i].text}');
      }

      print(p);
      var summaryElement = paragraphs.length > p ? paragraphs[p] : null;
      print('페이지확인');

      String extractedData = summaryElement?.text ?? 'Summary not found';

      print(extractedData);

      var translatedText = await TextTranslator.translateText(extractedData, 'ko'); // 'ko'는 한국어 코드
      return translatedText;
    } else {
      print('실패');
      print('Failed to load page. Status code: ${response.statusCode}');
      return 'Failed to load summary';
    }
  }


  String translated = 'Translation';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('물고기 정보'),
      ),
      body:SingleChildScrollView(
        child: FutureBuilder<List<dynamic>>(
        future: Future.wait([imageUrl, summary]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Image.network(
                      snapshot.data![0],
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      '간단 정보',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      snapshot.data![1],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      ));
  }
}


