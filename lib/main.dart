//widgets novos: DropdownButtonFormField, SingleChildScrollView, Card, divider, circleavatar

import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomeCurriculo(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 62, 168, 143),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 62, 168, 143),
        ),
      ),
    ),
  );
}

// Classe para representar cada projeto individualmente
class Projeto {
  String titulo;
  String descricao;
  Projeto({required this.titulo, required this.descricao});
}

// Modelo de Dados Geral
class DadosCurriculo {
  String nome;
  String avatarUrl;
  List<String> escolaridades; // Agora é uma lista
  List<Projeto> listaProjetos;
  List<String> recomendacoes; // Agora é uma lista

  DadosCurriculo({
    this.nome = "João Vitor Pramio",
    this.avatarUrl =
        "https://assets.nuuvem.com/image/upload/t_screenshot_full/v1/products/570bab1cf3728033c70005b7/screenshots/an47ohqoftp5shgo3ykw.jpg",
    required this.escolaridades,
    required this.listaProjetos,
    required this.recomendacoes,
  });
}

// ==========================================
// TELA PRINCIPAL (HOME)
// ==========================================
class HomeCurriculo extends StatefulWidget {
  @override
  State<HomeCurriculo> createState() => _HomeCurriculoState();
}

class _HomeCurriculoState extends State<HomeCurriculo> {
  late DadosCurriculo meuCurriculo;

  @override
  void initState() {
    super.initState();
    // Dados iniciais padrão
    meuCurriculo = DadosCurriculo(
      escolaridades: ["Ensino Médio"],
      listaProjetos: [
        Projeto(titulo: "Pishield", descricao: "Análise e segurança de Redes"),
      ],
      recomendacoes: ["Recomendado por Flávio Manfrin"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Meu Currículo",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 62, 168, 143),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note, color: Colors.white, size: 30),
            onPressed: () async {
              final resultado = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditarCurriculo(curriculo: meuCurriculo),
                ),
              );
              if (resultado != null) setState(() => meuCurriculo = resultado);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 75,
              backgroundColor: Colors.grey[200],
              backgroundImage: NetworkImage(meuCurriculo.avatarUrl),
            ),
            const SizedBox(height: 20),
            Text(
              meuCurriculo.nome,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 50, thickness: 1.5),

            // SESSÃO DE ESCOLARIDADES
            _tituloSessao("ESCOLARIDADE"),
            ...meuCurriculo.escolaridades
                .map((esc) => _cardSimples("Escolaridade", esc, Icons.school))
                .toList(),

            const SizedBox(height: 10),

            // SESSÃO DE PROJETOS
            _tituloSessao("PROJETOS"),
            ...meuCurriculo.listaProjetos
                .map((proj) => _cardProjeto(proj))
                .toList(),

            const SizedBox(height: 10),

            // SESSÃO DE RECOMENDAÇÕES
            _tituloSessao("RECOMENDAÇÕES"),
            ...meuCurriculo.recomendacoes
                .map((rec) => _cardSimples("Recomendação", rec, Icons.comment))
                .toList(),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para os títulos das sessões
  Widget _tituloSessao(String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        texto,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.teal,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _cardSimples(String titulo, String conteudo, IconData icone) {
    return _baseCard(
      titulo: titulo,
      conteudo: conteudo,
      icone: icone,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TelaDetalhes(titulo: titulo, texto: conteudo),
        ),
      ),
    );
  }

  Widget _cardProjeto(Projeto proj) {
    return _baseCard(
      titulo: proj.titulo,
      conteudo: proj.descricao,
      icone: Icons.rocket_launch,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TelaDetalhes(
            titulo: "Projeto",
            texto: proj.titulo,
            descricaoExtra: proj.descricao,
          ),
        ),
      ),
    );
  }

  Widget _baseCard({
    required String titulo,
    required String conteudo,
    required IconData icone,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.teal.withOpacity(0.2)),
      ),
      color: Colors.teal.withOpacity(0.05),
      child: ListTile(
        leading: Icon(icone, color: Colors.teal),
        title: Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 45, 120, 100),
          ),
        ),
        subtitle: Text(conteudo, maxLines: 1, overflow: TextOverflow.ellipsis),
        onTap: onTap,
      ),
    );
  }
}

// ==========================================
// TELA DE EDIÇÃO (DINÂMICA)
// ==========================================
class EditarCurriculo extends StatefulWidget {
  final DadosCurriculo curriculo;
  EditarCurriculo({required this.curriculo});

  @override
  State<EditarCurriculo> createState() => _EditarCurriculoState();
}

class _EditarCurriculoState extends State<EditarCurriculo> {
  late TextEditingController nomeCtrl;
  late TextEditingController urlCtrl;

  // Listas dinâmicas
  List<String> escolaridades = [];
  List<Map<String, TextEditingController>> projetoControllers = [];
  List<TextEditingController> recControllers = [];

  @override
  void initState() {
    super.initState();
    nomeCtrl = TextEditingController(text: widget.curriculo.nome);
    urlCtrl = TextEditingController(text: widget.curriculo.avatarUrl);

    // Carregar escolaridades
    escolaridades = List.from(widget.curriculo.escolaridades);

    // Carregar projetos
    for (var proj in widget.curriculo.listaProjetos) {
      _adicionarControllersProjeto(titulo: proj.titulo, desc: proj.descricao);
    }

    // Carregar recomendações
    for (var rec in widget.curriculo.recomendacoes) {
      _adicionarRecomendacao(texto: rec);
    }
  }

