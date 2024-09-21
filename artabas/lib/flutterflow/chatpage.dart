import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatPage(token: 'm6z6gqn2', systemPrompt: ''),
    );
  }
}

class ChatPage extends StatefulWidget {
  final String token;
  final String systemPrompt;

  const ChatPage({super.key, required this.token, required this.systemPrompt});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  late String _welcomeMessage;

final List<String> _welcomeMessages = [
  'Bem-vindo ao chat! Estou aqui para ajudar.',
  'Olá! Estou pronto para ajudar com o que precisar.',
  'Oi! Sinta-se à vontade para fazer perguntas.',
  'Bem-vindo! Como posso ajudal-lo hoje?',
  'Olá! Estou aqui para ajudar com suas dúvidas.',
  'Oi! Se precisar de ajuda, é só falar.',
  'Bem-vindo ao nosso chat! Em que posso ajudar?',
  'Olá! Estou disponível para qualquer pergunta que você tenha.',
  'Oi! Fique à vontade para me perguntar qualquer coisa.',
  'Bem-vindo! Como posso ajudar?'
];


  @override
  void initState() {
    super.initState();
    _welcomeMessage = _welcomeMessages[DateTime.now().second % _welcomeMessages.length];
    _messages.add({'type': 'info', 'message': _welcomeMessage});
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final userMessage = _controller.text;
      setState(() {
        _messages.add({'type': 'user', 'message': userMessage});
        _controller.clear();
        _isLoading = true; // Start loading
      });

      bool success = false;
      while (!success) {
        try {
          final response = await http.post(
            Uri.parse('https://f3h7okfj57.execute-api.us-east-1.amazonaws.com/dev/analyze'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${widget.token}',
            },
            body: jsonEncode({
              'content': '${widget.systemPrompt}\nUsuário: $userMessage'
            }),
          );

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            setState(() {
              _messages.add({'type': 'bot', 'message': data['response']});
              success = true; // Exit the loop if request succeeds
            });
          } else {
            setState(() {
              _messages.add({'type': 'error', 'message': 'Instabilidade na rede. Tentando novamente...'});
            });
          }
        } catch (e) {
          setState(() {
            _messages.add({'type': 'error', 'message': 'Instabilidade na rede. Tentando novamente...'});
          });
        }

        // Delay before retrying
        await Future.delayed(const Duration(seconds: 2));
      }

      setState(() {
        _isLoading = false; // End loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.white, // Set background color to white
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final isUser = message['type'] == 'user';
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          if (!isUser)
                            const CircleAvatar(
                              backgroundImage: AssetImage('assets/images/OIG4.Ptkzg.jpeg'),
                              radius: 30.0, // Increase radius to double the default size
                            ),
                          const SizedBox(width: 8.0),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: isUser ? Colors.red : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: const Color.fromARGB(0, 255, 255, 255)),
                              ),
                              child: Text(
                                message['message']!,
                                style: TextStyle(
                                  color: isUser ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          if (isUser)
                            const CircleAvatar(
                              backgroundImage: AssetImage('assets/images/image_3-sem fundo.png'),
                              radius: 30.0, // Increase radius to double the default size
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Digite sua mensagem...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      onPressed: _sendMessage, // Set icon color to white
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.red, // Button color
                        padding: const EdgeInsets.all(12.0),
                      ),
                      child: Icon(Icons.send, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
