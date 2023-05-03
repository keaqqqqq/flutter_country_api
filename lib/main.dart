import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'country.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}

class CountryApp extends StatefulWidget {
  const CountryApp({Key? key}) : super(key: key);

  @override
  State<CountryApp> createState() => _CountryAppState();
}

class _CountryAppState extends State<CountryApp> {
  TextEditingController textEditingController = TextEditingController();
  String searchCountry = "";
  final player = AudioPlayer();
  String iso2 = "";
  String capital = "";
  String currencyName = "";
  bool male = false;
  var gpd = 0.0, sexRatio = 0.0, surfaceArea = 0.0, tourists = 0.0;
  Country curcountry = Country("Not available", "", "Not available", 0.0, false,
      0.0, 0.0, "Not available", 0.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.all(35.0),
              child: Text("Country Data App",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            ),
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                  hintText: 'Search for a country',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0))),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: _searchCountry, child: const Text('Search Country')),
            Expanded(
              child: CountryGrid(
                curcountry: curcountry,
              ),
            )
          ],
        ),
      ),
    ));
  }

  _searchCountry() async {
    setState(() {
      searchCountry = textEditingController.text;
    });
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    String apiid = "igL9KjbVN6V62sDL5OmISw==d7yI8uHWwOAOj4Sk";
    var url = Uri.parse(
        "https://api.api-ninjas.com/v1/country?name=$searchCountry&units=metric");
    var response = await http.get(url, headers: {'X-Api-Key': apiid});
    if (response.statusCode == 200) {
      var jsonData = response.body;
      print(jsonData);
      var parsedJson = json.decode(jsonData);
      if (parsedJson.isNotEmpty) {
        setState(() {
          iso2 = parsedJson[0]['iso2'];
          capital = parsedJson[0]['capital'];
          gpd = parsedJson[0]['gdp'];
          sexRatio = parsedJson[0]['sex_ratio'];
          if (sexRatio > 100) {
            male = true;
          } else {
            male = false;
          }
          surfaceArea = parsedJson[0]['surface_area'];
          currencyName = parsedJson[0]['currency']['name'];
          tourists = parsedJson[0]['tourists'];
          curcountry = Country(searchCountry, iso2, capital, gpd, male,
              sexRatio, surfaceArea, currencyName, tourists);
          player.play(AssetSource('success.wav'));
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Successful!",
              style: TextStyle(color: Colors.green),
            ),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(20),
            shape: const StadiumBorder(),
            action: SnackBarAction(
              label: 'Dismiss',
              disabledTextColor: Colors.white,
              textColor: Colors.blue,
              onPressed: () {},
            ),
          ),
        );
      } else {
        setState(() {
          player.play(AssetSource('fail.wav'));
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              "Unsuccessful!",
              style: TextStyle(color: Colors.red),
            ),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(20),
            shape: const StadiumBorder(),
            action: SnackBarAction(
              label: 'Dismiss',
              disabledTextColor: Colors.white,
              textColor: Colors.blue,
              onPressed: () {},
            ),
          ),
        );
      }
    } else {
      setState(() {
        player.play(AssetSource('fail.wav'));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Unsuccessful!",
            style: TextStyle(color: Colors.red),
          ),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(20),
          shape: const StadiumBorder(),
          action: SnackBarAction(
            label: 'Dismiss',
            disabledTextColor: Colors.white,
            textColor: Colors.blue,
            onPressed: () {},
          ),
        ),
      );
    }
    Navigator.of(context).pop();
  }
}

class CountryGrid extends StatefulWidget {
  final Country curcountry;

  const CountryGrid({Key? key, required this.curcountry}) : super(key: key);

  @override
  _CountryGridState createState() => _CountryGridState();
}

class _CountryGridState extends State<CountryGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.blue[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Capital",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              widget.curcountry.iso2 == ""
                  ? const Icon(
                      FontAwesomeIcons.earthAsia,
                      size: 60,
                    )
                  : Image.network(
                      "https://flagsapi.com/${widget.curcountry.iso2}/flat/64.png",
                      height: 60,
                    ),
              Text(
                widget.curcountry.capital,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.blue[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "GDP",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const Icon(
                Icons.monetization_on_outlined,
                size: 60,
                color: Colors.teal,
              ),
              Text(
                widget.curcountry.gdp.toString(),
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.blue[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Sex Ratio",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              widget.curcountry.male == true
                  ? const Icon(
                      Icons.male,
                      size: 60,
                      color: Colors.blue,
                    )
                  : const Icon(
                      Icons.female,
                      size: 60,
                      color: Colors.red,
                    ),
              Text(
                widget.curcountry.sexRatio.toString(),
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.blue[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Surface Area",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const Icon(
                Icons.area_chart,
                size: 60,
                color: Colors.brown,
              ),
              Text(
                widget.curcountry.surfaceArea.toString(),
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.blue[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Currency",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const Icon(
                Icons.money,
                size: 60,
                color: Colors.blueAccent,
              ),
              Text(
                widget.curcountry.currencyName,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.blue[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Tourists",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const Icon(
                Icons.people,
                size: 60,
                color: Colors.black87,
              ),
              Text(
                widget.curcountry.tourists.toString(),
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (ctx) => const CountryApp()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 120,
              child: ClipOval(
                child: Image.asset('images/world.jpg'),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const SpinKitSpinningLines(
              color: Colors.black,
              size: 50.0,
            )
          ],
        ),
      ),
    );
  }
}
