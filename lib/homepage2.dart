import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class gameInformation2 extends StatefulWidget {
  const gameInformation2({super.key});

  @override
  State<gameInformation2> createState() => _gameInformation2State();
}

class _gameInformation2State extends State<gameInformation2> {

  FirebaseFirestore firestore = FirebaseFirestore.instance;


  Map<String,dynamic> matchDetails ={};

  Future<void> getdataFromFirebase() async {
    CollectionReference footballRef = firestore.collection('foodball');
    final DocumentReference docref = footballRef.doc('eFXMYJEaEeyhIQLlWl1c');
    final data = await docref.get();
    matchDetails =  jsonDecode(data.data().toString());

  }





  @override
  void initState() {
    getdataFromFirebase();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Football Live Score'),
      ),
      body: StreamBuilder(
        stream: firestore.collection('foodball').doc('eFXMYJEaEeyhIQLlWl1c').snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot<dynamic?>> data) {

          print(data.data?.data());
          if(data.connectionState == ConnectionState.waiting){
            return const Center(
              child:  CircularProgressIndicator(),
            );
          }else if(data.connectionState == ConnectionState.done){
            if(data.hasError){
              return Center(
                child: Text(data.error.toString()),
              );
            }
          }
          if(data.hasData){
            final matchInformation = data.data!;
            return Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 48,
                  ),
                  Text(
                    matchInformation.get('match_name'),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            matchInformation.get('score_team_a').toString(),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            matchInformation.get('team_a'),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const Text('vs'),
                      Column(
                        children: [
                          Text(
                            matchInformation.get('score_team_b').toString(),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            matchInformation.get('team_b'),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            );
          }else{
            return SizedBox();
          }

        }
      ),


    );
  }
}

