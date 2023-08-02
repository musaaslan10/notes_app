import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/Classes/NotDetay.dart';
import 'package:notes_app/Classes/NotKayit.dart';
import 'package:notes_app/Classes/Notlar.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var refNotlar = FirebaseDatabase.instance.ref().child("notlar");

  /*Future<List<Notlar>> tumNotlar() async{
    var notListesi = <Notlar>[];

    var not1 = Notlar("1", "Fizik", 49, 92);
    var not2 = Notlar("2", "Tarih", 94, 40);

    notListesi.add(not1);
    notListesi.add(not2);

    return notListesi;
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent.shade700,
        title: Column(
          children: [
            Text("NOTLAR",style: TextStyle(color: Colors.black,fontSize: 20),),
            StreamBuilder<DatabaseEvent>(
              stream: refNotlar.onValue,
              builder: (context,event){
                if(event.hasData){
                  var notlarListesi = <Notlar>[];
                  var gelenDegerler = event.data!.snapshot.value as dynamic;
                  if(gelenDegerler != null){
                    gelenDegerler.forEach((key,nesne){
                      var gelenNotlar = Notlar.fromJson(key, nesne);
                      notlarListesi.add(gelenNotlar);
                    });
                  }
                  double ortalama = 0.0;
                  if(!notlarListesi.isEmpty){
                    double toplam = 0.0;
                    for(var i in notlarListesi){
                      toplam = toplam + ((i.not1 + i.not2)/2);
                    }
                    ortalama = toplam / notlarListesi.length;
                  }
                  return Text("ORTALAMA : ${ortalama.toStringAsFixed(2)}",style: TextStyle(fontSize: 16,color: Colors.black),);
                }else{
                  return Text("ORTALAMA : (ortalama bilgisi bulunamadı)",style: TextStyle(fontSize: 10,color: Colors.white),);
                }
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("background_image/backgroundimage.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder<DatabaseEvent>(
          stream: refNotlar.onValue,
          builder: (context,event){
            if(event.hasData){
              var notlarListesi = <Notlar>[];
              var gelenDegerler = event.data!.snapshot.value as dynamic;
              if(gelenDegerler != null){
                gelenDegerler.forEach((key,nesne){
                  var gelenNot = Notlar.fromJson(key, nesne);
                  notlarListesi.add(gelenNot);
                });
              }
              return ListView.builder(
                itemCount: notlarListesi.length,
                itemBuilder: (context,index){
                  var notListesi = notlarListesi[index];
                  return GestureDetector(
                    child: SizedBox(
                      height: 70,
                      child: Card(
                        color: Colors.indigoAccent.shade700,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(child: Text("${notListesi.ders_adi}",style: TextStyle(fontWeight: FontWeight.bold , fontSize: 18,color: Colors.white),textAlign: TextAlign.center,)),
                            Expanded(child: Text("${notListesi.not1}",style: TextStyle(fontSize: 16,color: Colors.white),textAlign: TextAlign.center,)),
                            Expanded(child: Text("${notListesi.not2}",style: TextStyle(fontSize: 16,color: Colors.white),textAlign: TextAlign.center,)),
                            Expanded(child: Icon(Icons.arrow_right , color: Colors.yellowAccent,))
                          ],
                        ),
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => NotDetay(notListesi)));
                    },
                  );
                },
              );
            }else{
              return Center(child: Text("Veri bulunamadı"),);
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Not Kayıt İçin Tıkla",
        backgroundColor: Colors.black,
        child: Icon(Icons.add_box_outlined,color: Colors.white,),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => NotKayit()));
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}
