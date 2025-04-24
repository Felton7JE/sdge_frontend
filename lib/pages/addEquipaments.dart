import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdicionarEquipamentoScreen extends StatefulWidget {
  const AdicionarEquipamentoScreen({Key? key}) : super(key: key);

  @override
  State<AdicionarEquipamentoScreen> createState() =>
      _AdicionarEquipamentoScreenState();
}

class _AdicionarEquipamentoScreenState extends State<AdicionarEquipamentoScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _nome;
  String? _tipo;
  String? _modelo;
  String? _numeroSerie;
  DateTime? _dataAquisicao;
  String? _localizacao;
  String? _observacoes;
  List<Equipamento> _equipamentos = [];

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
                  selectedIndex: 1, // Mantém "Equipamentos" selecionado
                  onDestinationSelected: (index) {
                    // Implemente a lógica de navegação aqui.  Use pushReplacementNamed para evitar acumular telas na pilha
                    switch (index) {
                      case 0:
                        Navigator.pushReplacementNamed(context, '/dashboard');
                        break;
                      case 1:
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
                            icon: Icons.computer,
                            title: "Equipamentos Totais",
                            value: "150",
                            color: Colors.blue,
                          ),
                          _buildSummaryCard(
                            icon: Icons.check_circle,
                            title: "Equipamentos Operacionais",
                            value: "120",
                            color: Colors.green,
                          ),
                          _buildSummaryCard(
                            icon: Icons.warning,
                            title: "Equipamentos em Manutenção",
                            value: "10",
                            color: Colors.orange,
                          ),
                          _buildSummaryCard(
                            icon: Icons.error,
                            title: "Equipamentos Avariados",
                            value: "20",
                            color: Colors.red,
                          ),
                        ],
                      ),
                      const SizedBox(
                          height:
                              30.0), // Consistência no espaçamento
                      _buildEquipamentosTable(),
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
                            _showAddEquipmentDialog(context);
                          },
                          child: const Text(
                            "Adicionar Equipamento",
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
            currentIndex: 1,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.pushReplacementNamed(context, '/dashboard');
                  break;
                case 1:
                  // Não faz nada, permanece nesta tela
                  break;
                //implemente a lógica dos outros caso necessite
                default:
                  //  Navigator.pushReplacementNamed(context, '/outra_rota'); // Rota padrão se necessário
                  break;
              }
            },
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  Widget _buildEquipamentosTable() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Lista de Equipamentos",
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
                    DataColumn(label: Text("Nome")),
                    DataColumn(label: Text("Tipo")),
                    DataColumn(label: Text("Modelo")),
                    DataColumn(label: Text("Número de Série")),
                  ],
                  rows: _equipamentos.map((equipamento) {
                    return DataRow(cells: [
                      DataCell(Text(equipamento.nome ?? '')),
                      DataCell(Text(equipamento.tipo ?? '')),
                      DataCell(Text(equipamento.modelo ?? '')),
                      DataCell(Text(equipamento.numeroSerie ?? '')),
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

  void _showAddEquipmentDialog(BuildContext context) {
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
                    "Adicionar Equipamento",
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
                    width: MediaQuery.of(context).size.width * 0.30, // Ajuste a largura para ocupar metade do espaço disponível
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
                    width: MediaQuery.of(context).size.width * 0.30, // Ajuste a largura para ocupar metade do espaço disponível
                    child: _buildFormField(
                      context: context,
                      labelText: "Modelo",
                      onSaved: (value) => _modelo = value,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30, // Ajuste a largura para ocupar metade do espaço disponível
                    child: _buildFormField(
                      context: context,
                      labelText: "Número de Série",
                      onSaved: (value) => _numeroSerie = value,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30, // Ajuste a largura para ocupar metade do espaço disponível
                    child: _buildFormField(
                      context: context,
                      labelText: "Data de Aquisição",
                      isDate: true,
                      dateOnSaved: (DateTime? value) {
                        _dataAquisicao = value;
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30, // Ajuste a largura para ocupar metade do espaço disponível
                    child: _buildFormField(
                      context: context,
                      labelText: "Localização",
                      onSaved: (value) => _localizacao = value,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.30, // Ajuste a largura para ocupar metade do espaço disponível
                    child: _buildFormField(
                      context: context,
                      labelText: "Observações",
                      maxLines: 3,
                      onSaved: (value) => _observacoes = value,
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

                      Equipamento novoEquipamento = Equipamento(
                        nome: _nome,
                        tipo: _tipo,
                        modelo: _modelo,
                        numeroSerie: _numeroSerie,
                        dataAquisicao: _dataAquisicao,
                        localizacao: _localizacao,
                        observacoes: _observacoes,
                      );

                      setState(() {
                        _equipamentos.add(novoEquipamento);
                      });
                      Navigator.of(context).pop();
                      _formKey.currentState!.reset();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Equipamento adicionado com sucesso!"),
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
              _dataAquisicao = pickedDate;
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
                _dataAquisicao != null
                    ? DateFormat('dd/MM/yyyy').format(_dataAquisicao!)
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
          "Visão Geral do Sistema CETIC",
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

class Equipamento {
  String? nome;
  String? tipo;
  String? modelo;
  String? numeroSerie;
  DateTime? dataAquisicao;
  String? localizacao;
  String? observacoes;

  Equipamento({
    this.nome,
    this.tipo,
    this.modelo,
    this.numeroSerie,
    this.dataAquisicao,
    this.localizacao,
    this.observacoes,
  });
}