import 'package:flutter/material.dart';
import 'package:sgde_fronted/pages/dashboard.dart';
import 'package:sgde_fronted/pages/emprestimo.dart';
import 'package:sgde_fronted/pages/gerenciarEquipamento.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoansScreen(),
    );
  }
}