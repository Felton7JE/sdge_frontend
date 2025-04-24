import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EquipmentScreen extends StatefulWidget {
  const EquipmentScreen({Key? key}) : super(key: key);

  @override
  State<EquipmentScreen> createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends State<EquipmentScreen> {
  // Lista de equipamentos (simulando banco de dados)
  List<Map<String, dynamic>> _equipments = [
    {
      'id': 'EQ-001',
      'name': 'Notebook Dell',
      'type': 'Computador',
      'serialNumber': 'SN123456',
      'status': 'Disponível',
      'location': 'Sala 101',
      'acquisitionDate': '2022-01-15',
      'lastMaintenance': '2023-03-10',
      'image': 'assets/laptop.png',
    },
    {
      'id': 'EQ-002',
      'name': 'Projetor Epson',
      'type': 'Projetor',
      'serialNumber': 'SN789012',
      'status': 'Em uso',
      'location': 'Sala 203',
      'acquisitionDate': '2021-11-20',
      'lastMaintenance': '2023-02-28',
      'image': 'assets/projector.png',
    },
    {
      'id': 'EQ-003',
      'name': 'Tablet Samsung',
      'type': 'Tablet',
      'serialNumber': 'SN345678',
      'status': 'Em manutenção',
      'location': 'Oficina TI',
      'acquisitionDate': '2022-05-10',
      'lastMaintenance': '2023-01-15',
      'image': 'assets/tablet.png',
    },
  ];

  // Controladores para o formulário
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _serialController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _acquisitionDateController = TextEditingController();
  String _status = 'Disponível';
  String? _currentEquipmentId;
  bool _isEditing = false;

  // Filtros e busca
  String _searchQuery = '';
  String _filterStatus = 'Todos';
  String _filterType = 'Todos';

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _serialController.dispose();
    _locationController.dispose();
    _acquisitionDateController.dispose();
    super.dispose();
  }

  // Método para abrir o formulário de adição/edição
  void _openEquipmentForm({Map<String, dynamic>? equipment}) {
    setState(() {
      _isEditing = equipment != null;
      if (_isEditing) {
        _currentEquipmentId = equipment!['id'];
        _nameController.text = equipment['name'];
        _typeController.text = equipment['type'];
        _serialController.text = equipment['serialNumber'];
        _locationController.text = equipment['location'];
        _status = equipment['status'];
        _acquisitionDateController.text = equipment['acquisitionDate'];
      } else {
        _currentEquipmentId = null;
        _nameController.clear();
        _typeController.clear();
        _serialController.clear();
        _locationController.clear();
        _acquisitionDateController.clear();
        _status = 'Disponível';
      }
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _buildEquipmentForm(),
        );
      },
    );
  }

  // Método para salvar/atualizar equipamento
  void _saveEquipment() {
    if (_formKey.currentState!.validate()) {
      final newEquipment = {
        'id': _isEditing ? _currentEquipmentId : 'EQ-${_equipments.length + 1}',
        'name': _nameController.text,
        'type': _typeController.text,
        'serialNumber': _serialController.text,
        'status': _status,
        'location': _locationController.text,
        'acquisitionDate': _acquisitionDateController.text,
        'lastMaintenance': _isEditing 
            ? _equipments.firstWhere((e) => e['id'] == _currentEquipmentId)['lastMaintenance']
            : 'Nunca',
        'image': _isEditing 
            ? _equipments.firstWhere((e) => e['id'] == _currentEquipmentId)['image']
            : 'assets/default.png',
      };

      setState(() {
        if (_isEditing) {
          int index = _equipments.indexWhere((e) => e['id'] == _currentEquipmentId);
          _equipments[index] = newEquipment;
        } else {
          _equipments.add(newEquipment);
        }
      });

      Navigator.pop(context);
    }
  }

  // Método para deletar equipamento
  void _deleteEquipment(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar exclusão'),
          content: Text('Tem certeza que deseja remover este equipamento?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _equipments.removeWhere((e) => e['id'] == id);
                });
                Navigator.pop(context);
              },
              child: Text('Confirmar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Método para filtrar equipamentos
  List<Map<String, dynamic>> _filterEquipments() {
    return _equipments.where((equipment) {
      bool matchesSearch = equipment['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          equipment['serialNumber'].toLowerCase().contains(_searchQuery.toLowerCase());
      
      bool matchesStatus = _filterStatus == 'Todos' || equipment['status'] == _filterStatus;
      bool matchesType = _filterType == 'Todos' || equipment['type'] == _filterType;
      
      return matchesSearch && matchesStatus && matchesType;
    }).toList();
  }

  // Widget do formulário
  Widget _buildEquipmentForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isEditing ? 'Editar Equipamento' : 'Adicionar Equipamento',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nome do Equipamento',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o nome do equipamento';
                }
                return null;
              },
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _typeController,
              decoration: InputDecoration(
                labelText: 'Tipo',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o tipo do equipamento';
                }
                return null;
              },
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _serialController,
              decoration: InputDecoration(
                labelText: 'Número de Série',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o número de série';
                }
                return null;
              },
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Localização',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira a localização';
                }
                return null;
              },
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _acquisitionDateController,
              decoration: InputDecoration(
                labelText: 'Data de Aquisição',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  _acquisitionDateController.text = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, selecione a data de aquisição';
                }
                return null;
              },
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: ['Disponível', 'Em uso', 'Em manutenção', 'Desativado']
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _status = value;
                  });
                }
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saveEquipment,
                  child: Text(_isEditing ? 'Atualizar' : 'Salvar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredEquipments = _filterEquipments();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho e barra de busca
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar equipamentos...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Filtrar Equipamentos'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DropdownButtonFormField<String>(
                                value: _filterStatus,
                                decoration: InputDecoration(
                                  labelText: 'Status',
                                ),
                                items: ['Todos', 'Disponível', 'Em uso', 'Em manutenção', 'Desativado']
                                    .map((status) => DropdownMenuItem(
                                          value: status,
                                          child: Text(status),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _filterStatus = value;
                                    });
                                  }
                                },
                              ),
                              DropdownButtonFormField<String>(
                                value: _filterType,
                                decoration: InputDecoration(
                                  labelText: 'Tipo',
                                ),
                                items: [
                                  'Todos',
                                  'Computador',
                                  'Projetor',
                                  'Tablet',
                                  'Impressora',
                                  'Outros'
                                ]
                                    .map((type) => DropdownMenuItem(
                                          value: type,
                                          child: Text(type),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _filterType = value;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Aplicar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 16),

            // Resumo e estatísticas
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                Chip(
                  label: Text('Total: ${_equipments.length}'),
                  backgroundColor: Colors.blue.shade100,
                ),
                Chip(
                  label: Text('Disponíveis: ${_equipments.where((e) => e['status'] == 'Disponível').length}'),
                  backgroundColor: Colors.green.shade100,
                ),
                Chip(
                  label: Text('Em uso: ${_equipments.where((e) => e['status'] == 'Em uso').length}'),
                  backgroundColor: Colors.orange.shade100,
                ),
                Chip(
                  label: Text('Manutenção: ${_equipments.where((e) => e['status'] == 'Em manutenção').length}'),
                  backgroundColor: Colors.red.shade100,
                ),
              ],
            ),
            SizedBox(height: 16),

            // Tabela de equipamentos
            Expanded(
              child: filteredEquipments.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhum equipamento encontrado',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Nome')),
                          DataColumn(label: Text('Tipo')),
                          DataColumn(label: Text('Nº Série')),
                          DataColumn(label: Text('Localização')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Ações')),
                        ],
                        rows: filteredEquipments.map((equipment) {
                          return DataRow(cells: [
                            DataCell(Text(equipment['id'])),
                            DataCell(
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 150),
                                child: Text(
                                  equipment['name'],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            DataCell(Text(equipment['type'])),
                            DataCell(Text(equipment['serialNumber'])),
                            DataCell(Text(equipment['location'])),
                            DataCell(
                              Chip(
                                label: Text(equipment['status']),
                                backgroundColor: _getStatusColor(equipment['status']),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _openEquipmentForm(equipment: equipment),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteEquipment(equipment['id']),
                                  ),
                                ],
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEquipmentForm(),
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple.shade400,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Disponível':
        return Colors.green.shade100;
      case 'Em uso':
        return Colors.orange.shade100;
      case 'Em manutenção':
        return Colors.red.shade100;
      case 'Desativado':
        return Colors.grey.shade300;
      default:
        return Colors.blue.shade100;
    }
  }
}