import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManutencaoEquipamentoScreen extends StatefulWidget {
  const ManutencaoEquipamentoScreen({Key? key}) : super(key: key);

  @override
  State<ManutencaoEquipamentoScreen> createState() =>
      _ManutencaoEquipamentoScreenState();
}

class _ManutencaoEquipamentoScreenState
    extends State<ManutencaoEquipamentoScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _nome;
  String? _tipo;
  String? _descricao;
  DateTime? _dataInicio;
  DateTime? _dataFim;
  String? _status;
  List<Manutencao> _manutencoes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 800;
          return Row(
            children: [
              if (isWideScreen)
                NavigationRail(
                  backgroundColor: const Color(0xFF3F51B5),
                  unselectedIconTheme: const IconThemeData(
                      color: Colors.white70, opacity: 1),
                  unselectedLabelTextStyle: const TextStyle(
                      color: Colors.white70, fontSize: 14),
                  selectedIconTheme: const IconThemeData(color: Colors.white),
                  selectedLabelTextStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  destinations: const [
                    NavigationRailDestination(
                        icon: Icon(Icons.dashboard), label: Text("Painel")),
                    NavigationRailDestination(
                        icon: Icon(Icons.computer), label: Text("Equipamentos")),
                    NavigationRailDestination(
                        icon: Icon(Icons.build), label: Text("Manutenção")),
                    NavigationRailDestination(
                        icon: Icon(Icons.warning), label: Text("Avarias")),
                    NavigationRailDestination(
                        icon: Icon(Icons.request_page),
                        label: Text("Requisições")),
                    NavigationRailDestination(
                        icon: Icon(Icons.local_shipping),
                        label: Text("Empréstimos")),
                  ],
                  selectedIndex: 2, // Mantém "Manutenção" selecionado
                  onDestinationSelected: (index) {
                    // Implemente a lógica de navegação aqui. Use pushReplacementNamed para evitar acumular telas na pilha
                    switch (index) {
                      case 0:
                        Navigator.pushReplacementNamed(context, '/dashboard');
                        break;
                      case 1:
                        Navigator.pushReplacementNamed(
                            context, '/equipamentos');
                        break;
                      case 2:
                        // Não faz nada, permanece nesta tela
                        break;
                      //implemente a lógica dos outros caso necessite
                      default:
                        //  Navigator.pushReplacementNamed(context, '/outra_rota'); // Rota padrão se necessário
                        break;
                    }
                  },
                  labelType: NavigationRailLabelType.none, //Oculta as labels
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 24.0), // Ajuste o padding vertical
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(
                          height:
                              20.0), // Consistência no espaçamento
                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildSummaryCard(
                            icon: Icons.build,
                            title: "Manutenções Totais",
                            value: _manutencoes.length.toString(),
                            color: Colors.blue,
                          ),
                          _buildSummaryCard(
                            icon: Icons.check_circle,
                            title: "Concluídas",
                            value: _manutencoes
                                .where((m) => m.status == "Concluído")
                                .length
                                .toString(),
                            color: Colors.green,
                          ),
                          _buildSummaryCard(
                            icon: Icons.warning,
                            title: "Pendentes",
                            value: _manutencoes
                                .where((m) => m.status == "Pendente")
                                .length
                                .toString(),
                            color: Colors.orange,
                          ),
                        ],
                      ),
                      const SizedBox(
                          height:
                              30.0), // Consistência no espaçamento
                      _buildManutencoesTable(),
                      const SizedBox(
                          height:
                              30.0), // Consistência no espaçamento
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3F51B5),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            textStyle: const TextStyle(fontSize: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {
                            _showAddManutencaoDialog(context);
                          },
                          child: const Text(
                            "Adicionar Manutenção",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar:
          LayoutBuilder(builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 600;
        if (!isWideScreen) {
          return BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard), label: "Painel"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.computer), label: "Equipamentos"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.build), label: "Manutenção"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.warning), label: "Avarias"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.request_page),
                  label: "Requisições"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.local_shipping), label: "Empréstimos"),
            ],
            currentIndex: 2, // Marcar "Manutenção" como selecionado
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.pushReplacementNamed(context, '/dashboard');
                  break;
                case 1:
                  Navigator.pushReplacementNamed(context, '/equipamentos');
                  break;
                case 2:
                   Navigator.pushReplacementNamed(context, '/manutencao');
                  break;
                case 3:
                  Navigator.pushReplacementNamed(context, '/avarias');
                  break;
                case 4:
                  Navigator.pushReplacementNamed(context, '/requisicoes');
                  break;
                case 5:
                  Navigator.pushReplacementNamed(context, '/emprestimos');
                  break;
                default:
                  break;
              }
            },
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  Widget _buildManutencoesTable() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Lista de Manutenções",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: Theme(
                data: ThemeData.light().copyWith(
                  cardColor: Colors.white,
                  textTheme: const TextTheme(
                    bodyMedium: TextStyle(color: Colors.black),
                  ),
                  dataTableTheme: DataTableThemeData(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    dataRowHeight: 50,
                    headingRowHeight: 56,
                    headingTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
                child: DataTable(
                  columnSpacing: 16,
                  horizontalMargin: 0,
                  columns: const [
                    DataColumn(label: Text("Nome")),
                    DataColumn(label: Text("Tipo")),
                    DataColumn(label: Text("Descrição")),
                    DataColumn(label: Text("Data Início")),
                    DataColumn(label: Text("Data Fim")),
                    DataColumn(label: Text("Status")),
                  ],
                  rows: _manutencoes.map((manutencao) {
                    return DataRow(cells: [
                      DataCell(Text(manutencao.nome ?? '')),
                      DataCell(Text(manutencao.tipo ?? '')),
                      DataCell(Text(manutencao.descricao ?? '')),
                      DataCell(Text(manutencao.dataInicio != null
                          ? DateFormat('dd/MM/yyyy')
                              .format(manutencao.dataInicio!)
                          : '')),
                      DataCell(Text(manutencao.dataFim != null
                          ? DateFormat('dd/MM/yyyy').format(manutencao.dataFim!)
                          : '')),
                      DataCell(Text(manutencao.status ?? '')),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddManutencaoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.15,
            vertical: 20,
          ),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF3F51B5),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Adicionar Manutenção",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                alignment: WrapAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30,
                    child: _buildFormField(
                      context: context,
                      labelText: "Nome do Equipamento",
                      onSaved: (value) => _nome = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor, insira o nome do equipamento.";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30,
                    child: _buildFormField(
                      context: context,
                      labelText: "Tipo de Equipamento",
                      onSaved: (value) => _tipo = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor, insira o tipo de equipamento.";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30,
                    child: _buildFormField(
                      context: context,
                      labelText: "Descrição",
                      maxLines: 3,
                      onSaved: (value) => _descricao = value,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30,
                    child: _buildFormField(
                      context: context,
                      labelText: "Data Início",
                      isDate: true,
                      dateOnSaved: (DateTime? value) {
                        _dataInicio = value;
                      },
                      selectedDate: _dataInicio,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30,
                    child: _buildFormField(
                      context: context,
                      labelText: "Data Fim",
                      isDate: true,
                      dateOnSaved: (DateTime? value) {
                        _dataFim = value;
                      },
                      selectedDate: _dataFim,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30,
                    child: _buildFormField(
                      context: context,
                      labelText: "Status",
                      onSaved: (value) => _status = value,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                  ),
                  child: const Text("Cancelar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F51B5),
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Salvar",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      Manutencao novaManutencao = Manutencao(
                        nome: _nome,
                        tipo: _tipo,
                        descricao: _descricao,
                        dataInicio: _dataInicio,
                        dataFim: _dataFim,
                        status: _status,
                      );

                      setState(() {
                        _manutencoes.add(novaManutencao);
                      });
                      Navigator.of(context).pop();
                      _formKey.currentState!.reset();
                      setState(() {
                        _dataInicio = null;
                        _dataFim = null;
                      });


                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Manutenção adicionada com sucesso!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildFormField({
    required BuildContext context,
    required String labelText,
    int? maxLines,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    bool isDate = false,
    FormFieldSetter<DateTime?>? dateOnSaved,
    DateTime? selectedDate,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: isDate
          ? _buildDateField(
              labelText: labelText,
              onSaved: dateOnSaved,
              selectedDate: selectedDate,
            )
          : TextFormField(
              decoration: InputDecoration(
                labelText: labelText,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                labelStyle: TextStyle(color: Colors.grey[600]),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFF3F51B5), width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: maxLines ?? 1,
              onSaved: onSaved,
              validator: validator,
              style: const TextStyle(fontSize: 16),
            ),
    );
  }

  Widget _buildDateField({
    required String labelText,
    FormFieldSetter<DateTime?>? onSaved,
    DateTime? selectedDate,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: selectedDate ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            builder: (BuildContext context, Widget? child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  primaryColor: const Color(0xFF3F51B5),
                  colorScheme: const ColorScheme.light(
                      primary: Color(0xFF3F51B5)),
                  buttonTheme:
                      const ButtonThemeData(textTheme: ButtonTextTheme.primary),
                ),
                child: child!,
              );
            },
          );

          if (pickedDate != null) {
            setState(() {
              if (labelText == "Data Início") {
                _dataInicio = pickedDate;
              } else if (labelText == "Data Fim") {
                _dataFim = pickedDate;
              }
            });
            onSaved?.call(pickedDate);
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            labelStyle: TextStyle(color: Colors.grey[600]),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedDate != null
                    ? DateFormat('dd/MM/yyyy').format(selectedDate)
                    : "Selecione a data",
                style: const TextStyle(fontSize: 16),
              ),
              Icon(Icons.calendar_today, color: Colors.grey[600]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Distribute space evenly
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

  // Header Widget
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 48),
        Text(
          "Manutenção de Equipamentos",
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.w600, color: Colors.grey[800]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundImage:
                    NetworkImage("https://randomuser.me/api/portraits/men/15.jpg"),
                radius: 20,
              ),
              const SizedBox(width: 8),
              Text("Utilizador",
                  style: TextStyle(fontSize: 16, color: Colors.grey[800])),
            ],
          ),
        ),
      ],
    );
  }
}

class Manutencao {
  String? nome;
  String? tipo;
  String? descricao;
  DateTime? dataInicio;
  DateTime? dataFim;
  String? status;

  Manutencao({
    this.nome,
    this.tipo,
    this.descricao,
    this.dataInicio,
    this.dataFim,
    this.status,
  });
}