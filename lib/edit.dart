import 'dart:io';

//import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:appanalpha/model.dart';
import 'package:flutter/material.dart';
import 'package:appanalpha/controller.dart';
import 'package:images_picker/images_picker.dart';

class EditPage extends StatefulWidget {
  EditPage({Key? key, this.contact}) : super(key: key);
  Map<String, dynamic>? contact;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  Controller controller = Controller();
  TextEditingController nom = TextEditingController();
  TextEditingController numero = TextEditingController();

  List<Media>? resList;
  List<Media>? resListVision;
  String imageLink = '';

  Future getImage() async {
    List<Media>? res = await ImagesPicker.pick(
        count: 1, pickType: PickType.image, language: Language.French);
    setState(() {
      resList = res;
    });
  }

/*
  Future getImageVision() async {
    List<Media>? res = await ImagesPicker.pick(
        count: 1, pickType: PickType.image, language: Language.French);
    setState(() {
      resList = res;
    });
  }

  final TextRecognizer _cloudRecognizer =
      FirebaseVision.instance.cloudTextRecognizer();

  scanImage(context) async {
    String textFromPic = "";
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(File(resListVision![0].path));
    dynamic results;
    results = await _cloudRecognizer.processImage(visionImage);
    String text = results.text;
    print(text);

    for (TextBlock block in results.blocks) {
      if (block.lines.length == 2) {
        textFromPic = "";
        for (TextElement element in block.lines[0].elements) {
          print(element.text);
          textFromPic = textFromPic + element.text! + " ";
          nom.text = textFromPic;
        }
        for (TextElement element in block.lines[1].elements) {
          print(element.text);
          textFromPic = textFromPic + element.text! + " ";
          numero.text = textFromPic;
        }
      }
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          print(element.text);
          textFromPic = textFromPic + element.text! + "\n";
        }
      }
    }
  }
*/
  @override
  void initState() {
    // TODO: implement initState
    if (widget.contact != null) {
      setState(() {
        nom.text = widget.contact!['nom'];
        numero.text = widget.contact!['numero'];
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modification"),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Card(
          child: ListTile(
            title: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: (resList != null && resList!.isNotEmpty)
                            ? FileImage(File(resList![0].path))
                            : FileImage(File(""))))),
            subtitle: const Text("Ajouter ou modifier photo de profil"),
            trailing: const Icon(Icons.add_a_photo),
            onTap: () async {
              await controller
                  .playSong("assets/audio/${Model.lang}/ajouter_photo.aac");
              //controller
              //    .playSong("assets/audio/${Model.lang}/vert_ou_rouge.aac");
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('notification'),
                      content: SizedBox(
                        height: 120,
                        child: Column(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  getImage();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Text('valider'),
                                )),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 20),
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Text('Annuler'),
                                ))
                          ],
                        ),
                      ),
                    );
                  });
            },
          ),
        ),
        Card(
            child: ListTile(
                title: TextFormField(
                  controller: nom,
                  decoration: const InputDecoration(hintText: 'nom du contact'),
                ),
                subtitle: const Text("nom du contact"),
                trailing: const Icon(Icons.mic))),
        Card(
            child: ListTile(
                title: TextFormField(
                  controller: numero,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(hintText: 'numero du contact'),
                ),
                subtitle: const Text("numero du contact"),
                trailing: const Icon(Icons.mic))),
        Card(
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(width: 5, color: Colors.grey)),
                child: ListTile(
                    onTap: () {
                      /*getImage().then((value) {
                        scanImage(context);
                      });*/
                    },
                    subtitle: const Text("Lire les informations sur une image"),
                    title: const Icon(Icons.image, size: 50),
                    trailing: const Icon(Icons.newspaper, size: 50)))),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 3, color: Colors.red)),
                child: IconButton(
                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                    onPressed: () async {
                      await controller
                          .playSong("assets/audio/${Model.lang}/supprimer.aac");
                      //controller.playSong(
                      //    "assets/audio/${Model.lang}/vert_ou_rouge.aac");
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('notification'),
                              content: SizedBox(
                                height: 120,
                                child: Column(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          if (widget.contact != null) {
                                            controller.deleteContact(
                                                widget.contact!['id']);
                                          }

                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 20),
                                          margin: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: const Text('valider'),
                                        )),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 20),
                                          margin: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: const Text('Annuler'),
                                        ))
                                  ],
                                ),
                              ),
                            );
                          });
                    })),
            ElevatedButton.icon(
                onPressed: () async {
                  controller
                      .playSong("assets/audio/${Model.lang}/vert_ou_rouge.aac");
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('notification'),
                          content: SizedBox(
                            height: 120,
                            child: Column(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      if (widget.contact == null) {
                                        controller.addContact(
                                            nom.text,
                                            numero.text,
                                            (resList != null &&
                                                    resList!.isNotEmpty)
                                                ? resList![0].path
                                                : '');
                                      } else {
                                        controller.updateContact(
                                            widget.contact!['id'],
                                            nom.text,
                                            numero.text,
                                            (resList != null &&
                                                    resList!.isNotEmpty)
                                                ? resList![0].path
                                                : '');
                                      }
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 20),
                                      margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Text('valider'),
                                    )),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 20),
                                      margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Text('Annuler'),
                                    ))
                              ],
                            ),
                          ),
                        );
                      });
                },
                icon: const Icon(Icons.save, size: 50),
                label: const Text(
                  'Enregistrer',
                  style: TextStyle(fontSize: 35),
                ))
          ],
        )
      ]),
    );
  }
}
