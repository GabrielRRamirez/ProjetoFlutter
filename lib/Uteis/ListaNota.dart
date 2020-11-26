import 'package:flutter/material.dart';
import 'package:joia2/Models/Nota.dart';

void alertaNota(BuildContext context, String msg, Nota n,
    Function(int controle) calback) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            child: Container(
              height: 160.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    msg,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          color: Colors.deepPurple,
                          textColor: Colors.white,
                          child: Text('Excluir'),
                          onPressed: () {
                            Navigator.pop(context);
                            calback(1);
                          },
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        FlatButton(
                          color: Colors.deepPurple,
                          textColor: Colors.white,
                          child: Text('Alterar'),
                          onPressed: () {
                            Navigator.pop(context);
                            calback(2);

                          },
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        FlatButton(
                          color: Colors.deepPurple,
                          textColor: Colors.white,
                          child: Text('Cancelar'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ));
      });
}

