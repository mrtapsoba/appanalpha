import 'package:appanalpha/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio/just_audio.dart';

class Controller {
  final CollectionReference contactAllCollection = FirebaseFirestore.instance
      .collection("utilisateurs")
      .doc(Model.num)
      .collection("contacts");
  final AudioPlayer audioPlayer = AudioPlayer();

  Stream<List<Map<String, dynamic>>> listContacts() {
    return contactAllCollection
        .orderBy("nom", descending: false)
        .snapshots()
        .map((event) {
      return event.docs.map((e) {
        Map<String, dynamic> data = e.data() as Map<String, dynamic>;
        return data;
      }).toList();
    });
  }

  Future deleteContact(String positionId) async {
    contactAllCollection.doc(positionId).delete();
  }

  Future addContact(String nom, String numero, String image) async {
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    contactAllCollection.doc(id).set({
      "id": id,
      "nom": nom,
      "numero": numero,
      "image": image,
      "date": DateTime.now()
    });
  }

  Future updateContact(
      String id, String nom, String numero, String image) async {
    contactAllCollection
        .doc(id)
        .set({"nom": nom, "numero": numero, "image": image});
  }

  Future playSong(String songLink) async {
    await audioPlayer.setAsset(songLink);
    audioPlayer.play();
  }
}
