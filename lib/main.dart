import 'dart:async';
import 'dart:io';

import 'package:appanalpha/controller.dart';
import 'package:appanalpha/detail.dart';
import 'package:appanalpha/edit.dart';
import 'package:appanalpha/model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const NouveauPage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Controller controller = Controller();
  @override
  void initState() {
    // TODO: implement initState
    controller.playSong("assets/audio/${Model.lang}/bienvenue.aac");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              Card(
                  child: Container(
                height: 150,
                width: 150,
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.account_circle,
                      size: 120,
                    )),
              )),
              GestureDetector(
                  onTap: () async {
                    await controller
                        .playSong("assets/audio/${Model.lang}/ajouter.aac");
                    Timer(const Duration(seconds: 5), () {
                      controller.playSong(
                          "assets/audio/${Model.lang}/vert_ou_rouge.aac");
                    });

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
                                          return EditPage();
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
                  child: const Card(
                      child: SizedBox(
                    height: 150,
                    width: 150,
                    child: Icon(Icons.person_add, size: 100),
                  )))
            ]),
            Expanded(
                child: SizedBox(
                    child: StreamBuilder(
                        stream: controller.listContacts(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error);
                          }
                          if (snapshot.hasData) {
                            List<Map<String, dynamic>> data =
                                snapshot.data as List<Map<String, dynamic>>;
                            if (data.isEmpty) {
                              return const ListTile(
                                title: Text("Vide"),
                                trailing: Icon(
                                  Icons.close,
                                  size: 100,
                                ),
                              );
                            }
                            return ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                      child: ListTile(
                                    leading: CircleAvatar(
                                      child: Image.file(
                                          File(data[index]['image'])),
                                    ),
                                    title: Text(data[index]['nom'],
                                        style: const TextStyle(fontSize: 25)),
                                    subtitle: Text(data[index]['numero'],
                                        style: const TextStyle(fontSize: 25)),
                                    trailing: const Icon(Icons.volume_up),
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return Information(
                                            contact: data[index]);
                                      }));
                                    },
                                  ));
                                });
                          }
                          return const CircularProgressIndicator();
                        }))),
          ])),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        tooltip: '',
        child: Icon(Icons.qr_code),
      ),
    );
  }
}

class NouveauPage extends StatefulWidget {
  const NouveauPage({Key? key}) : super(key: key);

  @override
  State<NouveauPage> createState() => _NouveauPageState();
}

class _NouveauPageState extends State<NouveauPage> {
  TextEditingController num = TextEditingController();
  String? langue;
  final menuItems = <String>["moore", "dioula"]
      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
      .toList();
  Controller controller = Controller();

  @override
  void initState() {
    // TODO: implement initState
    controller.playSong("assets/audio/moore/bienvenue.aac");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("NUMERO")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(Icons.call, size: 120),
            TextFormField(
              style: const TextStyle(fontSize: 30),
              controller: num,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(hintText: 'mon numéro 226xxxxxxxx'),
            ),
            DropdownButton(
                style: const TextStyle(fontSize: 25, color: Colors.black),
                value: langue,
                hint: const Text("Choisir langue"),
                items: menuItems,
                onChanged: (String? onChanged) {
                  if (onChanged != null) {
                    setState(() {
                      langue = onChanged;
                    });
                  }
                }),
            Card(
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.green),
                    child: ListTile(
                      title:
                          const Text("Valider", style: TextStyle(fontSize: 50)),
                      trailing: const Icon(Icons.check_circle, size: 50),
                      onTap: () {
                        controller
                            .playSong("assets/audio/$langue/vert_ou_rouge.aac");
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
                                            if (num.text != '' &&
                                                langue != null) {
                                              setState(() {
                                                Model.num = num.text;
                                                Model.lang = langue;
                                              });
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return const MyHomePage(
                                                    title: 'NUMERO');
                                              }));
                                            } else {}
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
          ],
        ));
  }
}
