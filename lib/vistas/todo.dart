import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:application/model.dart';

class ToDoPage extends StatefulWidget {
  ToDoPage({Key key, this.child}) : super(key: key);
  final String child;

  @override
  _ToDoPageState createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  List<Item> listaItems = List<Item>();

  @override
  Widget build(BuildContext context) {
    Future<DataSnapshot> databaseReference =
        FirebaseDatabase.instance.reference().child(widget.child).once();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.child[0].toUpperCase() + widget.child.substring(1)),
      ),
      body: Container(
        child: FutureBuilder(
          future: databaseReference.then((DataSnapshot snapshot) {
            snapshot.value.forEach((key, value) {
              listaItems.add(Item(key, value));
            });
          }),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                  itemCount: listaItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: ListTile(
                        title: Text(listaItems[index].texto),
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
