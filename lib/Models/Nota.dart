class Nota{

  String descricao;
  double valor;
  int id;
  int data;
  String observacao;

  Nota({this.descricao, this.valor, this.id, this.data, this.observacao});


  Map<String, dynamic> toMapNota() {
    return {
      'id' : id,
      'descricao': descricao,
      'valor': valor,
      'data' : data,

      'observacao': observacao

    };
  }

}

