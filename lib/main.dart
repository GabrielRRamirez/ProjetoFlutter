import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:joia2/Dao/NotaDao.dart';
import 'package:joia2/Models/Nota.dart';
import 'package:joia2/Uteis/Functions.dart';
import 'package:joia2/Views/ViewCadastroNota.dart';
import 'package:joia2/Views/ViewConsulta.dart';

import 'Uteis/ListaNota.dart';

void main() async {
  await inicializaNota();

  runApp(RootPage());
}

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [Locale("pt", "BR")],
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/consultas': (context) => Consulta(),
        '/cadastro': (context) => CadastroNota(),
        '/principal': (context) => Inicial(),
      },
      initialRoute: '/principal',
    );
  }
}

class Inicial extends StatefulWidget {
  @override
  _InicialState createState() => _InicialState();
}

class _InicialState extends State<Inicial> {
  List<Nota> nota = [];
  Nota selecionado = null;
  bool sub = false;

  void inicial() async {
    DateTime dataAtual = DateTime.now();
    DateTime dataInicio = DateTime(dataAtual.year, dataAtual.month, 01);
    DateTime dataFinal = DateTime(dataAtual.year, dataAtual.month, 31);
    nota = await carregaInicio(
        dataInicio.millisecondsSinceEpoch, dataFinal.millisecondsSinceEpoch);
    if (nota.length > 0) sub = true;
    setState(() {});
  }

  @override
  void initState() {
    inicial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lista de Notas:"),
          backgroundColor: Colors.deepPurple,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: ListView(
              children: geraLista() ?? 'Nenhum Lançamento encontrado',
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  sub ? "Total RS: " + subtotal(nota).toString() : '',
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
            FlatButton(
                child: Text("Adicionar"),
                textColor: Colors.white,
                color: Colors.deepPurple,
                onPressed: () async {
                  _chamaCadastroNota(context); //chama tela
                })
          ],
        ),
        drawer: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          DrawerHeader(
            child: Text(
              'Menu',
              style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
          ),
          ListTile(
            title: Text(
              'Consultar Lançamentos',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Consulta(),
                  ));
            },
          )
        ])));
  }

  void _chamaCadastroNota(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CadastroNota(),
        ));
    setState(() {
      inicial();
    });
  }

  void _chamaAltera(BuildContext context, Nota n) async {
    final retornoTela = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CadastroNota(nota: n),
        ));
    setState(() {
      inicial();
      if (nota.length > 0) {
        sub = true;
      } else {
        sub = false;
      }
    });
  }

// -------metodo para carregar nota

  //metodo que formata a celula na tela
  Widget geraCelula(Nota n) {
    return GestureDetector(
      onTap: () async {
        if (n != null) {
          selecionado = n;

          await alertaNota(context, 'O que deseja Fazer? ', selecionado,  (controle) {
            if(controle==1){
              setState(() {
                 apagarNota(n.id);
                inicial();
              });
            } else if(controle == 2){
              setState(() {
                 _chamaAltera(context, n);
                inicial();

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
                formataData(DateTime.fromMillisecondsSinceEpoch(n.data)) ?? '',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Text(
                'RS ' + n.valor.toString() ?? '',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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

  // metodo que joga um alert na tela com alterar/ excluir

}
