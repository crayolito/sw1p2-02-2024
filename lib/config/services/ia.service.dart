import 'package:dio/dio.dart';

class OpenIAService {
  final Dio _dio;
  static const String baseUrl = 'https://api.openai.com/v1';
  static const String apiKey = '';

  OpenIAService() : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('Enviando request a ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('Respuesta recibida de ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('Error en la request: ${e.message}');
        return handler.next(e);
      },
    ));
  }

  Future<String> generateQuestions(String pdfText) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': '''
              Eres un profesor experto que genera preguntas de examen basadas ÚNICAMENTE en el contenido temático de programas analíticos.

              INSTRUCCIONES PRIMARIAS:
              1. IGNORA COMPLETAMENTE las secciones de objetivos, justificaciones, metodología y evaluación
              2. CÉNTRATE SOLO en la sección de contenidos/temas del programa
              3. Genera 10 preguntas que evalúen el dominio de estos temas específicos

              PROCESO DE GENERACIÓN:
              1. Identifica la lista de temas/contenidos del programa
              2. Para cada tema, genera preguntas que evalúen:
                 - Comprensión del tema
                 - Aplicación práctica
                 - Resolución de problemas
                 - Análisis de casos

              TIPOS DE PREGUNTAS PERMITIDAS:
              ✅ "Dado el tema X, resuelve..."
              ✅ "Al aplicar el concepto X en la siguiente situación..."
              ✅ "Analiza el siguiente caso usando el tema X..."
              ✅ "Calcula/Determina/Identifica usando el concepto X..."

              TIPOS DE PREGUNTAS PROHIBIDAS:
              ❌ "¿Cuál es el objetivo de...?"
              ❌ "¿Por qué es importante...?"
              ❌ "¿Qué competencias desarrolla...?"
              ❌ "¿Cómo se evalúa...?"

              ESTRUCTURA DE CADA PREGUNTA:
              1. Menciona el tema específico del contenido
              2. Plantea una situación o problema concreto
              3. Solicita una respuesta específica
              4. Proporciona opciones técnicamente válidas
              
              IMPORTANTE:
              - Las preguntas deben evaluar EXCLUSIVAMENTE los temas listados en el contenido
              - NO preguntes sobre la importancia o utilidad de los temas
              - NO preguntes sobre metodología o evaluación
              - EVITA preguntas sobre objetivos o justificaciones
              - CÉNTRATE en el dominio del contenido

              FORMATO JSON REQUERIDO:
              {
                "questions": [
                  {
                    "question": "Escenario concreto seguido de pregunta práctica",
                    "options": {
                      "a": "Opción plausible",
                      "b": "Opción plausible",
                      "c": "Opción plausible",
                      "d": "Opción plausible"
                    },
                    "correctAnswer": "letra_aleatoria"
                  }
                ]
              }
              '''
            },
            {
              'role': 'user',
              'content': pdfText,
            }
          ],
          'temperature': 0.8,
        },
      );

      if (response.statusCode == 200) {
        final content = response.data['choices'][0]['message']['content'];
        return content;
      }

      throw Exception('Error al generar preguntas: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error al generar preguntas: $e');
    }
  }

  Future<String> generateFlashcards(String text) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': '''
            Eres un profesor experto especializado en crear flashcards educativas de alto impacto.

            INSTRUCCIONES PRIMARIAS:
            1. Analiza el texto proporcionado e identifica los conceptos clave
            2. Genera 10 flashcards con preguntas y respuestas que evalúen el dominio real de estos conceptos
            3. Enfócate en la aplicación práctica y comprensión profunda

            TIPOS DE PREGUNTAS A GENERAR:
            ✅ Análisis de casos prácticos
            ✅ Resolución de problemas reales
            ✅ Aplicación de conceptos en situaciones cotidianas
            ✅ Comparaciones y relaciones entre conceptos
            ✅ Escenarios de toma de decisiones
            
            TIPOS DE PREGUNTAS PROHIBIDAS:
            ❌ Definiciones directas ("¿Qué es...?")
            ❌ Preguntas de memoria pura
            ❌ Conceptos aislados sin contexto
            ❌ Teoría sin aplicación práctica
            ❌ Preguntas genéricas o ambiguas

            ESTRUCTURA DE CADA FLASHCARD:
            1. PREGUNTA:
               - Debe presentar un contexto o escenario específico
               - Debe requerir análisis o aplicación del conocimiento
               - Debe ser clara y directa
               - Debe tener un nivel de complejidad moderado
            
            2. RESPUESTA:
               - Debe explicar el razonamiento completo
               - Debe conectar la teoría con la práctica
               - Debe ser concisa pero informativa
               - Debe reforzar el concepto clave

            CARACTERÍSTICAS ESENCIALES:
            - Nivel: Apropiado para estudiantes de secundaria/universidad
            - Complejidad: Moderada (desafiante pero alcanzable)
            - Enfoque: Práctico y aplicado
            - Extensión: Preguntas y respuestas concisas pero completas

            FORMATO DE LAS PREGUNTAS:
            ✅ "En una situación donde [contexto], ¿cómo aplicarías [concepto]?"
            ✅ "Analiza el siguiente caso: [escenario] usando [concepto]"
            ✅ "Compara y contrasta [elemento A] con [elemento B] en términos de [concepto]"
            ✅ "Dado [escenario], determina [resultado] aplicando [concepto]"
            ✅ "¿Qué solución propones para [problema] considerando [concepto]?"

            RETORNA ESTRICTAMENTE EN ESTE FORMATO JSON:
            {
              "questions": [
                {
                  "question": "Pregunta basada en contexto real",
                  "answer": "Respuesta que explica el razonamiento"
                }
              ]
            }
            '''
            },
            {
              'role': 'user',
              'content': text,
            }
          ],
          'temperature': 0.7,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data['choices'][0]['message']['content'];
        return data;
      }

      throw Exception('Error al generar flashcards: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error al generar flashcards: $e');
    }
  }
}
