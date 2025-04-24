import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isExpanded = false;
  int _selectedIndex = 0;
  int _selectedSubIndex = -1;

  // Lista de itens do menu principal
  final List<NavigationRailDestination> mainMenuItems = [
    NavigationRailDestination(
      icon: Icon(Icons.dashboard),
      label: Text("Dashboard"),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.computer),
      label: Text("Equipamentos"),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.build),
      label: Text("Manutenção"),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.warning),
      label: Text("Avarias"),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.request_page),
      label: Text("Requisições"),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.local_shipping),
      label: Text("Empréstimos"),
    ),
  ];

  // Lista de subitens para cada item principal
  final Map<int, List<NavigationRailDestination>> subMenuItems = {
    1: [
      NavigationRailDestination(
        icon: Icon(Icons.assignment_turned_in),
        label: Text("Alocados"),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.assignment_late),
        label: Text("Não Alocados"),
      ),
    ],
    3: [
      NavigationRailDestination(
        icon: Icon(Icons.report_problem),
        label: Text("Solicitação"),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.dangerous),
        label: Text("Danificados"),
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Navigation Rail com suporte a subitens
          NavigationRail(
            extended: isExpanded,
            backgroundColor: Colors.deepPurple.shade400,
            unselectedIconTheme: IconThemeData(color: Colors.white, opacity: 1),
            unselectedLabelTextStyle: TextStyle(color: Colors.white),
            selectedIconTheme: IconThemeData(color: Colors.deepPurple.shade900),
            destinations: mainMenuItems,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
                _selectedSubIndex = -1; // Reset subitem selection
              });
            },
          ),
          
          // Submenu quando aplicável
          if (subMenuItems.containsKey(_selectedIndex))
            NavigationRail(
              extended: isExpanded,
              backgroundColor: Colors.deepPurple.shade300,
              unselectedIconTheme: IconThemeData(color: Colors.white, opacity: 1),
              unselectedLabelTextStyle: TextStyle(color: Colors.white),
              selectedIconTheme: IconThemeData(color: Colors.deepPurple.shade900),
              destinations: subMenuItems[_selectedIndex]!,
              selectedIndex: _selectedSubIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedSubIndex = index;
                });
              },
            ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cabeçalho com menu e avatar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          icon: Icon(Icons.menu),
                        ),
                        Text(
                          "Gestão de Equipamentos",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://faces-img.xcdn.link/image-lorem-face-3430.jpg"),
                          radius: 26.0,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    
                    // Cards de resumo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSummaryCard(
                          icon: Icons.computer,
                          title: "Equipamentos",
                          value: "128",
                          color: Colors.blue,
                        ),
                        _buildSummaryCard(
                          icon: Icons.assignment_turned_in,
                          title: "Alocados",
                          value: "85",
                          color: Colors.green,
                        ),
                        _buildSummaryCard(
                          icon: Icons.assignment_late,
                          title: "Disponíveis",
                          value: "43",
                          color: Colors.orange,
                        ),
                        _buildSummaryCard(
                          icon: Icons.warning,
                          title: "Em Manutenção",
                          value: "12",
                          color: Colors.red,
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 30.0),
                    
                    // Gráficos ou listas recentes
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Últimos Empréstimos",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  _buildRecentLoansTable(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Manutenções Recentes",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  _buildMaintenanceList(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 30.0),
                    
                    // Equipamentos com problemas
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Equipamentos com Problemas",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            _buildProblemEquipmentTable(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ação depende do contexto atual
          if (_selectedIndex == 1) {
            // Adicionar novo equipamento
          } else if (_selectedIndex == 3 && _selectedSubIndex == 0) {
            // Reportar nova avaria
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple.shade400,
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Flexible(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 26.0, color: color),
                  SizedBox(width: 15.0),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                value,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentLoansTable() {
    return DataTable(
      columns: [
        DataColumn(label: Text("Equipamento")),
        DataColumn(label: Text("Responsável")),
        DataColumn(label: Text("Data")),
        DataColumn(label: Text("Status")),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text("Notebook Dell")),
          DataCell(Text("João Silva")),
          DataCell(Text("10/05/2023")),
          DataCell(
            Chip(
              label: Text("Ativo"),
              backgroundColor: Colors.green.shade100,
            ),
          ),
        ]),
        DataRow(cells: [
          DataCell(Text("Projetor Epson")),
          DataCell(Text("Maria Souza")),
          DataCell(Text("08/05/2023")),
          DataCell(
            Chip(
              label: Text("Devolvido"),
              backgroundColor: Colors.blue.shade100,
            ),
          ),
        ]),
        DataRow(cells: [
          DataCell(Text("Tablet Samsung")),
          DataCell(Text("Carlos Oliveira")),
          DataCell(Text("05/05/2023")),
          DataCell(
            Chip(
              label: Text("Atrasado"),
              backgroundColor: Colors.orange.shade100,
            ),
          ),
        ]),
      ],
    );
  }

  Widget _buildMaintenanceList() {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.build, color: Colors.orange),
          title: Text("Notebook HP - Teclado"),
          subtitle: Text("Em andamento • Início: 05/05/2023"),
          trailing: Chip(
            label: Text("Prioridade: Alta"),
            backgroundColor: Colors.red.shade100,
          ),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.build, color: Colors.blue),
          title: Text("Projetor BenQ - Lâmpada"),
          subtitle: Text("Concluído • Término: 03/05/2023"),
          trailing: Icon(Icons.check_circle, color: Colors.green),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.build, color: Colors.orange),
          title: Text("Desktop Dell - Placa-mãe"),
          subtitle: Text("Aguardando peças • Início: 01/05/2023"),
          trailing: Chip(
            label: Text("Prioridade: Média"),
            backgroundColor: Colors.amber.shade100,
          ),
        ),
      ],
    );
  }

  Widget _buildProblemEquipmentTable() {
    return DataTable(
      columns: [
        DataColumn(label: Text("ID")),
        DataColumn(label: Text("Equipamento")),
        DataColumn(label: Text("Problema")),
        DataColumn(label: Text("Status")),
        DataColumn(label: Text("Ações")),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text("EQ-102")),
          DataCell(Text("Notebook Lenovo")),
          DataCell(Text("Tela quebrada")),
          DataCell(
            Chip(
              label: Text("Aguardando análise"),
              backgroundColor: Colors.orange.shade100,
            ),
          ),
          DataCell(
            IconButton(
              icon: Icon(Icons.visibility, color: Colors.blue),
              onPressed: () {},
            ),
          ),
        ]),
        DataRow(cells: [
          DataCell(Text("EQ-045")),
          DataCell(Text("Projetor Sony")),
          DataCell(Text("Superaquecimento")),
          DataCell(
            Chip(
              label: Text("Em manutenção"),
              backgroundColor: Colors.red.shade100,
            ),
          ),
          DataCell(
            IconButton(
              icon: Icon(Icons.visibility, color: Colors.blue),
              onPressed: () {},
            ),
          ),
        ]),
        DataRow(cells: [
          DataCell(Text("EQ-078")),
          DataCell(Text("Tablet Samsung")),
          DataCell(Text("Bateria não carrega")),
          DataCell(
            Chip(
              label: Text("Reparo aprovado"),
              backgroundColor: Colors.blue.shade100,
            ),
          ),
          DataCell(
            IconButton(
              icon: Icon(Icons.visibility, color: Colors.blue),
              onPressed: () {},
            ),
          ),
        ]),
      ],
    );
  }
}