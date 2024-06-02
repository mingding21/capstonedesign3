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
      url = 'https://upload.wikimedia.org/wikipedia/commons/f/f8/3_specimens_of_Clupeonella_cultriventris.jpg';
      //3
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
    } else if (fishName == "Indo-Pacific Tarpon") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/1/1a/Megalops_cyprinoides2.jpg';
      //10 여기부터
    } else if (fishName == "Perch") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7f/YellowPerch.jpg/440px-YellowPerch.jpg';
      //11
    } else if (fishName == "Mullet") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Mugil_cephalus_Minorca.jpg/440px-Mugil_cephalus_Minorca.jpg';
      //12
    } else if (fishName == "Grass Carp") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Ctenopharyngodon_idella_01_Pengo.jpg/440px-Ctenopharyngodon_idella_01_Pengo.jpg';
      //13
    } else if (fishName == "Glass Perchlet") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/b/be/Chanda_nama.jpg';
      //14
    } else if (fishName == "Gold Fish") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/2/25/Common_goldfish.JPG';
      //15
    } else if (fishName == "Bangus") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/c/c4/Chanidae_-_Chanos_chanos.JPG';
      //16
    } else if (fishName == "Black Spotted Barb") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Dawkinsia_filamentosa_-Marcus_Knight.tif/lossy-page1-1000px-Dawkinsia_filamentosa_-Marcus_Knight.tif.jpg';
      //17
    } else if (fishName == "Pangasius") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/99/Pangasiidae_-_Pangasius_sanitwongsei.jpg/440px-Pangasiidae_-_Pangasius_sanitwongsei.jpg';
      //18
    } else if (fishName == "Goby") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/31/Rhinogobius_sp._CB%28Hamamatsu%2CShizuoka%2CJapan%29.jpg/440px-Rhinogobius_sp._CB%28Hamamatsu%2CShizuoka%2CJapan%29.jpg';
      //19
    } else if (fishName == "Mosquito Fish") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/5/5c/Mosquitofish.jpg';
      //20
    } else if (fishName == "Long-Snouted Pipefish") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/7/7d/Syngnathus_acus.jpg';
      //21
    } else if (fishName == "Silver Barb") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/af/Barbon_gonion_120127-22830_tsm.JPG/440px-Barbon_gonion_120127-22830_tsm.JPG';
      //22
    } else if (fishName == "Tenpounder") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/3/34/Ladyfish_-_NO_Autoban_Aquarium.jpg';
      //23
    } else if (fishName == "Mudfish") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/3/3b/Neochanna_apoda.jpg';
      //24
    } else if (fishName == "Indian Carp") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Catla_catla.JPG/440px-Catla_catla.JPG';
      //25
    } else if (fishName == "Big Head Carp") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6c/Tolstolobec_pestr%C3%BD.jpg/1920px-Tolstolobec_pestr%C3%BD.jpg';
      //26
    } else if (fishName == "Freshwater Eel") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/5/57/Anguillarostratakils.jpg';
      //27
    } else if (fishName == "Silver Perch") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/8/8a/Bidyanus_bidyanus_as_depicted_by_Fishing_and_Aquaculture%2C_Department_of_Primary_Industries%2C_New_South_Wales.jpg';
      //28
    } else if (fishName == "Fourfinger Threadfin") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/c/c5/Eleutheronema_tetradactylum%28Shaw%2C_1804%29.jpg';
      //29
    } else if (fishName == "Knifefish") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/4/43/Black_Ghost_Knifefish_400.jpg';
      //30
    } else if (fishName == "Janitor Fish") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/9/99/Pterygoplichthys_sp.jpg';
      //31
    } else if (fishName == "Catfish") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Ameiurus_melas_by_Duane_Raver.png/480px-Ameiurus_melas_by_Duane_Raver.png';
      //32
    } else if (fishName == "Climbing Perch") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/d/da/Anabas_testudineus_Day.png';
      //33
    } else if (fishName == "Snakehead") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/0/0f/Northern_snakehead.jpg';
      //34
    } else if (fishName == "Gourami") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/d/d6/Colisa_lalia.jpg';
      //35
    } else if (fishName == "Jaguar Gapote") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Parachromis_managuensis_2012_G1.jpg/440px-Parachromis_managuensis_2012_G1.jpg';
      //36
    } else if (fishName == "Silver Carp") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/9/9f/Hypophthalmichthys_molitrix_Hungary.jpg';
      //37
    } else if (fishName == "Tilapia") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Oreochromis-niloticus-Nairobi.JPG/1920px-Oreochromis-niloticus-Nairobi.JPG';
      //38
    } else if (fishName == "Scat Fish") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Scatophagus_argus_%28Wroclaw_zoo%29-2.JPG/440px-Scatophagus_argus_%28Wroclaw_zoo%29-2.JPG';
      //39
    } else if (fishName == "Green Spotted Puffer") {
      url = 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Tetraodon_nigroviridis_1.jpg/1920px-Tetraodon_nigroviridis_1.jpg';
      //40
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
    } else if (fishName == "Indo-Pacific Tarpon") {
      url = 'https://en.wikipedia.org/wiki/Indo-Pacific_tarpon';
      p = 1; //10
    } else if (fishName == "Perch") {
      url = 'https://en.wikipedia.org/wiki/Perch';
      p = 1; //11
    } else if (fishName == "Mullet") {
      url = 'https://en.wikipedia.org/wiki/Mullet_(fish)';
      p = 1; //12
    } else if (fishName == "Grass Carp") {
      url = 'https://en.wikipedia.org/wiki/Grass_carp';
      p = 1; //13
    } else if (fishName == "Glass Perchlet") {
      url = 'https://en.wikipedia.org/wiki/Ambassis_marianus';
      p = 1; //14
    } else if (fishName == "Gold Fish") {
      url = 'https://en.wikipedia.org/wiki/Goldfish';
      p = 1; //15
    } else if (fishName == "Bangus") {
      url = 'https://en.wikipedia.org/wiki/Milkfish';
      p = 1; //16
    } else if (fishName == "Black Spotted Barb") {
      url = 'https://en.wikipedia.org/wiki/Dawkinsia_filamentosa';
      p = 1; //17
    } else if (fishName == "Pangasius") {
      url = 'https://en.wikipedia.org/wiki/Pangasius';
      p = 1; //18
    } else if (fishName == "Goby") {
      url = 'https://en.wikipedia.org/wiki/Goby';
      p = 0; //19
    } else if (fishName == "Mosquito Fish") {
      url = 'https://en.wikipedia.org/wiki/Mosquitofish';
      p = 1; //20
    } else if (fishName == "Long-Snouted Pipefish") {
      url = 'https://en.wikipedia.org/wiki/Greater_pipefish';
      p = 1; //21
    } else if (fishName == "Silver Barb") {
      url = 'https://en.wikipedia.org/wiki/Java_barb';
      p = 1; //22
    } else if (fishName == "Tenpounder") {
      url = 'https://en.wikipedia.org/wiki/Elopidae';
      p = 1; //23
    } else if (fishName == "Mudfish") {
      url = 'https://en.wikipedia.org/wiki/Neochanna';
      p = 3; //24
    } else if (fishName == "Indian Carp") {
      url = 'https://en.wikipedia.org/wiki/Catla';
      p = 1; //25 여기부터
    } else if (fishName == "Big Head Carp") {
      url = 'https://en.wikipedia.org/wiki/Bighead_carp';
      p = 1; //26
    } else if (fishName == "Freshwater Eel") {
      url = 'https://en.wikipedia.org/wiki/Anguillidae';
      p = 1; //27
    } else if (fishName == "Silver Perch") {
      url = 'https://en.wikipedia.org/wiki/Bidyanus_bidyanus';
      p = 1; //28
    } else if (fishName == "Fourfinger Threadfin") {
      url = 'https://en.wikipedia.org/wiki/Eleutheronema_tetradactylum';
      p = 1; //29
    } else if (fishName == "Knifefish") {
      url = 'https://en.wikipedia.org/wiki/Black_ghost_knifefish';
      p = 1; //30
    } else if (fishName == "Janitor Fish") {
      url = 'https://en.wikipedia.org/wiki/Pterygoplichthys';
      p = 1; //31
    } else if (fishName == "Catfish") {
      url = 'https://en.wikipedia.org/wiki/Catfish';
      p = 1; //32
    } else if (fishName == "Climbing Perch") {
      url = 'https://en.wikipedia.org/wiki/Climbing_gourami';
      p = 1; //33
    } else if (fishName == "Snakehead") {
      url = 'https://en.wikipedia.org/wiki/Northern_snakehead';
      p = 1; //34
    } else if (fishName == "Gourami") {
      url = 'https://en.wikipedia.org/wiki/Gourami';
      p = 1; //35
    } else if (fishName == "Jaguar Gapote") {
      url = 'https://en.wikipedia.org/wiki/Parachromis_managuensis';
      p = 1; //36
    } else if (fishName == "Silver Carp") {
      url = 'https://en.wikipedia.org/wiki/Silver_carp';
      p = 1; //37
    } else if (fishName == "Tilapia") {
      url = 'https://en.wikipedia.org/wiki/Tilapia';
      p = 0; //38
    } else if (fishName == "Scat Fish") {
      url = 'https://en.wikipedia.org/wiki/Scatophagus_argus';
      p = 1; //39
    } else if (fishName == "Green Spotted Puffer") {
      url = 'https://en.wikipedia.org/wiki/Dichotomyctere_nigroviridis';
      p = 1; //40
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


