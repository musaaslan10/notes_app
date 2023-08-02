import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/Classes/Notlar.dart';
import 'package:notes_app/main.dart';

class NotDetay extends StatefulWidget {
  Notlar notlar;


  NotDetay(this.notlar);

  @override
  State<NotDetay> createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {

  var tfDersAdi = TextEditingController();
  var tfNot1 = TextEditingController();
  var tfNot2 = TextEditingController();

  var refNotlar = FirebaseDatabase.instance.ref().child("notlar");

  Future<void> sil(String not_id) async{
    refNotlar.child(not_id).remove();

    Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  Future<void> Guncelle(String not_id , String ders_adi , int not1 , int not2) async{
    var bilgi = HashMap<String,dynamic>();
    bilgi["not_id"] = not_id;
    bilgi["ders_adi"] = ders_adi;
    bilgi["not1"] = not1;
    bilgi["not2"] = not2;

    refNotlar.child(not_id).update(bilgi);

    Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  @override
  void initState() {
    super.initState();
    tfDersAdi.text = widget.notlar.ders_adi;
    tfNot1.text = widget.notlar.not1.toString();
    tfNot2.text = widget.notlar.not2.toString();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent.shade700,
        title: Text("NOT DETAY",style: TextStyle(color: Colors.black),),
        actions: [
          TextButton(
            child: Text("GÜNCELLE",style: TextStyle(color: Colors.white),),
            onPressed: (){
              Guncelle(widget.notlar.not_id.toString(), tfDersAdi.text, int.parse(tfNot1.text), int.parse(tfNot2.text));
            },
          ),
          TextButton(
            child: Text("SİL",style: TextStyle(color: Colors.redAccent.shade700),),
            onPressed: (){
              sil(widget.notlar.not_id.toString());
            },
          ),
        ],
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
    );
  }
}
