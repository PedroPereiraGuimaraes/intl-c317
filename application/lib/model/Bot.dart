class Bot {
  final String name;
  final List<String> perguntas;
  final List<String> respostas;

  Bot({
    required this.name,
    required this.perguntas,
    required this.respostas,
  });

  factory Bot.fromJson(Map<String, dynamic> json) {
    return Bot(
      name: json['name'] as String,
      perguntas:
          (json['pergunta'] as List<dynamic>).map((e) => e as String).toList(),
      respostas:
          (json['resposta'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'pergunta': perguntas,
      'resposta': respostas,
    };
  }
}