  // --- LÓGICA ESCOLARIDADE ---
  void _adicionarEscolaridade() {
    setState(() => escolaridades.add('Ensino Médio'));
  }

  void _removerEscolaridade(int index) {
    setState(() => escolaridades.removeAt(index));
  }

  // --- LÓGICA PROJETOS ---
  void _adicionarControllersProjeto({String titulo = "", String desc = ""}) {
    setState(() {
      projetoControllers.add({
        "titulo": TextEditingController(text: titulo),
        "desc": TextEditingController(text: desc),
      });
    });
  }

  void _removerProjeto(int index) {
    setState(() => projetoControllers.removeAt(index));
  }

  // --- LÓGICA RECOMENDAÇÕES ---
  void _adicionarRecomendacao({String texto = ""}) {
    setState(() {
      recControllers.add(TextEditingController(text: texto));
    });
  }

  void _removerRecomendacao(int index) {
    setState(() => recControllers.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Currículo")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _campoInput(nomeCtrl, "Nome Completo", Icons.person),
          _campoInput(urlCtrl, "URL da Foto", Icons.link),

          // ==============================
          // BLOCO ESCOLARIDADES
          // ==============================
          _tituloSessaoEdit("Escolaridades"),
          ...escolaridades.asMap().entries.map((entry) {
            int idx = entry.key;
            return _containerDinamico(
              titulo: "Escolaridade #${idx + 1}",
              onDelete: () => _removerEscolaridade(idx),
              conteudo: DropdownButtonFormField<String>(
                value: escolaridades[idx],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.school),
                ),
                items:
                    [
                          'Ensino Médio',
                          'Ensino Técnico',
                          'Graduação',
                          'Pós-Graduação',
                        ]
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                onChanged: (val) => setState(() => escolaridades[idx] = val!),
              ),
            );
          }).toList(),
          TextButton.icon(
            onPressed: _adicionarEscolaridade,
            icon: const Icon(Icons.add),
            label: const Text("ADICIONAR ESCOLARIDADE"),
          ),

          // ==============================
          // BLOCO PROJETOS
          // ==============================
          _tituloSessaoEdit("Projetos"),
          ...projetoControllers.asMap().entries.map((entry) {
            int idx = entry.key;
            var controllers = entry.value;
            return _containerDinamico(
              titulo: "Projeto #${idx + 1}",
              onDelete: () => _removerProjeto(idx),
              conteudo: Column(
                children: [
                  _campoInput(
                    controllers["titulo"]!,
                    "Título do Projeto",
                    Icons.title,
                  ),
                  _campoInput(
                    controllers["desc"]!,
                    "Descrição",
                    Icons.description,
                    max: 3,
                  ),
                ],
              ),
            );
          }).toList(),
          TextButton.icon(
            onPressed: () => _adicionarControllersProjeto(),
            icon: const Icon(Icons.add),
            label: const Text("ADICIONAR PROJETO"),
          ),

          // ==============================
          // BLOCO RECOMENDAÇÕES
          // ==============================
          _tituloSessaoEdit("Recomendações"),
          ...recControllers.asMap().entries.map((entry) {
            int idx = entry.key;
            return _containerDinamico(
              titulo: "Recomendação #${idx + 1}",
              onDelete: () => _removerRecomendacao(idx),
              conteudo: _campoInput(
                entry.value,
                "Recomendação",
                Icons.comment,
                max: 2,
              ),
            );
          }).toList(),
          TextButton.icon(
            onPressed: () => _adicionarRecomendacao(),
            icon: const Icon(Icons.add),
            label: const Text("ADICIONAR RECOMENDAÇÃO"),
          ),

          const Divider(height: 40),

          // BOTÃO SALVAR
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.all(15),
            ),
            onPressed: () {
              // Monta a lista final de projetos
              List<Projeto> novosProjetos = projetoControllers
                  .map(
                    (c) => Projeto(
                      titulo: c["titulo"]!.text,
                      descricao: c["desc"]!.text,
                    ),
                  )
                  .toList();

              // Monta a lista final de recomendações
              List<String> novasRecs = recControllers
                  .map((c) => c.text)
                  .toList();

              Navigator.pop(
                context,
                DadosCurriculo(
                  nome: nomeCtrl.text,
                  avatarUrl: urlCtrl.text,
                  escolaridades: escolaridades,
                  listaProjetos: novosProjetos,
                  recomendacoes: novasRecs,
                ),
              );
            },
            child: const Text(
              "SALVAR TUDO",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS AUXILIARES PARA A TELA DE EDIÇÃO ---
  Widget _tituloSessaoEdit(String texto) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }

  Widget _containerDinamico({
    required String titulo,
    required VoidCallback onDelete,
    required Widget conteudo,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              ),
            ],
          ),
          conteudo,
        ],
      ),
    );
  }

  Widget _campoInput(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    int max = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: ctrl,
        maxLines: max,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

// ==========================================
// TELA DE DETALHES (DESTAQUE PARA TÍTULO E DESCRIÇÃO)
// ==========================================
class TelaDetalhes extends StatelessWidget {
  final String titulo;
  final String texto;
  final String? descricaoExtra;

  const TelaDetalhes({
    required this.titulo,
    required this.texto,
    this.descricaoExtra,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titulo), backgroundColor: Colors.teal),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Icon(
                descricaoExtra != null ? Icons.rocket_launch : Icons.info,
                size: 80,
                color: Colors.teal,
              ),
              const SizedBox(height: 20),
              Text(
                texto,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
                textAlign: TextAlign.center,
              ),
              const Divider(height: 40, thickness: 1),
              Text(
                descricaoExtra ?? texto,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
