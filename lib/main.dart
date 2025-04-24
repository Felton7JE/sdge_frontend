import 'package:flutter/material.dart';
import 'package:sgde_fronted/pages/addEquipaments.dart';
import 'package:sgde_fronted/pages/dashboard.dart'; // Importe a tela de Adicionar Equipamento

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seu App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/dashboard', // Defina a tela inicial como o Dashboard
      routes: {
        '/dashboard': (context) => DashboardScreen(),
        '/adicionar_equipamento': (context) => AdicionarEquipamentoScreen(),
        // Adicione outras rotas aqui, se necessário
      },
    );
  }
}