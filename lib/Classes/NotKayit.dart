import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/main.dart';

class NotKayit extends StatefulWidget {
  const NotKayit({super.key});

  @override
  State<NotKayit> createState() => _NotKayitState();
}

class _NotKayitState extends State<NotKayit> {

  var tfDersAdi = TextEditingController();
  var tfNot1 = TextEditingController();
  var tfNot2 = TextEditingController();

  var refNotlar = FirebaseDatabase.instance.ref().child("notlar");

  Future<void> kayit(String ders_adi , int not1 , int not2)async{
    var bilgi = HashMap<String,dynamic>();
    bilgi["ders_id"] = "";
    bilgi["ders_adi"] = ders_adi;
    bilgi["not1"] = not1;
    bilgi["not2"] = not2;

    refNotlar.push().set(bilgi); // ekleme komutu

    Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.purpleAccent.shade700,
        title: Text("NOT KAYIT",style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("background_image/backgroundimage.png"),
              fit: BoxFit.cover
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  controller: tfDersAdi,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    label: Text("DERS ADI",style: TextStyle(color: Colors.white),),
                  ),
                ),
                TextFormField(
                  controller: tfNot1,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    label: Text("NOT - 1",style: TextStyle(color: Colors.white),),
                  ),
                ),
                TextFormField(
                  controller: tfNot2,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    label: Text("NOT - 2",style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Kaydet",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        icon: Icon(Icons.save,color: Colors.white,),
        onPressed: (){
          kayit(tfDersAdi.text, int.parse(tfNot1.text), int.parse(tfNot2.text));
        },
      ),
    );
  }
}
