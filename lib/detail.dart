//import 'dart:async';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:appanalpha/controller.dart';
import 'package:appanalpha/edit.dart';
import 'package:appanalpha/model.dart';
import 'package:flutter/material.dart';

class Information extends StatefulWidget {
  Information({Key? key, required this.contact}) : super(key: key);
  Map<String, dynamic> contact;
  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  Controller controller = Controller();

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    //controller.playSong("assets/moore/az.mp3");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Information")),
        body:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Card(
                  child: Container(
                height: 200,
                width: 200,
                child: Image.file(File(widget.contact['image'])),
              )),
              Card(
                  child: Container(
                height: 100,
                width: 100,
                child: IconButton(
                  icon: const Icon(Icons.volume_up, size: 50),
                  onPressed: () async {
                    var list = widget.contact['numero'].toString().split('');
                    print(list);
                    for (var e in list) {
                      print('***');
                      print(e);
                      await controller
                          .playSong("assets/audio/${Model.lang}/$e.aac");
                    }
                  },
                ),
              ))
            ],
          )),
          Card(
              child: ListTile(
            title: Text(widget.contact['nom'],
                style: const TextStyle(fontSize: 50)),
            subtitle:
                const Text("nom du contact", style: TextStyle(fontSize: 15)),
          )),
          Card(
              child: ListTile(
            title: Text(widget.contact['numero'],
                style: const TextStyle(fontSize: 55)),
            subtitle:
                const Text("Numéro du contact", style: TextStyle(fontSize: 15)),
          )),
          Card(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 5, color: Colors.grey)),
                  child: ListTile(
                    title: const Text("Appeler",
                        style: const TextStyle(fontSize: 50)),
                    trailing: const Icon(Icons.call, size: 50),
                    onTap: () async {
                      await controller
                          .playSong("assets/audio/${Model.lang}/appeler.aac");
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
                                          Navigator.pop(context);
                                          _launchUrl(
                                              "tel:widget.contact['numero']");
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
                  ))),
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
                        await controller.playSong(
                            "assets/audio/${Model.lang}/supprimer.aac");
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
                                            controller.deleteContact(
                                                widget.contact['id']);
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
                    //await controller
                    //    .playSong("assets/audio/${Model.lang}/mo.aac");
                    controller.playSong(
                        "assets/audio/${Model.lang}/vert_ou_rouge.aac");
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
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return EditPage(
                                            contact: widget.contact,
                                          );
                                        }));
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
                  icon: const Icon(Icons.edit, size: 50),
                  label: const Text(
                    'Modifier\nle contact',
                    style: TextStyle(fontSize: 35),
                  ))
            ],
          )
        ]));
  }
}
