import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'splash_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Downloader Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1C1B2F),
        primaryColor: const Color(0xFF7C4DFF),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF7C4DFF),
          secondary: Color(0xFF00B0FF),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7C4DFF),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _urlController = TextEditingController();
  String _formato = 'mp3';
  String _mensagem = '';
  String? _linkDownload;
  bool _carregando = false;

  Future<void> _baixarArquivo() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;

    setState(() {
      _carregando = true;
      _mensagem = '';
      _linkDownload = null;
    });

    final uri = Uri.parse("http://10.0.2.2:8000/download/");
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'url': url, 'formato': _formato}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _mensagem = data['mensagem'];
        _linkDownload = "http://10.0.2.2:8000${data['link_download']}";
      });
    } else {
      setState(() {
        _mensagem = 'Erro ao processar: ${response.body}';
        _linkDownload = null;
      });
    }

    setState(() => _carregando = false);
  }

  Future<void> _abrirArquivo() async {
    if (_linkDownload == null) return;

    setState(() => _carregando = true);
    final response = await http.get(Uri.parse(_linkDownload!));
    final bytes = response.bodyBytes;

    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/${_linkDownload!.split("/").last}';
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    await OpenFile.open(filePath);
    setState(() => _carregando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1C1B2F), Color(0xFF311B92)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset("assets/images/icon.png", height: 36),
                    const SizedBox(width: 12),
                    Text(
                      "Multi Downloader Mobile",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  "Cole a URL do vídeo ou áudio",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _urlController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "https://...",
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.link, color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white10,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _formato,
                  dropdownColor: const Color(0xFF2C2B3E),
                  items: const [
                    DropdownMenuItem(value: 'mp3', child: Text("Áudio (.mp3)")),
                    DropdownMenuItem(value: 'mp4', child: Text("Vídeo (.mp4)")),
                  ],
                  onChanged: (value) => setState(() => _formato = value ?? 'mp3'),
                  decoration: InputDecoration(
                    labelText: "Formato",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white10,
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),
                AnimatedScale(
                  scale: _carregando ? 0.95 : 1,
                  duration: const Duration(milliseconds: 200),
                  child: ElevatedButton.icon(
                    onPressed: _carregando ? null : _baixarArquivo,
                    icon: const Icon(Icons.download),
                    label: const Text("Baixar"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_carregando) ...[
                  const LinearProgressIndicator(color: Colors.deepPurpleAccent),
                  const SizedBox(height: 16),
                ],
                Text(
                  _mensagem,
                  style: TextStyle(
                    color: _mensagem.contains("sucesso") ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                if (_linkDownload != null && !_carregando)
                  AnimatedOpacity(
                    opacity: 1,
                    duration: const Duration(milliseconds: 300),
                    child: ElevatedButton.icon(
                      onPressed: _abrirArquivo,
                      icon: const Icon(Icons.play_circle),
                      label: const Text("Abrir arquivo"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
