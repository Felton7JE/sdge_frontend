import 'package:flutter/material.dart';
import 'package:sgde_fronted/pages/addEquipaments.dart';
import 'package:sgde_fronted/pages/alocacao.dart';
import 'package:sgde_fronted/pages/dashboard.dart';
import 'package:sgde_fronted/pages/manutencao.dart';
import 'package:sgde_fronted/pages/emprestimo.dart';
import 'package:sgde_fronted/pages/avaria.dart';
// Import other screens like avarias, requisicoes if they exist

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SGDE CETIC', // Updated App Title
      theme: ThemeData(
        primarySwatch: Colors.indigo, // Match the blue color used
        primaryColor: const Color(0xFF3F51B5), // Define primary color
        scaffoldBackgroundColor: const Color(0xFFF5F6FA), // Default background
         fontFamily: 'Poppins', // Optional: Define a default font
         // Define consistent text themes if needed
         textTheme: TextTheme(
           bodyMedium: TextStyle(color: Colors.grey[800]),
           // Define other styles like headline6, subtitle1 etc.
         ),
         // Define consistent input decoration theme
         inputDecorationTheme: InputDecorationTheme(
           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
           filled: true,
           fillColor: Colors.white,
           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
           labelStyle: TextStyle(color: Colors.grey[600]),
           focusedBorder: OutlineInputBorder(
             borderSide: const BorderSide(color: Color(0xFF3F51B5), width: 2),
             borderRadius: BorderRadius.circular(8),
           ),
           enabledBorder: OutlineInputBorder(
             borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
             borderRadius: BorderRadius.circular(8),
           ),
           errorBorder: OutlineInputBorder(
             borderSide: const BorderSide(color: Colors.red, width: 1.5),
             borderRadius: BorderRadius.circular(8),
           ),
           focusedErrorBorder: OutlineInputBorder(
             borderSide: const BorderSide(color: Colors.red, width: 2),
             borderRadius: BorderRadius.circular(8),
           ),
         ),
         cardTheme: CardTheme( // Consistent Card Theme
           elevation: 4,
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
           margin: const EdgeInsets.symmetric(vertical: 8.0), // Default margin for cards
         ),
         elevatedButtonTheme: ElevatedButtonThemeData( // Consistent Button Theme
           style: ElevatedButton.styleFrom(
             backgroundColor: const Color(0xFF3F51B5),
             foregroundColor: Colors.white,
             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
             textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(8.0),
             ),
           ),
         ),
         // Define NavigationRail and BottomNavigationBar themes if desired
      ),
      debugShowCheckedModeBanner: false, // Hide debug banner
      initialRoute: '/dashboard', // Keep Dashboard as initial
      routes: {
        '/dashboard': (context) => DashboardScreen(),
        // Use a more descriptive route name for the main equipment screen
        '/adicionar_equipamento': (context) => AdicionarEquipamentoScreen(),
        '/alocacao': (context) => AlocacaoEquipamentoScreen(),
        '/manutencao': (context) => ManutencaoEquipamentoScreen(),
        '/emprestimo': (context) => EmprestimoEquipamentoScreen(),
         '/avaria': (context) => AvariaScreen(),

        // Add routes for other screens
        // '/avarias': (context) => AvariasScreen(),
        // '/requisicoes': (context) => RequisicoesScreen(),
      },
    );
  }
}
