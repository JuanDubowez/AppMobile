import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:application/model.dart';

class PaginaCreacion extends StatefulWidget {
  PaginaCreacion({Key key}) : super(key: key);

  @override
  _PaginaCreaciState createState() => _PaginaCreaciState();
}

class _PaginaCreaciState extends State<PaginaCreacion> {
  final myController = TextEditingController();
  bool _validate = false;

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  _agregar() {
    if (myController.value.text != null && myController.value.text.isNotEmpty) {
      myController.clear();
    }
    FirebaseDatabase.instance
        .reference()
        .child(myController.value.text)
        .set({'llave2': 'valor2'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nueva catgoria"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  controller: myController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Titulo',
                    errorText: _validate ? 'Debes ingresar un texto' : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: MaterialButton(
                    child: Text(
                      'Guardar',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    onPressed: () {
                      setState(() {
                        myController.text.isEmpty
                            ? _validate = true
                            : _validate = false;
                      });
                      _agregar();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
