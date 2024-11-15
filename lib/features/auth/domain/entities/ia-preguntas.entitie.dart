class OpcionesPIA {
  final String a;
  final String b;
  final String c;
  final String d;

  OpcionesPIA({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
  });

  factory OpcionesPIA.fromJson(Map<String, dynamic> json) {
    return OpcionesPIA(
      a: json['a'] as String,
      b: json['b'] as String,
      c: json['c'] as String,
      d: json['d'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'a': a,
        'b': b,
        'c': c,
        'd': d,
      };
}

class IAPregunta {
  final String question;
  final OpcionesPIA options;
  final String correctAnswer;

  IAPregunta({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory IAPregunta.fromJson(Map<String, dynamic> json) {
    return IAPregunta(
      question: json['question'] as String,
      options: OpcionesPIA.fromJson(json['options'] as Map<String, dynamic>),
      correctAnswer: json['correctAnswer'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'question': question,
        'options': options.toJson(),
        'correctAnswer': correctAnswer,
      };
}

class IAPreguntasResponse {
  final List<IAPregunta> questions;

  IAPreguntasResponse({required this.questions});

  factory IAPreguntasResponse.fromJson(Map<String, dynamic> json) {
    var questionsJson = json['questions'] as List;
    List<IAPregunta> questionsList = questionsJson
        .map((questionJson) => IAPregunta.fromJson(questionJson))
        .toList();
    return IAPreguntasResponse(questions: questionsList);
  }

  Map<String, dynamic> toJson() => {
        'questions': questions.map((q) => q.toJson()).toList(),
      };
}

class FlashCard {
  final String question;
  final String answer;

  FlashCard({
    required this.question,
    required this.answer,
  });

  factory FlashCard.fromJson(Map<String, dynamic> json) {
    return FlashCard(
      question: json['question'] as String,
      answer: json['answer'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'question': question,
        'answer': answer,
      };
}

class FlashCardsResponse {
  final List<FlashCard> flashcards;

  FlashCardsResponse({required this.flashcards});

  factory FlashCardsResponse.fromJson(Map<String, dynamic> json) {
    var flashcardsJson = json['questions'] as List;
    List<FlashCard> flashcardsList = flashcardsJson
        .map((flashcardJson) => FlashCard.fromJson(flashcardJson))
        .toList();
    return FlashCardsResponse(flashcards: flashcardsList);
  }

  Map<String, dynamic> toJson() => {
        'flashcards': flashcards.map((f) => f.toJson()).toList(),
      };
}
  // final List<Map<String, dynamic>> datosPreguntas = [
  //   {
  //     'pregunta':
  //         '¿Qué área de la informática se encarga del manejo y almacenamiento eficiente de los datos?',
  //     'respuestas': [
  //       'Inteligencia Artificial',
  //       'Bases de Datos',
  //       'Redes de computadoras',
  //       'Sistemas operativos',
  //     ],
  //     'respuestaCorrecta': 1 // B: Bases de Datos
  //   },
  //   {
  //     'pregunta':
  //         '¿Cuál es el protocolo principal que se utiliza para el envío de correos electrónicos en Internet?',
  //     'respuestas': [
  //       'HTTP',
  //       'FTP',
  //       'SMTP',
  //       'SSH',
  //     ],
  //     'respuestaCorrecta': 2 // C: SMTP
  //   },
  //   {
  //     'pregunta':
  //         '¿Qué componente de hardware es conocido como el "cerebro" de la computadora?',
  //     'respuestas': [
  //       'Memoria RAM',
  //       'Disco Duro',
  //       'Tarjeta Gráfica',
  //       'Procesador (CPU)',
  //     ],
  //     'respuestaCorrecta': 3 // D: Procesador
  //   },
  //   {
  //     'pregunta':
  //         '¿Cuál es el lenguaje de programación más utilizado para el desarrollo web del lado del cliente?',
  //     'respuestas': [
  //       'JavaScript',
  //       'Python',
  //       'Java',
  //       'PHP',
  //     ],
  //     'respuestaCorrecta': 0 // A: JavaScript
  //   },
  //   {
  //     'pregunta':
  //         '¿Qué tipo de ataque informático consiste en suplantar la identidad de una entidad confiable?',
  //     'respuestas': [
  //       'DDoS',
  //       'Phishing',
  //       'Malware',
  //       'Ransomware',
  //     ],
  //     'respuestaCorrecta': 1 // B: Phishing
  //   },
  // ];