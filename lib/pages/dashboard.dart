import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isExpanded = false;
  int _selectedIndex = 0;
  int _selectedSubIndex = -1;

  final List<NavigationRailDestination> mainMenuItems = [
    NavigationRailDestination(
        icon: Icon(Icons.dashboard), label: Text("Painel")),
    NavigationRailDestination(
        icon: Icon(Icons.computer), label: Text("Equipamentos")),
    NavigationRailDestination(
        icon: Icon(Icons.build), label: Text("Manutenção")),
    NavigationRailDestination(
        icon: Icon(Icons.warning), label: Text("Avarias")),
    NavigationRailDestination(
        icon: Icon(Icons.request_page), label: Text("Requisições")),
    NavigationRailDestination(
        icon: Icon(Icons.local_shipping), label: Text("Empréstimos")),
  ];

  final Map<int, List<NavigationRailDestination>> subMenuItems = {
    1: [
      NavigationRailDestination(
          icon: Icon(Icons.assignment_turned_in), label: Text("Alocados")),
      NavigationRailDestination(
          icon: Icon(Icons.assignment_late), label: Text("Não Alocados")),
      NavigationRailDestination( // Adiciona o botão de adicionar equipamento
          icon: Icon(Icons.add), label: Text("Adicionar Equipamento")),
    ],
    3: [
      NavigationRailDestination(
          icon: Icon(Icons.report_problem), label: Text("Solicitação")),
      NavigationRailDestination(
          icon: Icon(Icons.dangerous), label: Text("Danificados")),
    ],
  };

  void _navigateToPage(int index) {
    if (index == 1) { // Índice 1 corresponde a "Equipamentos"
      Navigator.pushNamed(context, '/adicionar_equipamento');
    } else if (index >= 0 && index < routes.length) {
      Navigator.pushReplacementNamed(context, routes[index]);
    } else {
      print("Erro: Índice de rota inválido: $index");
    }
  }

  final List<String> routes = [
    '/dashboard',
    '/equipamentos',
    '/alocacao',
    '/avarias',
    '/requisicoes',
    '/emprestimos',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 800;
          return Row(
            children: [
              if (isWideScreen) // Mostra NavigationRail apenas em telas grandes
                NavigationRail(
                  extended: isWideScreen ? isExpanded : false,
                  backgroundColor: Color(0xFF3F51B5),
                  unselectedIconTheme:
                      IconThemeData(color: Colors.white70, opacity: 1),
                  unselectedLabelTextStyle:
                      TextStyle(color: Colors.white70, fontSize: 14),
                  selectedIconTheme: IconThemeData(color: Colors.white),
                  selectedLabelTextStyle:
                      TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  destinations: mainMenuItems,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _selectedIndex = index;
                      _selectedSubIndex = -1;
                    });
                    _navigateToPage(index);
                  },
                  labelType: NavigationRailLabelType.none,
                ),
              if (isWideScreen && subMenuItems.containsKey(_selectedIndex))
                NavigationRail(
                  extended: isWideScreen ? isExpanded : false,
                  backgroundColor: Color(0xFF5C6BC0),
                  unselectedIconTheme:
                      IconThemeData(color: Colors.white70, opacity: 1),
                  unselectedLabelTextStyle:
                      TextStyle(color: Colors.white70, fontSize: 14),
                  selectedIconTheme: IconThemeData(color: Colors.white),
                  selectedLabelTextStyle:
                      TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  destinations: subMenuItems[_selectedIndex]!,
                  selectedIndex: _selectedSubIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _selectedSubIndex = index;
                    });
                    // Navega para a tela de adicionar equipamento quando o item for selecionado
                    if (_selectedIndex == 1 && index == 2) { // Índice 2 é o "Adicionar Equipamento"
                      Navigator.pushNamed(context, '/adicionar_equipamento');
                    }
                  },
                  labelType: NavigationRailLabelType.none,
                ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 48),
                            Text(
                              "Visão Geral do Sistema CETIC",
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800]),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        "https://randomuser.me/api/portraits/men/15.jpg"),
                                    radius: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text("Utilizador",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey[800])),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            _buildSummaryCard2(
                              icon: Icons.computer,
                              title: "Equipamentos Totais",
                              value: "150",
                              color: Colors.blue,
                            ),
                            _buildSummaryCard2(
                              icon: Icons.check_circle,
                              title: "Equipamentos Operacionais",
                              value: "120",
                              color: Colors.green,
                            ),
                            _buildSummaryCard2(
                              icon: Icons.warning,
                              title: "Equipamentos em Manutenção",
                              value: "10",
                              color: Colors.orange,
                            ),
                            _buildSummaryCard2(
                              icon: Icons.error,
                              title: "Equipamentos Avariados",
                              value: "20",
                              color: Colors.red,
                            ),
                          ],
                        ),
                        SizedBox(height: 30.0),
                        // Use Column em telas pequenas, Row em telas grandes
                        constraints.maxWidth > 600
                            ? IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: _buildCard(
                                          title: "Últimas Requisições",
                                          child: _buildRecentTransactionTable()),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: _buildCard(
                                          title: "Atividade Recente",
                                          child: _buildActivityList()),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                children: [
                                  _buildCard(
                                      title: "Últimas Requisições",
                                      child: _buildRecentTransactionTable()),
                                  SizedBox(height: 20),
                                  _buildCard(
                                      title: "Atividade Recente",
                                      child: _buildActivityList()),
                                ],
                              ),
                        SizedBox(height: 30.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: LayoutBuilder(
          builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 600;
        if (!isWideScreen) {
          return BottomNavigationBar(
            items: mainMenuItems
                .map((item) => BottomNavigationBarItem(
                    icon: item.icon, label: (item.label as Text).data!))
                .toList(),
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
                _selectedSubIndex = -1;
              });
              _navigateToPage(index);
            },
          );
        }
        return SizedBox.shrink();
      }),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard2({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      height: 150,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space evenly
        children: [
          Icon(icon, size: 32, color: color),
          Text(title,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500)),
          // Add Flexible and FittedBox to handle the text size.
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(value,
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800])),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionTable() {
    return SizedBox(
      height: 200,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 16,
          horizontalMargin: 0,
          columns: [
            DataColumn(
                label: Text("Data", style: TextStyle(fontWeight: FontWeight.w500))),
            DataColumn(
                label: Text("Equipamento",
                    style: TextStyle(fontWeight: FontWeight.w500))),
            DataColumn(
                label: Text("Estado", style: TextStyle(fontWeight: FontWeight.w500))),
          ],
          rows: [
            _buildTransactionRow(DateTime.now().subtract(Duration(days: 1)),
                "Computador HP", "Requisitado"),
            _buildTransactionRow(DateTime.now().subtract(Duration(days: 3)),
                "Projetor Epson", "Aprovado"),
            _buildTransactionRow(DateTime.now().subtract(Duration(days: 7)),
                "Impressora Canon", "Pendente"),
          ],
        ),
      ),
    );
  }

  DataRow _buildTransactionRow(
      DateTime date, String description, String amount) {
    final formattedDate = DateFormat('MMM d, yyyy').format(date);
    return DataRow(cells: [
      DataCell(Text(formattedDate)),
      DataCell(Text(description)),
      DataCell(Text(amount)),
    ]);
  }

  Widget _buildActivityList() {
    return Column(
      children: [
        _buildActivityItem(
            "Novo equipamento registado", DateTime.now().subtract(Duration(hours: 2))),
        Divider(),
        _buildActivityItem("Manutenção agendada",
            DateTime.now().subtract(Duration(days: 1))),
        Divider(),
        _buildActivityItem("Equipamento requisitado",
            DateTime.now().subtract(Duration(days: 3))),
      ],
    );
  }

  Widget _buildActivityItem(String activity, DateTime time) {
    final formattedTime = DateFormat('h:mm a').format(time);
    return ListTile(
      leading: Icon(Icons.notifications, color: Colors.blue),
      title: Text(activity, style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(formattedTime),
    );
  }
}