import 'package:flutter/material.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({Key? key}) : super(key: key);

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  List<Map<String, dynamic>> _requests = [
    {
      'id': 'RQ-001',
      'equipment': 'Notebook Dell (EQ-001)',
      'requester': 'João Silva',
      'date': '2023-05-12',
      'purpose': 'Treinamento de equipe',
      'status': 'Aprovada',
      'returnDate': '2023-05-15'
    },
    {
      'id': 'RQ-002',
      'equipment': 'Projetor Epson (EQ-002)',
      'requester': 'Maria Souza',
      'date': '2023-05-14',
      'purpose': 'Apresentação para cliente',
      'status': 'Pendente',
      'returnDate': ''
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
              child: _buildRequestsList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddRequestDialog(),
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
            'Requisições de Equipamentos',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Chip(
          label: Text('Total: ${_requests.length}'),
          backgroundColor: Colors.blue.shade100,
        ),
      ],
    );
  }

  Widget _buildRequestsList() {
    return ListView.separated(
      itemCount: _requests.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        final request = _requests[index];
        return ListTile(
          title: Text(request['equipment']),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Solicitante: ${request['requester']}'),
              Text('Finalidade: ${request['purpose']}'),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(request['date']),
              SizedBox(height: 4),
              Chip(
                label: Text(request['status']),
                backgroundColor: _getStatusColor(request['status']),
              ),
            ],
          ),
          onTap: () => _showRequestDetails(request),
        );
      },
    );
  }

  void _showRequestDetails(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detalhes da Requisição'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Equipamento: ${request['equipment']}'),
              Text('Solicitante: ${request['requester']}'),
              Text('Data: ${request['date']}'),
              Text('Status: ${request['status']}'),
              if (request['returnDate'].isNotEmpty)
                Text('Data de devolução: ${request['returnDate']}'),
              SizedBox(height: 10),
              Text('Finalidade:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(request['purpose']),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Fechar'),
            ),
            if (request['status'] == 'Pendente')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _updateRequestStatus(request['id'], 'Aprovada');
                      Navigator.pop(context);
                    },
                    child: Text('Aprovar'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _updateRequestStatus(request['id'], 'Rejeitada');
                      Navigator.pop(context);
                    },
                    child: Text('Rejeitar'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  void _updateRequestStatus(String id, String status) {
    setState(() {
      int index = _requests.indexWhere((req) => req['id'] == id);
      if (index != -1) {
        _requests[index]['status'] = status;
        if (status == 'Aprovada') {
          _requests[index]['returnDate'] = '2023-05-20'; // Data estimada
        }
      }
    });
  }

  void _showAddRequestDialog() {
    // Implementar formulário de nova requisição
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Aprovada':
        return Colors.green.shade100;
      case 'Pendente':
        return Colors.orange.shade100;
      case 'Rejeitada':
        return Colors.red.shade100;
      case 'Devolvida':
        return Colors.blue.shade100;
      default:
        return Colors.grey.shade300;
    }
  }
}