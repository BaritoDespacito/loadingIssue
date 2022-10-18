import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ required this.uid });

  final CollectionReference brewCollection = FirebaseFirestore.instance.collection('brews');

  Future updateUserData(String sugars, String name, int strength) async {

    return await brewCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });

  }

  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Brew(
        name: doc.get('name') ?? '',
        strength: doc.get('strength') ?? 0,
        sugars: doc.get('sugars') ?? '0',
      );
    }).toList();
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    // final data = snapshot.data() as Map<String, dynamic>;
    // print(data);
    return UserData(
      uid: snapshot.get('name'),
      sugars: snapshot.get('sugars'),
      strength: snapshot.get('strength'),
      name: snapshot.get('name'),
    );
  }

  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  Stream<UserData> get userData {
    return brewCollection.doc(uid).snapshots()
        .map(_userDataFromSnapshot);
  }

}