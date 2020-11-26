import 'package:flutter/material.dart';
import 'package:joia2/Models/Nota.dart';
import 'package:joia2/Models/Produto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

var database;

void inicializaNota() async {
  WidgetsFlutterBinding.ensureInitialized();
  database = openDatabase(join(await getDatabasesPath(), 'dbJoia16.db'),
      version: 1, onCreate: (db, version) {
    db.execute(
        "CREATE TABLE nota(id INTEGER PRIMARY KEY AUTOINCREMENT, descricao TEXT, valor DOUBLE, data INTEGER, observacao TEXT) ");
    db.execute(
        "CREATE TABLE produtos(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, valor DOUBLE, fio INTEGER, vidrilho INTEGER, id_nota INTEGER NOT NULL, FOREIGN KEY (id_nota)  REFERENCES nota(id)) ");
  });
}

Future<int> inserirNota(Nota n) async {
  final Database db = await database;

  int id = await db.insert(
    'nota',
    n.toMapNota(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  return id;
}

Future<List<Nota>> exibeNota() async {
  final Database db = await database;
  final List<Map<String, dynamic>> maps = await db.query('nota', orderBy: 'data');

  return List.generate(maps.length, (i) {
    return Nota(
        id: maps[i]['id'],
        descricao: maps[i]['descricao'],
        valor: maps[i]['valor'],
        data: maps[i]['data'],
        observacao: maps[i]['observacao']);
  });
}

Future<void> apagarNota(int id) async {
  final Database db = await database;
  await db.delete('produtos', where: 'id_nota = ?', whereArgs: [id]);
  await db.delete('nota', where: 'id = ?', whereArgs: [id]);
}

Future<List<Nota>> consultarLancamentos(int datainicio, int datafim) async {
  final Database db = await database;
  final List<Map<String, dynamic>> maps = await db.query('nota', orderBy: 'data',
      where: 'data between ? and ?', whereArgs: [datainicio, datafim]);

  return List.generate(maps.length, (i) {
    return Nota(
        id: maps[i]['id'],
        descricao: maps[i]['descricao'],
        valor: maps[i]['valor'],
        data: maps[i]['data'],
        observacao: maps[i]['observacao']);
  });
}

Future<List<Nota>> carregaInicio(int datainicio, int datafim) async {
  final Database db = await database;
  final List<Map<String, dynamic>> maps = await db.query('nota', orderBy: 'data',where: 'data between ? and ?', whereArgs: [datainicio,datafim] );

  return List.generate(maps.length, (i) {
    return Nota(
        id: maps[i]['id'],
        descricao: maps[i]['descricao'],
        valor: maps[i]['valor'],
        data: maps[i]['data'],
        observacao: maps[i]['observacao']);
  });
}

//---------------------------------------------- produto --------------------------------------------------------------//


Future<void> inserirProduto(Produto p) async {
  final Database db = await database;

  await db.insert(
    'produtos',
    p.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Produto>> exibeProdutoN(int id_nota) async {
  final Database db = await database;
  final List<Map<String, dynamic>> maps =
      await db.query('produtos', orderBy: 'id', where: 'id_nota = ?', whereArgs: [id_nota]);

  return List.generate(maps.length, (i) {
    return Produto(
        id: maps[i]['id'],
        id_nota: maps[i]['id_nota'],
        nome: maps[i]['nome'],
        valor: maps[i]['valor'],
        fio: maps[i]['fio'],
        vidrilho: maps[i]['vidrilho']);
  });
}

Future<void> apagarProduto(int id, int id_nota) async {
  final Database db = await database;
  await db.delete('produtos',
      where: 'id= ? and id_nota = ?', whereArgs: [id, id_nota]);
}
