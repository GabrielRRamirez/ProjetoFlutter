import 'package:flutter/material.dart';
import 'package:joia2/Models/Produto.dart';
import 'package:joia2/Uteis/Functions.dart';

class Altera extends StatelessWidget {
  Altera({@required this.id_nota, this.produto});

  TextEditingController fioController = TextEditingController();
  TextEditingController vidrilhoController = TextEditingController();
  int id_nota;
  int id = null;
  String nome;
  double valor;
  int fio;
  int vidrilho;
  final Produto produto;

  @override
  Widget build(BuildContext context) {
    fioController.text = produto.fio.toString();
    vidrilhoController.text = produto.vidrilho.toString();
    id = produto.id;
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo Produto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Spacer(),
              Text(
                "Fios:",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Informe os Fios'),
                controller: fioController,
                keyboardType: TextInputType.number,
              ),
              Spacer(),
              Text(
                "Vidrilhos: ",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Informe os Vidrilhos:'),
                keyboardType: TextInputType.number,
                controller: vidrilhoController,
              ),
              Spacer(),
              FlatButton(
                  child: Text('Salvar'),
                  textColor: Colors.white,
                  color: Colors.deepPurple,
                  onPressed: () {
                    if (fioController.text.length > 0) {
                      fio = int.parse(fioController.text);
                    } else {
                      Alerta(context,
                          'Preencha a quantidade de fios Corretamente!');
                    }
                    if (vidrilhoController.text != '') {
                      vidrilho = int.parse(vidrilhoController.text);
                    } else {
                      Alerta(context,
                          'Preencha a quantidade de Vidrilhos Corretamente!');
                    }

                    nome = fioController.text + " x " + vidrilhoController.text;
                    valor = valorSaquinho(fio, vidrilho);
                    Produto p = new Produto(
                        id: id,
                        id_nota: id_nota,
                        nome: nome,
                        valor: double.parse(valor.toStringAsFixed(2)),
                        fio: fio,
                        vidrilho: vidrilho);

                    Navigator.pop(context, p);
                  })
            ],
          ),
        ),
      ),
    );
  }
}

