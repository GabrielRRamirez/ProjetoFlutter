import 'package:flutter/material.dart';
import 'package:joia2/Dao/NotaDao.dart';
import 'package:joia2/Models/Nota.dart';
import 'package:joia2/Models/Produto.dart';
import 'package:joia2/Uteis/Functions.dart';
import 'package:joia2/Views/ViewAlteraCadastro.dart';
import 'package:joia2/Views/ViewCadastro.dart';

class CadastroNota extends StatefulWidget {
  CadastroNota({@required this.nota});
  Nota nota;

  @override
  _CadastroState createState() => _CadastroState(this.nota);
}

class _CadastroState extends State<CadastroNota> {
  _CadastroState(this.nota);

  final obsController = TextEditingController();
  List<Produto> produto = [];
  Produto selecionado = null;
  int id_nota = null;
  DateTime data = null;
  Nota nota = null;
  double valor = 0;

  @override
  void initState() {
    if (this.nota != null) {
      data = DateTime.fromMillisecondsSinceEpoch(nota.data);
      id_nota = nota.id;

      obsController.text = nota.observacao.toString();
      carregaProduto();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nova Nota"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  "Observação",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            TextFormField(
              autofocus: false,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Informe a observação'),
              controller: obsController,
              keyboardType: TextInputType.text,
            ),

            Row( children: <Widget>[
              Text(
                "Data ",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                  icon: Icon(Icons.date_range),
                  onPressed: () async {
                    final dataPick = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2018),
                        lastDate: DateTime(2030),
                        helpText: 'Data da Nota:',
                        locale: Locale("pt", "BR"));
                    setState(() {
                      //if(dataPick != null){
                      if (dataPick != null) {
                        data = dataPick;
                      }

                      //}
                    });
                  }),
              Text(
                formataData(data) ?? '',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
            SizedBox(
              height: 50.0,
            ),
            Expanded(
                child: ListView(
              children: geraLista(),
            )),
            Row(children: <Widget>[
              Text(
                "Total itens: RS" + subtotalProduto(produto).toString(),
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
            Row(
              children: <Widget>[
                FlatButton(
                    child: Text('Adicionar Produto'),
                    textColor: Colors.white,
                    color: Colors.deepPurple,
                    onPressed: () async {
                      if (data != null) {
                        if (obsController.text == null) {
                          obsController.text = '';
                        }
                      } else {
                        Alerta(context, 'Insira a data Corretamente!');
                        return;
                      }

                      if (nota != null) {
                        _chamaCadastro(context);
                      } else {
                        valor = subtotalProduto(produto);
                        nota = new Nota(
                            data: data.millisecondsSinceEpoch,
                            observacao: obsController.text,
                            valor: valor);
                        id_nota = await inserirNota(nota);
                        if (id_nota > 0 && id_nota != null) {
                          nota.id = id_nota;
                          print(nota.id);
                          _chamaCadastro(context);
                        }
                      }
                    }),
              ],
            ),
            Row(
              children: <Widget>[
                FlatButton(
                    child: Text('Salvar'),
                    textColor: Colors.white,
                    color: Colors.deepPurple,
                    onPressed: () async {
                      if (data != null && data.millisecondsSinceEpoch > 0) {
                        if (obsController.text == null) {
                          obsController.text = '';
                        }
                      } else {
                        Alerta(context, 'Insira a data Corretamente!');
                        return;
                      }
                      if (nota == null) {
                        nota = new Nota(
                            data: data.millisecondsSinceEpoch,
                            observacao: obsController.text,
                            valor: subtotalProduto(produto));
                        id_nota = await inserirNota(nota);
                        nota.id = id_nota;
                        print(nota.id);
                      } else {
                        nota.valor = subtotalProduto(produto);
                        print('antes' + nota.id.toString());
                        int x = await inserirNota(nota);
                        print(x);
                        Navigator.pop(context);
                      }
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }

  // parte do produto na tela

  List<Widget> geraLista() {
    List<Widget> retorno = [];
    for (Produto p in produto) {
      retorno.add(geraCelula(p));
    }
    return retorno;
  }

  Widget geraCelula(Produto p) {
    return GestureDetector(
      onTap: () async {
        selecionado = p;
        await alertaProduto(context, 'O que deseja Fazer? ', selecionado);
      },
      child: Container(
        height: 60.0,
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                p.nome,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Text(
                'RS ' + p.valor.toString(),
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _chamaCadastro(BuildContext context) async {
    final retornoTela = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Cadastro(
            id_nota: id_nota,
          ),
        ));
    setState(() {
      inserirProduto(retornoTela);
      carregaProduto();
    });
  }

  void _chamaAltera(BuildContext context, Produto p) async {
    final retornoTela = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Altera(
            id_nota: nota.id,
            produto: p,
          ),
        ));
    setState(() {
      inserirProduto(retornoTela);
      carregaProduto();
    });
  }

  void carregaProduto() async {
    produto = await exibeProdutoN(id_nota);
    setState(() {});
  }

  void alertaProduto(BuildContext context, String msg, Produto p) {
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
                        onPressed: () async {
                          await apagarProduto(p.id, nota.id);
                          setState(() {
                            carregaProduto();
                          });

                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      FlatButton(
                        color: Colors.deepPurple,
                        textColor: Colors.white,
                        child: Text('Alterar'),
                        onPressed: () async {
                          await _chamaAltera(context, p);
                          Navigator.pop(context);
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
}
