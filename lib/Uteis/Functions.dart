import 'package:flutter/material.dart';
import 'package:joia2/Models/Nota.dart';
import 'package:joia2/Models/Produto.dart';

String formataData(DateTime data) {
    String formatada = '';
    if (data != null) {
      formatada = data.day.toString() +
          '/' +
          data.month.toString() +
          '/' +
          data.year.toString();
    }
    return formatada;
  }

double subtotal(List<Nota> nota) {
  double soma = 0;
  if (nota.length > 0 && nota != null) {
    for (int i = 0; i < nota.length; i++) {
      soma += nota[i].valor;
    }
    return soma;
  }
}

double valorSaquinho(int fios, int vidrilho) {
  return (((fios * vidrilho) / 6) * 20) / 1000;
}



double subtotalProduto(List<Produto> produto) {
  double soma = 0;
  for (int i = 0; i < produto.length; i++) {
    soma += produto[i].valor;
  }
  return double.parse(soma.toStringAsFixed(2));
}


void Alerta(BuildContext context, String msg) {
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
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          color: Colors.deepPurple,
                          textColor: Colors.white,
                          child: Text('Ok'),
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



