import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatefulWidget {
  const MeuApp({Key? key}) : super(key: key);

  @override
  State<MeuApp> createState() => _MeuAppState();
}

class _MeuAppState extends State<MeuApp> {
  final List<Tarefa> _tarefas = [];
  final TextEditingController _controlador = TextEditingController();
  final TextEditingController _editControlador = TextEditingController();
  late Tarefa? _tarefaSelecionada;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Afazeres'),
          backgroundColor: Colors.indigo,
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _tarefas.length,
                itemBuilder: (context, index) {
                  final tarefa = _tarefas[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: ListTile(
                      title: Text(
                        tarefa.descricao,
                        style: TextStyle(
                          fontSize: 18,
                          color: tarefa.status ? Colors.green : Colors.black,
                          decoration: tarefa.status ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _editarTarefa(context, index);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _excluirTarefa(index);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          tarefa.status = !tarefa.status;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _controlador,
                      decoration: const InputDecoration(
                        hintText: 'Descrição',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black), // Mudança de cor para preto
                      fixedSize: MaterialStateProperty.all(const Size(150, 50)),
                    ),
                    child: const Text(
                      'Adicionar',
                      style: TextStyle(fontSize: 16, color: Colors.white), // Cor do texto
                    ),
                    onPressed: _adicionarTarefa,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _adicionarTarefa() {
    final descricao = _controlador.text;
    if (descricao.isNotEmpty) {
      setState(() {
        _tarefas.add(Tarefa(descricao: descricao, status: false));
        _controlador.clear();
      });
    }
  }

  void _editarTarefa(BuildContext context, int index) {
    _editControlador.text = _tarefas[index].descricao;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Tarefa'),
          content: TextField(
            controller: _editControlador,
            decoration: const InputDecoration(
              hintText: 'Nova Descrição',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _tarefas[index].descricao = _editControlador.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _excluirTarefa(int index) {
    setState(() {
      _tarefas.removeAt(index);
    });
  }
}

class Tarefa {
  String descricao;
  bool status;

  Tarefa({required this.descricao, required this.status});
}
