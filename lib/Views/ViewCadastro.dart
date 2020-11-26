import 'package:flutter/material.dart';
import 'package:joia2/Models/Produto.dart';

class Cadastro extends StatefulWidget {
  Cadastro({@required this.id_nota});
  int id_nota;
  @override
  _CadastroState createState() => _CadastroState(id_nota);
}

class _CadastroState extends State<Cadastro> {

  _CadastroState(this.id_nota);
  final fioController = TextEditingController();
  final vidrilhoController = TextEditingController();

  int id_nota;
  int id;
  String nome;
  double valor;
  int fio;
  int vidrilho;


  @override
  Widget build(BuildContext context) {
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
                    border: InputBorder.none, hintText: 'Informe os Vidrilhos:'),
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
                      alerta(context, 'Preencha a quantidade de fios Corretamente!');
                    }
                    if (vidrilhoController.text != '') {
                      vidrilho = int.parse(vidrilhoController.text);
                    } else {
                      alerta(context, 'Preencha a quantidade de Vidrilhos Corretamente!');
                    }

                    nome = fioController.text + " x " + vidrilhoController.text;
                    valor = _valorSaquinho(fio, vidrilho);
                    Produto p = new Produto(

                        id_nota: id_nota,
                        nome: nome,
                        valor: double.parse(valor.toStringAsFixed(2)),
                        fio: fio,
                      vidrilho: vidrilho
                    );

                    Navigator.pop(context, p);
                  })
            ],
          ),
        ),
      ),
    );
  }


}

void alerta(BuildContext context, String msg) {
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

double _valorSaquinho(int fios, int vidrilho){

  return (((fios * vidrilho)/6)*20)/1000;
}
