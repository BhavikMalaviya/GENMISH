import 'package:FeedBack/models/call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AudioMethods {
  final CollectionReference callCollection =
      FirebaseFirestore.instance.collection("AUDIO_CALL_COLLECTION");

  Stream<DocumentSnapshot> audiocallStream({String uid}) =>
      callCollection.document(uid).snapshots();

  Future<bool> makeCall({Call call}) async {
    try {
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await callCollection.doc(call.callerId).set(hasDialledMap);
      await callCollection.doc(call.receiverId).set(hasNotDialledMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({Call call, BuildContext context}) async {
    try {
      await callCollection.doc(call.callerId).delete();
      await callCollection.doc(call.receiverId).delete();
      Navigator.of(context).pop();
      FocusScope.of(context).unfocus();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
