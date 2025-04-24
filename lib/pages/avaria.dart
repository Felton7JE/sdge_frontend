import 'package:flutter/material.dart';

class FaultsScreen extends StatelessWidget {
  const FaultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Gestão de Avarias'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Solicitações', icon: Icon(Icons.report_problem)),
              Tab(text: 'Danificados', icon: Icon(Icons.dangerous)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FaultRequestsTab(),
            DamagedEquipmentTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddFaultDialog(context),
          child: Icon(Icons.add),
          backgroundColor: Colors.deepPurple.shade400,
        ),
      ),
    );
  }

  void _showAddFaultDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reportar Nova Avaria'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Formulário para reportar avaria
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Equipamento',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Descrição do Problema',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  items: ['Crítico', 'Urgente', 'Normal']
                      .map((priority) => DropdownMenuItem(
                            value: priority,
                            child: Text(priority),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    labelText: 'Prioridade',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Salvar avaria
                Navigator.pop(context);
              },
              child: Text('Reportar'),
            ),
          ],
        );
      },
    );
  }
}

class FaultRequestsTab extends StatelessWidget {
  final List<Map<String, dynamic>> _faultRequests = [
    {
      'id': 'FR-001',
      'equipment': 'Notebook Lenovo (EQ-005)',
      'reportedBy': 'Carlos Oliveira',
      'date': '2023-05-08',
      'description': 'Tela não liga',
      'priority': 'Urgente',
      'status': 'Pendente'
    },
    {
      'id': 'FR-002',
      'equipment': 'Projetor Sony (EQ-012)',
      'reportedBy': 'Ana Santos',
      'date': '2023-05-10',
      'description': 'Superaquecimento',
      'priority': 'Crítico',
      'status': 'Em análise'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
        itemCount: _faultRequests.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final request = _faultRequests[index];
          return ListTile(
            title: Text(request['equipment']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reportado por: ${request['reportedBy']}'),
                Text(request['description']),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Chip(
                  label: Text(request['priority']),
                  backgroundColor: _getPriorityColor(request['priority']),
                ),
                SizedBox(height: 4),
                Text(request['status']),
              ],
            ),
            onTap: () => _showRequestDetails(context, request),
          );
        },
      ),
    );
  }

  void _showRequestDetails(BuildContext context, Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detalhes da Solicitação'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Equipamento: ${request['equipment']}'),
              Text('Reportado por: ${request['reportedBy']}'),
              Text('Data: ${request['date']}'),
              Text('Prioridade: ${request['priority']}'),
              Text('Status: ${request['status']}'),
              SizedBox(height: 10),
              Text('Descrição:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(request['description']),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Fechar'),
            ),
            if (request['status'] == 'Pendente')
              ElevatedButton(
                onPressed: () {
                  // Aprovar solicitação
                  Navigator.pop(context);
                },
                child: Text('Aprovar'),
              ),
          ],
        );
      },
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Crítico':
        return Colors.red.shade100;
      case 'Urgente':
        return Colors.orange.shade100;
      default:
        return Colors.blue.shade100;
    }
  }
}

class DamagedEquipmentTab extends StatelessWidget {
  final List<Map<String, dynamic>> _damagedEquipment = [
    {
      'id': 'EQ-007',
      'name': 'Tablet Samsung',
      'damageDate': '2023-04-15',
      'damageDescription': 'Tela quebrada',
      'status': 'Aguardando reparo',
      'repairCost': 'R\$ 450,00'
    },
    {
      'id': 'EQ-015',
      'name': 'Notebook HP',
      'damageDate': '2023-05-05',
      'damageDescription': 'Teclado com teclas faltando',
      'status': 'Em conserto',
      'repairCost': 'R\$ 220,00'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
        itemCount: _damagedEquipment.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final equipment = _damagedEquipment[index];
          return ListTile(
            title: Text(equipment['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Data do dano: ${equipment['damageDate']}'),
                Text('Status: ${equipment['status']}'),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(equipment['repairCost']),
                SizedBox(height: 4),
                Chip(
                  label: Text(equipment['status']),
                  backgroundColor: _getStatusColor(equipment['status']),
                ),
              ],
            ),
            onTap: () => _showDamageDetails(context, equipment),
          );
        },
      ),
    );
  }

  void _showDamageDetails(BuildContext context, Map<String, dynamic> equipment) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detalhes do Equipamento Danificado'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Equipamento: ${equipment['name']} (${equipment['id']})'),
              Text('Data do dano: ${equipment['damageDate']}'),
              Text('Status: ${equipment['status']}'),
              Text('Custo estimado: ${equipment['repairCost']}'),
              SizedBox(height: 10),
              Text('Descrição do dano:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(equipment['damageDescription']),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Fechar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Registrar reparo
                Navigator.pop(context);
              },
              child: Text('Registrar Reparo'),
            ),
          ],
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Aguardando reparo':
        return Colors.red.shade100;
      case 'Em conserto':
        return Colors.orange.shade100;
      case 'Reparado':
        return Colors.green.shade100;
      default:
        return Colors.grey.shade300;
    }
  }
}