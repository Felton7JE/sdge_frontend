import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AlocacaoEquipamentoScreen extends StatefulWidget {
  const AlocacaoEquipamentoScreen({Key? key}) : super(key: key);

  @override
  State<AlocacaoEquipamentoScreen> createState() =>
      _AlocacaoEquipamentoScreenState();
}

class _AlocacaoEquipamentoScreenState extends State<AlocacaoEquipamentoScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _nomeEquipamento;
  String? _tipoEquipamento;
  String? _alocadoPara;
  DateTime? _dataAlocacao;
  String? _status;

  // Dados de exemplo para a lista de equipamentos (substitua com seus dados reais)
  List<EquipamentoAlocacao> equipamentos = [
    EquipamentoAlocacao(
        nome: "Computador Dell XPS",
        tipo: "Computador",
        alocadoPara: "João Silva",
        dataAlocacao: DateTime.now().subtract(const Duration(days: 5)),
        status: "Ativo"),
    EquipamentoAlocacao(
        nome: "Monitor LG 27",
        tipo: "Monitor",
        alocadoPara: "Maria Souza",
        dataAlocacao: DateTime.now().subtract(const Duration(days: 10)),
        status: "Ativo"),
    EquipamentoAlocacao(
        nome: "Impressora HP Laserjet",
        tipo: "Impressora",
        alocadoPara: "Pedro Alves",
        dataAlocacao: DateTime.now().subtract(const Duration(days: 2)),
        status: "Inativo"),
    EquipamentoAlocacao(
        nome: "Notebook Acer Aspire",
        tipo: "Notebook",
        alocadoPara: "Ana Oliveira",
        dataAlocacao: DateTime.now().subtract(const Duration(days: 15)),
        status: "Ativo"),
  ];

  // Variáveis para rastrear a ordenação da tabela
  int? _sortColumnIndex;
  bool _sortAscending = true;

  // Função para ordenar a lista de equipamentos
  void _sort<T>(Comparable<T> Function(EquipamentoAlocacao d) getField,
      int columnIndex, bool ascending) {
    equipamentos.sort((a, b) {
      // Handle potential null values during comparison
      final Comparable<T>? aValue = getField(a);
      final Comparable<T>? bValue = getField(b);

      if (aValue == null && bValue == null) return 0;
      if (aValue == null)
        return ascending ? -1 : 1; // Nulls first when ascending
      if (bValue == null)
        return ascending ? 1 : -1; // Nulls last when descending

      // Invert comparison logic based on ascending flag AFTER handling nulls
      final comparison = Comparable.compare(aValue, bValue);
      return ascending ? comparison : -comparison;
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 800;
          return Row(
            children: [
              // NavigationRail (Menu Lateral) - Consistent
              if (isWideScreen)
                NavigationRail(
                  backgroundColor: const Color(0xFF3F51B5),
                  unselectedIconTheme:
                      const IconThemeData(color: Colors.white70, opacity: 1),
                  unselectedLabelTextStyle:
                      const TextStyle(color: Colors.white70, fontSize: 14),
                  selectedIconTheme: const IconThemeData(color: Colors.white),
                  selectedLabelTextStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  destinations: const [
                    NavigationRailDestination(
                        icon: Icon(Icons.dashboard), label: Text("Painel")),
                    NavigationRailDestination(
                        icon: Icon(Icons.computer),
                        label: Text("Equipamentos")),
                    NavigationRailDestination(
                        // Changed icon and label to reflect Allocation
                        icon: Icon(Icons.assignment_ind),
                        label: Text("Alocação")),
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
                  selectedIndex: 2, // Mantém "Alocação" selecionado
                  onDestinationSelected: (index) {
                    // Consistent navigation logic
                    switch (index) {
                      case 0:
                        Navigator.pushReplacementNamed(context, '/dashboard');
                        break;
                      case 1:
                        Navigator.pushReplacementNamed(
                            context, '/adicionar_equipamento');
                        break;
                      case 2:
                        // Already here
                        break;
                      case 3:
                        Navigator.pushReplacementNamed(context, '/manutencao');
                        break;
                      case 4:
                        Navigator.pushReplacementNamed(
                            context, '/avarias'); // Placeholder
                        break;
                      case 5:
                        Navigator.pushReplacementNamed(
                            context, '/requisicoes'); // Placeholder
                        break;
                      case 6: // Index adjusted for new item
                        Navigator.pushReplacementNamed(context, '/emprestimo');
                        break;
                      default:
                        break;
                    }
                  },
                  labelType: NavigationRailLabelType.none, //Oculta as labels
                ),
              Expanded(
                child: SingleChildScrollView(
                  // Adicionado SingleChildScrollView
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 24.0), // Ajuste o padding vertical
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(), // Use consistent header
                        const SizedBox(height: 20.0),
                        Wrap(
                            // Consistent Wrap for cards
                            spacing: 20,
                            runSpacing: 20,
                            alignment: WrapAlignment.center,
                            children: [
                              // Removed conditional display based on isWideScreen, Wrap handles responsiveness
                              _buildSummaryCard(
                                // Use consistent summary card
                                icon: Icons.group, // Changed icon
                                title: "Total de Alocações",
                                value: equipamentos.length.toString(),
                                color: Colors.blue,
                              ),
                              _buildSummaryCard(
                                icon: Icons.check_circle,
                                title: "Alocações Ativas",
                                value: equipamentos
                                    .where((e) => e.status == "Ativo")
                                    .length
                                    .toString(),
                                color: Colors.green,
                              ),
                              _buildSummaryCard(
                                icon: Icons.pause_circle_filled, // Changed icon
                                title: "Alocações Inativas",
                                value: equipamentos
                                    .where((e) =>
                                        e.status !=
                                        "Ativo") // More robust check
                                    .length
                                    .toString(),
                                color: Colors.orange,
                              ),
                              _buildSummaryCard(
                                icon: Icons.person_add,
                                title:
                                    "Novas (Últimos 7 dias)", // Shortened title
                                value: equipamentos
                                    .where((e) =>
                                        e.dataAlocacao != null &&
                                        e.dataAlocacao!.isAfter(
                                            // Null check for date
                                            DateTime.now().subtract(
                                                const Duration(days: 7))))
                                    .length
                                    .toString(),
                                color: Colors.purple,
                              ),
                            ]),
                        const SizedBox(height: 30.0), // Consistent spacing
                        _buildAlocacaoTable(), // Use consistent table
                        const SizedBox(height: 30.0), // Consistent spacing
                        Center(
                          // Consistent Add Button
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
                              _showAddAlocacaoDialog(
                                  context); // Use consistent dialog
                            },
                            child: const Text(
                              "Adicionar Alocação",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      // Consistent BottomNavigationBar
      bottomNavigationBar: LayoutBuilder(builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 600;
        if (!isWideScreen) {
          return BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard), label: "Painel"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.computer), label: "Equipamentos"),
              BottomNavigationBarItem(
                  // Changed icon and label
                  icon: Icon(Icons.assignment_ind),
                  label: "Alocação"),
              BottomNavigationBarItem(
                icon: Icon(Icons.build),
                label: "Manutenção",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.warning),
                label: "Avarias",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.request_page),
                label: "Requisições",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_shipping),
                label: "Empréstimos",
              ),
            ],
            currentIndex: 2, // Current index for Alocação
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            onTap: (index) {
              // Consistent navigation logic
              switch (index) {
                case 0:
                  Navigator.pushReplacementNamed(context, '/dashboard');
                  break;
                case 1:
                  Navigator.pushReplacementNamed(
                      context, '/adicionar_equipamento');
                  break;
                case 2:
                  // Already here
                  break;
                case 3:
                  Navigator.pushReplacementNamed(context, '/manutencao');
                  break;
                case 4:
                  Navigator.pushReplacementNamed(
                      context, '/avarias'); // Placeholder
                  break;
                case 5:
                  Navigator.pushReplacementNamed(
                      context, '/requisicoes'); // Placeholder
                  break;
                case 6: // Index adjusted
                  Navigator.pushReplacementNamed(context, '/emprestimo');
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

  // Consistent Header Widget (Copied from addEquipaments.dart)
  Widget _buildHeader() {
    return LayoutBuilder(builder: (context, constraints) {
      final isWideScreen = constraints.maxWidth > 800;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isWideScreen)
            const SizedBox(width: 48)
          else
            const SizedBox(width: 0),
          Expanded(
            child: Text(
              "Alocação de Equipamentos", // Updated Title
              style: TextStyle(
                  fontSize: isWideScreen ? 28 : 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800]),
              textAlign: isWideScreen ? TextAlign.center : TextAlign.start,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://randomuser.me/api/portraits/men/15.jpg"),
                  radius: 20,
                ),
                if (isWideScreen) const SizedBox(width: 8),
                if (isWideScreen)
                  Text("Utilizador",
                      style: TextStyle(fontSize: 16, color: Colors.grey[800])),
              ],
            ),
          ),
        ],
      );
    });
  }

  // Consistent Summary Card Widget (Copied from addEquipaments.dart)
  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: 200,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 32, color: color),
          Text(title,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500)),
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

  // Consistent Table Widget (Adapted from addEquipaments.dart)
  Widget _buildAlocacaoTable() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Lista de Alocações",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            // Keep SizedBox
            width: double.infinity,
            child: Theme(
              // Consistent Theme
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
              child: SingleChildScrollView(
                // Keep horizontal scroll
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending,
                  columnSpacing: 16,
                  horizontalMargin: 10,
                  columns: [
                    DataColumn(
                      label: const Text("Nome"),
                      onSort: (columnIndex, ascending) => _sort<String>(
                          (d) => d.nome ?? "", columnIndex, ascending),
                    ),
                    DataColumn(
                      label: const Text("Tipo"),
                      onSort: (columnIndex, ascending) => _sort<String>(
                          (d) => d.tipo ?? "", columnIndex, ascending),
                    ),
                    DataColumn(
                      label: const Text("Alocado Para"),
                      onSort: (columnIndex, ascending) => _sort<String>(
                          (d) => d.alocadoPara ?? "", columnIndex, ascending),
                    ),
                    DataColumn(
                      // Keep Date column responsive if needed, but it's common
                      label: const Text("Data de Alocação"),
                      onSort: (columnIndex, ascending) => _sort<DateTime>(
                          // Force DateTime, not DateTime?
                          (d) =>
                              d.dataAlocacao ??
                              DateTime(1900), // Provide a default value
                          columnIndex,
                          ascending),
                    ),
                    DataColumn(
                      label: const Text("Status"),
                      onSort: (columnIndex, ascending) => _sort<String>(
                          (d) => d.status ?? "", columnIndex, ascending),
                    ),
                  ],
                  rows: equipamentos.map((equipamento) {
                    return DataRow(cells: [
                      DataCell(Text(equipamento.nome ?? '')),
                      DataCell(Text(equipamento.tipo ?? '')),
                      DataCell(Text(equipamento.alocadoPara ?? '')),
                      DataCell(Text(equipamento.dataAlocacao != null
                          ? DateFormat('dd/MM/yyyy')
                              .format(equipamento.dataAlocacao!)
                          : 'N/A')),
                      DataCell(Container(
                        // Added container for status styling
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: equipamento.status == "Ativo"
                              ? Colors.green.shade100
                              : Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          equipamento.status ?? 'N/A',
                          style: TextStyle(
                            color: equipamento.status == "Ativo"
                                ? Colors.green.shade800
                                : Colors.orange.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  // Consistent Add Dialog (Adapted from addEquipaments.dart)
  void _showAddAlocacaoDialog(BuildContext context) {
    // Reset state variables for the dialog
    _nomeEquipamento = null;
    _tipoEquipamento = null;
    _alocadoPara = null;
    _dataAlocacao = null;
    _status = null;
    _formKey.currentState?.reset();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            // Use StatefulBuilder for date state
            builder: (context, setDialogState) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
              // Consistent padding
              horizontal: MediaQuery.of(context).size.width * 0.1,
              vertical: 20,
            ),
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            titlePadding: EdgeInsets.zero,
            title: Container(
              // Consistent Title Bar
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF3F51B5),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: const Center(
                child: Text(
                  "Adicionar Alocação",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Wrap(
                  // Consistent Wrap layout
                  spacing: 16.0,
                  runSpacing: 16.0,
                  alignment: WrapAlignment.center,
                  children: [
                    // Consistent SizedBox wrapping and field widths
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.30,
                      child: _buildFormField(
                        context: context,
                        labelText: "Nome do Equipamento",
                        onSaved: (value) => _nomeEquipamento = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Por favor, insira o nome.";
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
                        onSaved: (value) => _tipoEquipamento = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Por favor, insira o tipo.";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.30,
                      child: _buildFormField(
                        context: context,
                        labelText: "Alocado Para",
                        onSaved: (value) => _alocadoPara = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Por favor, insira para quem alocar.";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.30,
                      child: _buildDateField(
                        // Use consistent date field
                        labelText: "Data de Alocação",
                        currentValue: _dataAlocacao,
                        onDateSelected: (date) {
                          setDialogState(() {
                            // Update dialog state
                            _dataAlocacao = date;
                          });
                        },
                        onSaved: (value) =>
                            _dataAlocacao = value, // Still needed for form save
                        // Add validator if date is mandatory
                        validator: (value) {
                          if (value == null) {
                            return "Por favor, selecione a data.";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.30,
                      child: _buildFormField(
                        context: context,
                        labelText: "Status",
                        onSaved: (value) => _status = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Por favor, insira o status.";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actionsPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              // Consistent Actions
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text("Cancelar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F51B5),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Salvar"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    EquipamentoAlocacao novaAlocacao = EquipamentoAlocacao(
                      nome: _nomeEquipamento,
                      tipo: _tipoEquipamento,
                      alocadoPara: _alocadoPara,
                      dataAlocacao: _dataAlocacao,
                      status: _status,
                    );

                    setState(() {
                      equipamentos.add(novaAlocacao);
                      // Optionally sort here after adding
                      _sort<String>((d) => d.nome ?? "", _sortColumnIndex ?? 0,
                          _sortAscending);
                    });
                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Alocação adicionada com sucesso!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }

  // Consistent Form Field Widget (Copied from addEquipaments.dart)
  Widget _buildFormField({
    required BuildContext context,
    required String labelText,
    int? maxLines,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        maxLines: maxLines ?? 1,
        onSaved: onSaved,
        validator: validator,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  // Consistent Date Field Widget (Adapted from addEquipaments.dart)
  Widget _buildDateField({
    required String labelText,
    required DateTime? currentValue,
    required ValueChanged<DateTime?> onDateSelected,
    FormFieldSetter<DateTime?>? onSaved,
    FormFieldValidator<DateTime?>? validator, // Added validator parameter
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      // Wrap with FormField to enable validation
      child: FormField<DateTime>(
        onSaved: onSaved,
        validator: validator,
        initialValue: currentValue, // Set initial value for the FormField
        builder: (FormFieldState<DateTime> state) {
          return InkWell(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: state.value ?? DateTime.now(), // Use state's value
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      primaryColor: const Color(0xFF3F51B5),
                      colorScheme:
                          const ColorScheme.light(primary: Color(0xFF3F51B5)),
                      buttonTheme: const ButtonThemeData(
                          textTheme: ButtonTextTheme.primary),
                    ),
                    child: child!,
                  );
                },
              );

              if (pickedDate != null) {
                state.didChange(pickedDate); // Update FormField state
                onDateSelected(pickedDate); // Call the external callback
              }
            },
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: labelText,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                labelStyle: TextStyle(color: Colors.grey[600]),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: state.hasError ? Colors.red : Colors.grey.shade300,
                      width: 1), // Show error border
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          state.hasError ? Colors.red : const Color(0xFF3F51B5),
                      width: 2), // Show error border
                  borderRadius: BorderRadius.circular(8),
                ),
                errorText: state.errorText, // Display error text from validator
                errorBorder: OutlineInputBorder(
                  // Ensure error border style is defined
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  // Ensure focused error border style is defined
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    state.value != null // Use state's value for display
                        ? DateFormat('dd/MM/yyyy').format(state.value!)
                        : "Selecione a data",
                    style: TextStyle(
                      fontSize: 16,
                      color: state.hasError ? Colors.red : null,
                      // Indicate error in text color
                    ),
                  ),
                  Icon(Icons.calendar_today,
                      color: state.hasError ? Colors.red : Colors.grey[600]),
                  // Indicate error in icon color
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Consistent Data Model Class
class EquipamentoAlocacao {
  String? nome;
  String? tipo;
  String? alocadoPara;
  DateTime? dataAlocacao;
  String? status;

  EquipamentoAlocacao({
    this.nome,
    this.tipo,
    this.alocadoPara,
    this.dataAlocacao,
    this.status,
  });
}
