import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AvariaScreen extends StatefulWidget {
  const AvariaScreen({Key? key}) : super(key: key);

  @override
  State<AvariaScreen> createState() => _AvariaScreenState();
}

class _AvariaScreenState extends State<AvariaScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _equipamento;
  String? _descricao;
  DateTime? _dataAvaria;
  String? _status; // "Pendente", "Em Andamento", "Concluída"
  String? _responsavel;
  List<Avaria> _avarias = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 800;
          return Row(
            children: [
              // NavigationRail (Menu Lateral)
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
                  selectedIndex: 3, // Mantém "Avarias" selecionado
                  onDestinationSelected: (index) {
                    // Implemente a lógica de navegação aqui.  Use pushReplacementNamed para evitar acumular telas na pilha
                    switch (index) {
                      case 0:
                        Navigator.pushReplacementNamed(context, '/dashboard');
                        break;
                      case 1:
                        Navigator.pushReplacementNamed(context, '/equipamentos');
                        break;
                      case 3:
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
                        alignment: WrapAlignment.center, // Centraliza os cards horizontalmente
                        children: [
                          _buildSummaryCard(
                            icon: Icons.warning,
                            title: "Avarias Pendentes",
                            value: "5",
                            color: Colors.orange,
                          ),
                          _buildSummaryCard(
                            icon: Icons.build,
                            title: "Avarias Em Andamento",
                            value: "3",
                            color: Colors.blue,
                          ),
                          _buildSummaryCard(
                            icon: Icons.check_circle,
                            title: "Avarias Concluídas",
                            value: "12",
                            color: Colors.green,
                          ),
                        ],
                      ),
                      const SizedBox(
                          height:
                              30.0), // Consistência no espaçamento
                      _buildAvariasTable(),
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
                            _showAddAvariaDialog(context);
                          },
                          child: const Text(
                            "Reportar Avaria",
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
            currentIndex: 3,
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
                case 3:
                  Navigator.pushReplacementNamed(context, '/avarias');
                  break;
                //  Navigator.pushReplacementNamed(context, '/outra_rota'); // Rota padrão se necessário
              }
            },
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  Widget _buildAvariasTable() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Lista de Avarias",
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
                // Adiciona um tema para customizar o DataTable
                data: ThemeData.light().copyWith(
                  cardColor: Colors.white,
                  textTheme: const TextTheme(
                    bodyMedium:
                        TextStyle(color: Colors.black), // Cor dos textos
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
                    DataColumn(label: Text("Equipamento")),
                    DataColumn(label: Text("Descrição")),
                    DataColumn(label: Text("Data")),
                    DataColumn(label: Text("Status")),
                  ],
                  rows: _avarias.map((avaria) {
                    return DataRow(cells: [
                      DataCell(Text(avaria.equipamento ?? '')),
                      DataCell(Text(avaria.descricao ?? '')),
                      DataCell(Text(avaria.dataAvaria != null ? DateFormat('dd/MM/yyyy').format(avaria.dataAvaria!) : '')),
                      DataCell(Text(avaria.status ?? '')),
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

  void _showAddAvariaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.15, // Aumentei para 15% em cada lado
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
                    "Reportar Avaria",
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
              child: Wrap( // Alterado para Wrap
                spacing: 16.0, // Espaçamento horizontal entre os campos
                runSpacing: 16.0, // Espaçamento vertical entre as linhas
                alignment: WrapAlignment.center, // Centraliza os campos no Wrap
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30, // Ajuste a largura para ocupar metade do espaço disponível
                    child: _buildFormField(
                      context: context,
                      labelText: "Equipamento",
                      onSaved: (value) => _equipamento = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor, insira o equipamento.";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30, // Ajuste a largura para ocupar metade do espaço disponível
                    child: _buildFormField(
                      context: context,
                      labelText: "Descrição da Avaria",
                      maxLines: 3,
                      onSaved: (value) => _descricao = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor, insira a descrição da avaria.";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30, // Ajuste a largura para ocupar metade do espaço disponível
                    child: _buildFormField(
                      context: context,
                      labelText: "Data da Avaria",
                      isDate: true,
                      dateOnSaved: (DateTime? value) {
                        _dataAvaria = value;
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30, // Ajuste a largura para ocupar metade do espaço disponível
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Status",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                8)), // Borda arredondada
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12), // Padding interno
                        labelStyle: TextStyle(color: Colors.grey[600]), // Cor do label
                        focusedBorder: OutlineInputBorder(
                          // Estilo da borda quando o campo está focado
                          borderSide:
                          const BorderSide(color: Color(0xFF3F51B5), width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: OutlineInputBorder(
                          // Estilo da borda em caso de erro
                          borderSide: const BorderSide(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          // Estilo da borda quando o campo está focado e tem erro
                          borderSide: const BorderSide(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      value: _status,
                      items: const [
                        DropdownMenuItem(value: "Pendente", child: Text("Pendente")),
                        DropdownMenuItem(value: "Em Andamento", child: Text("Em Andamento")),
                        DropdownMenuItem(value: "Concluída", child: Text("Concluída")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _status = value;
                        });
                      },
                      onSaved: (value) => _status = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Por favor, selecione o status.";
                        }
                        return null;
                      },
                    ),
                  ),
                   SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30, // Ajuste a largura para ocupar metade do espaço disponível
                    child: _buildFormField(
                      context: context,
                      labelText: "Responsável",
                      onSaved: (value) => _responsavel = value,
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
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Salvar",
                    style: TextStyle(color: Colors.white), // Adicionado para garantir que o texto seja branco
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      Avaria novaAvaria = Avaria(
                        equipamento: _equipamento,
                        descricao: _descricao,
                        dataAvaria: _dataAvaria,
                        status: _status,
                        responsavel: _responsavel,
                      );

                      setState(() {
                        _avarias.add(novaAvaria);
                      });
                      Navigator.of(context).pop();
                      _formKey.currentState!.reset();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Avaria reportada com sucesso!"),
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
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: isDate
          ? _buildDateField(labelText: labelText, onSaved: dateOnSaved)
          : TextFormField(
              decoration: InputDecoration(
                labelText: labelText,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        8)), // Borda arredondada
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12), // Padding interno
                labelStyle: TextStyle(color: Colors.grey[600]), // Cor do label
                focusedBorder: OutlineInputBorder(
                  // Estilo da borda quando o campo está focado
                  borderSide:
                      const BorderSide(color: Color(0xFF3F51B5), width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                errorBorder: OutlineInputBorder(
                  // Estilo da borda em caso de erro
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  // Estilo da borda quando o campo está focado e tem erro
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: maxLines ?? 1,
              onSaved: onSaved,
              validator: validator,
              style: const TextStyle(fontSize: 16), // Tamanho da fonte
            ),
    );
  }

  Widget _buildDateField({
    required String labelText,
    FormFieldSetter<DateTime?>? onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            builder: (BuildContext context, Widget? child) {
              // Customiza o DatePicker
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
              _dataAvaria = pickedDate;
            });
            onSaved?.call(
                pickedDate); // Chama o onSaved com a data selecionada.
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    8)), // Borda arredondada
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12), // Padding interno
            labelStyle: TextStyle(color: Colors.grey[600]), // Cor do label
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _dataAvaria != null
                    ? DateFormat('dd/MM/yyyy').format(_dataAvaria!)
                    : "Selecione a data",
                style: const TextStyle(fontSize: 16), // Tamanho da fonte
              ),
              Icon(Icons.calendar_today,
                  color: Colors.grey[600]), // Cor do ícone
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
          "Gerenciamento de Avarias",
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

class Avaria {
  String? equipamento;
  String? descricao;
  DateTime? dataAvaria;
  String? status;
  String? responsavel;


  Avaria({
    this.equipamento,
    this.descricao,
    this.dataAvaria,
    this.status,
    this.responsavel,
  });
}