import 'package:flutter/material.dart';
import 'package:sgde_fronted/components/navbar.dart';

class LoansScreen extends StatefulWidget {
  const LoansScreen({Key? key}) : super(key: key);

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> {
  int _selectedIndex = 5; // Índice para Empréstimos no menu
  int _selectedSubIndex = -1;
  
  List<Map<String, dynamic>> _loans = [
    {
      'id': 'LN-001',
      'equipment': 'Notebook Dell (EQ-001)',
      'borrower': 'João Silva',
      'startDate': '2023-05-10',
      'endDate': '2023-05-17',
      'status': 'Em andamento',
      'purpose': 'Trabalho remoto'
    },
    {
      'id': 'LN-002',
      'equipment': 'Tablet Samsung (EQ-003)',
      'borrower': 'Ana Santos',
      'startDate': '2023-05-12',
      'endDate': '2023-05-15',
      'status': 'Devolvido',
      'purpose': 'Apresentação em cliente'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          CustomNavigationRail(
            onMainItemSelected: (index) {
              setState(() {
                _selectedIndex = index;
                _selectedSubIndex = -1;
              });
              // Navegação entre telas poderia ser implementada aqui
            },
            onSubItemSelected: (index) {
              setState(() {
                _selectedSubIndex = index;
              });
            },
            selectedMainIndex: _selectedIndex,
            selectedSubIndex: _selectedSubIndex,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildHeader(),
                  SizedBox(height: 16),
                  _buildStatsRow(),
                  SizedBox(height: 16),
                  Expanded(
                    child: _buildLoansTable(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddLoanDialog(),
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
            'Registro de Empréstimos',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Chip(
          label: Text('Total: ${_loans.length}'),
          backgroundColor: Colors.blue.shade100,
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        Chip(
          label: Text('Ativos: ${_loans.where((loan) => loan['status'] == 'Em andamento').length}'),
          backgroundColor: Colors.orange.shade100,
        ),
        Chip(
          label: Text('Devolvidos: ${_loans.where((loan) => loan['status'] == 'Devolvido').length}'),
          backgroundColor: Colors.green.shade100,
        ),
        Chip(
          label: Text('Atrasados: ${_loans.where((loan) => loan['status'] == 'Atrasado').length}'),
          backgroundColor: Colors.red.shade100,
        ),
      ],
    );
  }

  Widget _buildLoansTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Equipamento')),
          DataColumn(label: Text('Responsável')),
          DataColumn(label: Text('Início')),
          DataColumn(label: Text('Término')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Ações')),
        ],
        rows: _loans.map((loan) {
          return DataRow(cells: [
            DataCell(Text(loan['id'])),
            DataCell(Text(loan['equipment'])),
            DataCell(Text(loan['borrower'])),
            DataCell(Text(loan['startDate'])),
            DataCell(Text(loan['endDate'])),
            DataCell(
              Chip(
                label: Text(loan['status']),
                backgroundColor: _getStatusColor(loan['status']),
              ),
            ),
            DataCell(
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.visibility, color: Colors.blue),
                    onPressed: () => _showLoanDetails(loan),
                  ),
                  if (loan['status'] == 'Em andamento')
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () => _returnEquipment(loan['id']),
                    ),
                ],
              ),
            ),
          ]);
        }).toList(),
      ),
    );
  }

  void _showLoanDetails(Map<String, dynamic> loan) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detalhes do Empréstimo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Equipamento: ${loan['equipment']}'),
              Text('Responsável: ${loan['borrower']}'),
              Text('Data de empréstimo: ${loan['startDate']}'),
              Text('Data de devolução: ${loan['endDate']}'),
              Text('Status: ${loan['status']}'),
              SizedBox(height: 10),
              Text('Finalidade:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(loan['purpose']),
            ],
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

  void _returnEquipment(String id) {
    setState(() {
      int index = _loans.indexWhere((loan) => loan['id'] == id);
      if (index != -1) {
        _loans[index]['status'] = 'Devolvido';
        _loans[index]['endDate'] = '2023-05-18'; // Data atual
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Equipamento marcado como devolvido')),
    );
  }

  void _showAddLoanDialog() {
    // Implementar formulário de novo empréstimo
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Em andamento':
        return Colors.orange.shade100;
      case 'Devolvido':
        return Colors.green.shade100;
      case 'Atrasado':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade300;
    }
  }
}