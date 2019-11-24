import 'package:flutter/material.dart';
import 'package:application/vistas/viewCategory.dart';

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
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CategoryPage(category: myController.value.text)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
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
            padding: const EdgeInsets.only(top: 20),
            child: MaterialButton(
              child: Text(
                'Guardar',
                style: TextStyle(color: Colors.black),
              ),
              color: Colors.tealAccent,
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
    );
  }
}
