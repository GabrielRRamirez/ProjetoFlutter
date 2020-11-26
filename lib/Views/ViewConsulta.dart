import 'package:flutter/material.dart';
import 'package:joia2/Dao/NotaDao.dart';
import 'package:joia2/Models/Nota.dart';
import 'package:joia2/Uteis/Functions.dart';
import 'package:joia2/Uteis/ListaNota.dart';

import 'ViewCadastroNota.dart';

class Consulta extends StatefulWidget {
  @override
  _ConsultaState createState() => _ConsultaState();
}

class _ConsultaState extends State<Consulta> {
  DateTime dataicio = null;
  DateTime datafim = null;
  bool sub = false;

  List<Nota> nota = [];
  Nota selecionado = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar Lançamentos:'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("Data Inicial:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),),
                IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () async {
                      final dataPickInicio = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2018),
                          lastDate: DateTime(2030),
                          helpText: 'Data Inicial:',
                          locale: Locale("pt", "BR"));
                      setState(() {
                        if (dataPickInicio != null) {
                          dataicio = dataPickInicio;
                        }
                      });
                    }),
              ],
            ),
            Row(
              children: [
                Text(formataData(dataicio),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),),
              ],
            ),

            Row(
              children: <Widget>[
                Text("Data Final:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),),
                IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () async {
                      final dataPickFinal = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2018),
                          lastDate: DateTime(2030),
                          helpText: 'Data Inicial:',
                          locale: Locale("pt", "BR"));
                      setState(() {
                        if (dataPickFinal != null) {
                          datafim = dataPickFinal;
                        }
                      });
                    }),
              ],
            ),
            Row(
              children: [
                Text(formataData(datafim),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),),
              ],
            ),

            FlatButton(
                child: Text('Buscar'),
                textColor: Colors.white,
                color: Colors.deepPurple,
                onPressed: () async {
                  if (dataicio.millisecondsSinceEpoch >
                      datafim.millisecondsSinceEpoch) {
                    Alerta(context, 'Período informado Inválido!');
                  } else {
                    atualizaBusca();


                  }
                }),
            Expanded(
              child: ListView(
                children: geraLista() ?? 'Nenhum Lançamento encontrado',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  sub?"Total RS: " + subtotal(nota).toString():'',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 05.0,
            ),
          ],
        ),
      ),
    );
  }

  void _chamaAltera(BuildContext context, Nota n) async {
    final retornoTela = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CadastroNota(nota: n),
        ));
    setState(() {
      consultarLancamentos(
          dataicio.millisecondsSinceEpoch, datafim.millisecondsSinceEpoch);
    });
  }

  //metodo que formata a celula na tela
  Widget geraCelula(Nota n) {
    return GestureDetector(
      onTap: () async {
        if (n != null) {
          await alertaNota(context, 'O que deseja Fazer? ', selecionado,  (controle) {
            if(controle==1){
              setState(() {
                 apagarNota(n.id);
                atualizaBusca();
              });
            } else if(controle == 2){
              setState(() {
                _chamaAltera(context, n);
                atualizaBusca();

              });

            }
          });
        }
      },
      child: Container(
        height: 60.0,
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                formataData(DateTime.fromMillisecondsSinceEpoch(n.data)) ??
                    '',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
              ),
              Text(
                'RS ' + n.valor.toString() ?? '',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // metodo que pega lista e manda para o gera celula
  List<Widget> geraLista() {
    List<Widget> retorno = [];
    for (Nota n in nota) {
      retorno.add(geraCelula(n));
    }
    return retorno;
  }

  void atualizaBusca() async{
    nota = await consultarLancamentos(
        dataicio.millisecondsSinceEpoch,
        datafim.millisecondsSinceEpoch);
    setState(() {
      if(nota.length ==  0) {
        sub = false;
      }
      else{

        sub = true;
      }
    });
  }


}
