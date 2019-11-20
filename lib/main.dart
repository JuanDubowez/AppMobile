import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:application/model.dart';
import 'package:application/vistas/todo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicacion de Juan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Categoria> listaCategorias = List<Categoria>();

  @override
  Widget build(BuildContext context) {
    listaCategorias.clear();
    Future<DataSnapshot> databaseReference =
        FirebaseDatabase.instance.reference().once();
    return Scaffold(
      appBar: AppBar(
        title: Text("Notas"),
      ),
      body: Container(
        child: FutureBuilder(
          future: databaseReference.then((DataSnapshot snapshot) {
            snapshot.value.forEach((key, value) {
              listaCategorias.add(Categoria(key));
            });
          }),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                  itemCount: listaCategorias.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Dismissible(
                      key: Key(index.toString()),
                      background: Container(color: Colors.red),
                      onDismissed: (direction) {
                        FirebaseDatabase.instance
                            .reference()
                            .child((listaCategorias[index].titulo).toString())
                            .remove();
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: ListTile(
                          title: Text(
                              listaCategorias[index].titulo[0].toUpperCase() +
                                  listaCategorias[index].titulo.substring(1)),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ToDoPage(
                                  child: listaCategorias[index].titulo,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  });
            }
            return Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}
