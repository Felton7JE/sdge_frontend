import 'package:flutter/material.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({Key? key}) : super(key: key);

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  List<Map<String, dynamic>> _maintenances = [
    {
      'id': 'MT-001',
      'equipment': 'Notebook Dell (EQ-001)',
      'type': 'Preventiva',
      'startDate': '2023-05-10',
      'endDate': '2023-05-12',
      'status': 'Concluída',
      'technician': 'João Silva',
      'description': 'Limpeza interna e troca de pasta térmica',
      'cost': 'R\$ 120,00'
    },
    {
      'id': 'MT-002',
      'equipment': 'Projetor Epson (EQ-002)',
      'type': 'Corretiva',
      'startDate': '2023-05-15',
      'endDate': '',
      'status': 'Em andamento',
      'technician': 'Maria Souza',
      'description': 'Substituição da lâmpada',
      'cost': 'R\$ 350,00'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 16),
            Expanded(
              child: _buildMaintenanceList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMaintenanceDialog(),
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple.shade400,
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Registros de Manutenção',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Chip(
          label: Text('Total: ${_maintenances.length}'),
          backgroundColor: Colors.blue.shade100,
        ),
      ],
    );
  }

  Widget _buildMaintenanceList() {
    return ListView.separated(
      itemCount: _maintenances.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        final maintenance = _maintenances[index];
        return ListTile(
          title: Text(maintenance['equipment']),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${maintenance['type']} - ${maintenance['status']}'),
              Text('Técnico: ${maintenance['technician']}'),
            ],
          ),
          trailing: Chip(
            label: Text(maintenance['status']),
            backgroundColor: _getStatusColor(maintenance['status']),
          ),
          onTap: () => _showMaintenanceDetails(maintenance),
        );
      },
    );
  }

  void _showMaintenanceDetails(Map<String, dynamic> maintenance) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detalhes da Manutenção'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Equipamento', maintenance['equipment']),
                _buildDetailRow('Tipo', maintenance['type']),
                _buildDetailRow('Status', maintenance['status']),
                _buildDetailRow('Técnico', maintenance['technician']),
                _buildDetailRow('Início', maintenance['startDate']),
                if (maintenance['endDate'].isNotEmpty)
                  _buildDetailRow('Término', maintenance['endDate']),
                _buildDetailRow('Custo', maintenance['cost']),
                SizedBox(height: 10),
                Text('Descrição:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(maintenance['description']),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showAddMaintenanceDialog() {
    // Implementar formulário de adição de manutenção
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Concluída':
        return Colors.green.shade100;
      case 'Em andamento':
        return Colors.orange.shade100;
      case 'Cancelada':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade300;
    }
  }
}