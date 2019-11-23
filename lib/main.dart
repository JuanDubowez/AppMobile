import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:application/model.dart';
import 'package:application/vistas/viewCategory.dart';
import 'package:application/vistas/newCategory.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appcordate',
      theme: ThemeData(
        brightness: Brightness.dark,
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

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Agregar categoria"),
          content: PaginaCreacion(),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    listaCategorias.clear();
    Future<DataSnapshot> databaseReference =
        FirebaseDatabase.instance.reference().once();
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      direction: DismissDirection.endToStart,
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
                          border: Border.all(
                            color: Colors.white,
                          ),
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
                                builder: (context) => CategoryPage(
                                  category: listaCategorias[index].titulo,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog();
        },
        tooltip: 'Agregar',
        child: Icon(Icons.add),
      ),
    );
  }
}
