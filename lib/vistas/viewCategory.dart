import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:application/model.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key, this.category}) : super(key: key);
  final String category;

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Item> listaItems = List<Item>();
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  _agregar() {
    if (myController.value.text != null && myController.value.text.isNotEmpty) {
      FirebaseDatabase.instance
          .reference()
          .child(widget.category)
          .push()
          .set(myController.value.text);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    listaItems.clear();
    Future<DataSnapshot> databaseReference =
        FirebaseDatabase.instance.reference().child(widget.category).once();
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.category[0].toUpperCase() + widget.category.substring(1)),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: myController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      _agregar();
                    },
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future: databaseReference.then((DataSnapshot snapshot) {
                snapshot.value.forEach((key, value) {
                  listaItems.add(Item(key, value));
                });
              }),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (listaItems.isNotEmpty) {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: listaItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: ListTile(
                                title: Text(
                                  (listaItems[index].texto[0].toUpperCase() +
                                      listaItems[index].texto.substring(1)),
                                ),
                              ),
                            );
                          }),
                    );
                  } else {
                    return Center(
                      child: Text("No hay items"),
                    );
                  }
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
      resizeToAvoidBottomPadding: true,
    );
  }
}
