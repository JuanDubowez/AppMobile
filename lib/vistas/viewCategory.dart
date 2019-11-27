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
  final myController = TextEditingController();

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

  _editar(String id, String txt) {
    if (txt != null && txt.isNotEmpty) {
      FirebaseDatabase.instance
          .reference()
          .child(widget.category)
          .child(id)
          .set(txt);
    }
    setState(() {});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Future<DataSnapshot> databaseReference = FirebaseDatabase.instance
        .reference()
        .child(widget.category)
        .orderByKey()
        .once();

    List<Item> listaItems = List<Item>();

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
                textInputAction: TextInputAction.send,
                onFieldSubmitted: (String value) {
                  _agregar();
                },
                controller: myController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      _agregar();
                      WidgetsBinding.instance.addPostFrameCallback(
                              (_) => myController.clear());
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
                listaItems.sort((Item a, Item b) => a.id.compareTo(b.id));
                if (snapshot.connectionState == ConnectionState.done) {
                  if (listaItems.isNotEmpty) {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: listaItems.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            return Dismissible(
                              direction: DismissDirection.endToStart,
                              key: Key(index.toString()),
                              background: Container(
                              color: Colors.red,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(Icons.delete_forever, size: 30,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            onDismissed: (direction) {
                            FirebaseDatabase.instance
                                .reference()
                                .child(widget.category)
                                .child((listaItems[index].id).toString())
                                .remove();
                            },
                            child: GestureDetector(
                            onTap: () {
                            showDialog(
                            context: context,
                            builder: (BuildContext context) {
                            return AlertDialog(
                            title: new Text("Editar item"),
                            content: Container(
                            child: TextFormField(
                            initialValue:
                            listaItems[index].texto,
                            textInputAction:
                            TextInputAction.send,
                            onFieldSubmitted: (String value) {
                            _editar(
                            listaItems[index].id, value);
                            },
                            decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Texto',
                            ),
                            ),
                            ),
                            );
                            },
                            );
                            },
                            child: Container(
                            child: ListTile(
                            title: Text(
                            (listaItems[index]
                                .texto[0]
                                .toUpperCase() +
                            listaItems[index].texto.substring(1)),
                            ),
                            ),
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

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }
}
