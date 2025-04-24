import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl for date formatting

class EmprestimoEquipamentoScreen extends StatefulWidget {
  const EmprestimoEquipamentoScreen({Key? key}) : super(key: key);

  @override
  State<EmprestimoEquipamentoScreen> createState() =>
      _EmprestimoEquipamentoScreenState();
}

class _EmprestimoEquipamentoScreenState
    extends State<EmprestimoEquipamentoScreen> {
  final _formKey = GlobalKey<FormState>(); // Add form key
  String? _nomeEquipamento;
  String? _nomeRequisitante;
  DateTime? _dataEmprestimo;
  DateTime? _dataDevolucaoPrevista;
  String? _status; // e.g., "Emprestado", "Devolvido", "Atrasado"

  // Example Data (replace with actual data fetching)
  final List<Emprestimo> _emprestimos = [
    Emprestimo(
        equipamento: "Notebook Acer Aspire",
        requisitante: "Carlos Pereira",
        dataEmprestimo: DateTime.now().subtract(const Duration(days: 3)),
        dataDevolucaoPrevista: DateTime.now().add(const Duration(days: 4)),
        status: "Emprestado"),
    Emprestimo(
        equipamento: "Projetor Epson",
        requisitante: "Ana Costa",
        dataEmprestimo: DateTime.now().subtract(const Duration(days: 10)),
        dataDevolucaoPrevista: DateTime.now().subtract(const Duration(days: 3)),
        status: "Devolvido"),
    Emprestimo(
        equipamento: "Tablet Samsung",
        requisitante: "Mariana Lima",
        dataEmprestimo: DateTime.now().subtract(const Duration(days: 1)),
        dataDevolucaoPrevista: DateTime.now().add(const Duration(days: 6)),
        status: "Emprestado"),
    Emprestimo(
        equipamento: "Câmera Canon DSLR",
        requisitante: "Ricardo Sousa",
        dataEmprestimo: DateTime.now().subtract(const Duration(days: 5)),
        dataDevolucaoPrevista: DateTime.now().subtract(const Duration(days: 1)),
        status: "Atrasado"),
  ];

  // Variables for table sorting
  int? _sortColumnIndex;
  bool _sortAscending = true;

  // Sorting function
  void _sort<T extends Comparable<T>?>(
      Comparable<T>? Function(Emprestimo d) getField,
      int columnIndex,
      bool ascending) {
    _emprestimos.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);

      return compareNullable<T>(aValue, bValue, ascending);
    });
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  int compareNullable<T extends Comparable<T>?>(
      Comparable<T>? a, Comparable<T>? b, bool ascending) {
    if (a == null && b == null) return 0;
    if (a == null) return ascending ? -1 : 1;
    if (b == null) return ascending ? 1 : -1;
    return ascending ? a.compareTo(b as T) : b.compareTo(a as T);
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
              // Consistent NavigationRail
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
                  selectedIndex: 5, // Correct index for Empréstimos
                  onDestinationSelected: (index) {
                    // Consistent navigation logic
                    switch (index) {
                      case 0:
                        Navigator.pushReplacementNamed(context, '/dashboard');
                        break;
                      case 1:
                        Navigator.pushReplacementNamed(
                            context, '/equipamentos');
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
                        // Already here
                        break;
                      default:
                        break;
                    }
                  },
                  labelType: NavigationRailLabelType.none,
                ),
              Expanded(
                child: SingleChildScrollView(
                  // Added SingleChildScrollView
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(), // Consistent Header
                        const SizedBox(height: 20),
                        Wrap(
                          // Consistent Wrap for cards
                          spacing: 20,
                          runSpacing: 20,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildSummaryCard(
                              // Consistent Summary Card
                              icon: Icons.local_shipping,
                              title: "Total de Empréstimos",
                              value: _emprestimos.length.toString(),
                              color: Colors.blue,
                            ),
                            _buildSummaryCard(
                              icon: Icons.sync, // Icon for ongoing/borrowed
                              title: "Atualmente Emprestados",
                              value: _emprestimos
                                  .where((e) => e.status == "Emprestado")
                                  .length
                                  .toString(),
                              color: Colors.orange, // Color for borrowed
                            ),
                            _buildSummaryCard(
                              icon: Icons.check_circle,
                              title: "Devolvidos",
                              value: _emprestimos
                                  .where((e) => e.status == "Devolvido")
                                  .length
                                  .toString(),
                              color: Colors.green,
                            ),
                            _buildSummaryCard(
                              icon: Icons.error_outline, // Icon for overdue
                              title: "Atrasados",
                              value: _emprestimos
                                  .where((e) => e.status == "Atrasado")
                                  .length
                                  .toString(),
                              color: Colors.red,
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        _buildEmprestimosTable(), // Consistent Table
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
                              _showAddEmprestimoDialog(context); // Add Dialog
                            },
                            child: const Text(
                              "Adicionar Empréstimo",
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
                  icon: Icon(Icons.build),
                  label: "Manutenção"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.warning),
                  label: "Avarias"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.request_page),
                  label: "Requisições"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.local_shipping),
                  label: "Empréstimos"),
            ],
            currentIndex: 5, // Correct index for Empréstimos
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
                      context, '/equipamentos');
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
                  // Already here
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
              "Empréstimo de Equipamentos", // Updated Title
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
                      color: Colors.grey[800])), // Use consistent text color for value
            ),
          ),
        ],
      ),
    );
  }

  // Consistent Table Widget (Adapted from addEquipaments.dart)
  Widget _buildEmprestimosTable() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Lista de Empréstimos",
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
                  // Added horizontal scroll
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending,
                    columnSpacing: 16,
                    horizontalMargin: 10,
                    columns: [
                      // Added more relevant columns and sorting
                      DataColumn(
                        label: const Text("Equipamento"),
                        onSort: (columnIndex, ascending) => _sort<String>(
                            (d) => d.equipamento, columnIndex, ascending),
                      ),
                      DataColumn(
                        label: const Text("Requisitante"),
                        onSort: (columnIndex, ascending) => _sort<String>(
                            (d) => d.requisitante, columnIndex, ascending),
                      ),
                      DataColumn(
                        label: const Text("Data Empréstimo"),
                        onSort: (columnIndex, ascending) => _sort<DateTime>(
                            (d) => d.dataEmprestimo, columnIndex, ascending),
                      ),
                      DataColumn(
                        label: const Text("Devolução Prevista"),
                        onSort: (columnIndex, ascending) => _sort<DateTime>(
                            (d) => d.dataDevolucaoPrevista,
                            columnIndex,
                            ascending),
                      ),
                      DataColumn(
                        label: const Text("Status"),
                        onSort: (columnIndex, ascending) => _sort<String>(
                            (d) => d.status, columnIndex, ascending),
                      ),
                    ],
                    rows: _emprestimos.map((emprestimo) {
                      // Determine status color
                      Color statusColor;
                      Color statusTextColor;
                      switch (emprestimo.status) {
                        case "Emprestado":
                          statusColor = Colors.orange.shade100;
                          statusTextColor = Colors.orange.shade800;
                          break;
                        case "Devolvido":
                          statusColor = Colors.green.shade100;
                          statusTextColor = Colors.green.shade800;
                          break;
                        case "Atrasado":
                          statusColor = Colors.red.shade100;
                          statusTextColor = Colors.red.shade800;
                          break;
                        default:
                          statusColor = Colors.grey.shade100;
                          statusTextColor = Colors.grey.shade800;
                      }

                      return DataRow(cells: [
                        DataCell(Text(emprestimo.equipamento ?? '')),
                        DataCell(Text(emprestimo.requisitante ?? '')),
                        DataCell(Text(emprestimo.dataEmprestimo != null
                            ? DateFormat('dd/MM/yyyy')
                                .format(emprestimo.dataEmprestimo!)
                            : 'N/A')),
                        DataCell(Text(emprestimo.dataDevolucaoPrevista != null
                            ? DateFormat('dd/MM/yyyy')
                                .format(emprestimo.dataDevolucaoPrevista!)
                            : 'N/A')),
                        DataCell(Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            emprestimo.status ?? 'N/A',
                            style: TextStyle(
                              color: statusTextColor,
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
          ],
        ),
      ),
    );
  }

  // Consistent Add Dialog (Adapted from addEquipaments.dart)
  void _showAddEmprestimoDialog(BuildContext context) {
    // Reset state variables
    _nomeEquipamento = null;
    _nomeRequisitante = null;
    _dataEmprestimo = null;
    _dataDevolucaoPrevista = null;
    _status = "Emprestado"; // Default status

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
                    "Adicionar Empréstimo",
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
                      onSaved: (value) => _nomeEquipamento = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Insira o nome do equipamento.";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30,
                    child: _buildFormField(
                      context: context,
                      labelText: "Nome do Requisitante",
                      onSaved: (value) => _nomeRequisitante = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Insira o nome do requisitante.";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30,
                    child: _buildDateField(
                      labelText: "Data Empréstimo",
                      onSaved: (DateTime? value) {
                        _dataEmprestimo = value;
                      },
                      selectedDate: _dataEmprestimo,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30,
                    child: _buildDateField(
                      labelText: "Devolução Prevista",
                      onSaved: (DateTime? value) {
                        _dataDevolucaoPrevista = value;
                      },
                      selectedDate: _dataDevolucaoPrevista,
                    ),
                  ),
                  // Status might be automatically set or use a dropdown
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30,
                    child: _buildFormField(
                      // Or DropdownButtonFormField
                      context: context,
                      labelText: "Status Inicial",
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
                  child: const Text("Salvar"),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      Emprestimo novoEmprestimo = Emprestimo(
                        equipamento: _nomeEquipamento,
                        requisitante: _nomeRequisitante,
                        dataEmprestimo: _dataEmprestimo,
                        dataDevolucaoPrevista: _dataDevolucaoPrevista,
                        status: _status,
                      );

                      setState(() {
                        _emprestimos.add(novoEmprestimo);
                        _sort<String>((d) => d.equipamento,
                            _sortColumnIndex ?? 0, _sortAscending);
                      });
                      Navigator.of(context).pop();
                      _formKey.currentState!.reset();
                      setState(() {
                        _dataEmprestimo = null;
                        _dataDevolucaoPrevista = null;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Empréstimo adicionado com sucesso!"),
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

  // Consistent Form Field Widget (Copied from addEquipaments.dart)
  Widget _buildFormField({
    required BuildContext context,
    required String labelText,
    int? maxLines,
    String? initialValue, // Added initialValue
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue, // Use initialValue
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
              if (labelText == "Data Empréstimo") {
                _dataEmprestimo = pickedDate;
              } else if (labelText == "Devolução Prevista") {
                _dataDevolucaoPrevista = pickedDate;
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
}

// Consistent Data Model Class
class Emprestimo {
  String? equipamento;
  String? requisitante;
  DateTime? dataEmprestimo;
  DateTime? dataDevolucaoPrevista;
  String? status;

  Emprestimo({
    this.equipamento,
    this.requisitante,
    this.dataEmprestimo,
    this.dataDevolucaoPrevista,
    this.status,
  });
}