import 'dart:collection';
import 'package:flutter/material.dart';

ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _notifier,
      builder: (_, mode, __) {
        return MaterialApp(
          title: "Agenda",
          initialRoute: '/',
          routes: {
            '/': (context) => const Agenda(),
            '/novo': (context) => const Novo(),
            '/recentes': (context) => const Recentes(),
          },
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: mode,
        );
      },
    );
  }
}

class Contato {
  String nome, telefone, email, endereco;

  Contato(this.nome, this.telefone, this.email, this.endereco);
}

var contatos = <Contato>[];
SplayTreeSet<Contato> contatosOrdenado = SplayTreeSet.from(
  contatos,
  (a, b) => a.nome.compareTo(b.nome),
);

class Agenda extends StatelessWidget {
  const Agenda({super.key});

  @override
  Widget build(BuildContext context) {
    final rows = <TableRow>[];
    rows.add(
      const TableRow(
        children: <Widget>[
          Text(
            "NOME:",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            "TELEFONE:",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            "EMAIL:",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            "ENDEREÇO:",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            "REMOVER:",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
    for (var contato in contatosOrdenado) {
      rows.add(TableRow(
        children: <Widget>[
          Text(
            contato.nome,
            textAlign: TextAlign.center,
          ),
          Text(
            contato.telefone,
            textAlign: TextAlign.center,
          ),
          Text(
            contato.email,
            textAlign: TextAlign.center,
          ),
          Text(
            contato.endereco,
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              contatos.removeWhere((c) =>
                  c.nome == contato.nome &&
                  c.telefone == contato.telefone &&
                  c.email == contato.email &&
                  c.endereco == contato.endereco);
              contatosOrdenado = SplayTreeSet.from(
                contatos,
                (a, b) => a.nome.compareTo(b.nome),
              );
              showAlertDialog(context);
            },
            child: const Text("X"),
          ),
        ],
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda de Contatos'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Contatos'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            ListTile(
              title: const Text('Recentes'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/recentes');
              },
            ),
            ListTile(
              title: const Text('+ Novo Contato'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/novo');
              },
            ),
            ListTile(
              title: const Text('Mudar Tema'),
              onTap: () {
                if (_notifier.value == ThemeMode.light) {
                  _notifier.value = ThemeMode.dark;
                } else {
                  _notifier.value = ThemeMode.light;
                }
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Table(
          children: rows,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/novo');
        },
        tooltip: 'Adicionar Novo Contato',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();
  final emailController = TextEditingController();
  final enderecoController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    telefoneController.dispose();
    emailController.dispose();
    enderecoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: nomeController,
            decoration: const InputDecoration(hintText: "Nome"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o nome';
              }
              return null;
            },
          ),
          TextFormField(
            controller: telefoneController,
            decoration: const InputDecoration(hintText: "Telefone"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o telefone';
              }
              return null;
            },
          ),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(hintText: "Email"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o email';
              }
              return null;
            },
          ),
          TextFormField(
            controller: enderecoController,
            decoration: const InputDecoration(hintText: "Endereço"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira o endereço';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                contatos.add(Contato(
                  nomeController.text,
                  telefoneController.text,
                  emailController.text,
                  enderecoController.text,
                ));
                contatosOrdenado = SplayTreeSet.from(
                  contatos,
                  (a, b) => a.nome.compareTo(b.nome),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Contato Adicionado')),
                );

                Navigator.popAndPushNamed(context, '/recentes');
              }
            },
            child: const Text('Adicionar'),
          ),
          const SizedBox(height: 20),
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}

class Novo extends StatelessWidget {
  const Novo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Contato'),
      ),
      body: const MyCustomForm(),
    );
  }
}

class Recentes extends StatelessWidget {
  const Recentes({super.key});

  @override
  Widget build(BuildContext context) {
    final rows = <TableRow>[];
    rows.add(
      const TableRow(
        children: <Widget>[
          Text(
            "NOME:",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            "TELEFONE:",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            "EMAIL:",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            "ENDEREÇO:",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );

    // Mostra apenas os últimos 5 contatos adicionados
    var recentContacts = contatos.length > 5 
        ? contatos.sublist(contatos.length - 5)
        : contatos;

    for (var contato in recentContacts.reversed) {
      rows.add(TableRow(
        children: <Widget>[
          Text(
            contato.nome,
            textAlign: TextAlign.center,
          ),
          Text(
            contato.telefone,
            textAlign: TextAlign.center,
          ),
          Text(
            contato.email,
            textAlign: TextAlign.center,
          ),
          Text(
            contato.endereco,
            textAlign: TextAlign.center,
          ),
        ],
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contatos Recentes'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Contatos'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            ListTile(
              title: const Text('Recentes'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/recentes');
              },
            ),
            ListTile(
              title: const Text('+ Novo Contato'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/novo');
              },
            ),
            ListTile(
              title: const Text('Mudar Tema'),
              onTap: () {
                if (_notifier.value == ThemeMode.light) {
                  _notifier.value = ThemeMode.dark;
                } else {
                  _notifier.value = ThemeMode.light;
                }
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Table(
          children: rows,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/novo');
        },
        tooltip: 'Adicionar Novo Contato',
        child: const Icon(Icons.add),
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    title: const Text("Sucesso"),
    content: const Text("Contato removido com sucesso."),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}