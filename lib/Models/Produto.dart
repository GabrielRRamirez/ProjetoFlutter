class Produto {
  int id;
  int id_nota;
  String nome;
  double valor;
  int fio;
  int vidrilho;

  Produto({this.id, this.id_nota, this.nome, this.valor, this.fio, this.vidrilho});

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'id_nota': id_nota,
      'nome': nome,
      'valor': valor,
      'fio' : fio,
      'vidrilho' : vidrilho
    };
  }

}


