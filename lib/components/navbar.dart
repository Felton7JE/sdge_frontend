// navbar.dart
import 'package:flutter/material.dart';

class CustomNavigationRail extends StatefulWidget {
  final Function(int) onMainItemSelected;
  final Function(int) onSubItemSelected;
  final int selectedMainIndex;
  final int selectedSubIndex;

  const CustomNavigationRail({
    Key? key,
    required this.onMainItemSelected,
    required this.onSubItemSelected,
    required this.selectedMainIndex,
    required this.selectedSubIndex,
  }) : super(key: key);

  @override
  State<CustomNavigationRail> createState() => _CustomNavigationRailState();
}

class _CustomNavigationRailState extends State<CustomNavigationRail> {
  bool isExpanded = false;

  // Lista de itens do menu principal
  final List<NavigationRailDestination> mainMenuItems = [
    NavigationRailDestination(
      icon: Icon(Icons.dashboard),
      label: Text("Dashboard"),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.computer),
      label: Text("Equipamentos"),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.build),
      label: Text("Manutenção"),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.warning),
      label: Text("Avarias"),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.request_page),
      label: Text("Requisições"),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.local_shipping),
      label: Text("Empréstimos"),
    ),
  ];

  // Lista de subitens para cada item principal
  final Map<int, List<NavigationRailDestination>> subMenuItems = {
    1: [
      NavigationRailDestination(
        icon: Icon(Icons.assignment_turned_in),
        label: Text("Alocados"),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.assignment_late),
        label: Text("Não Alocados"),
      ),
    ],
    3: [
      NavigationRailDestination(
        icon: Icon(Icons.report_problem),
        label: Text("Solicitação"),
      ),
      NavigationRailDestination(
        icon: Icon(Icons.dangerous),
        label: Text("Danificados"),
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Navigation Rail com suporte a subitens
        NavigationRail(
          extended: isExpanded,
          backgroundColor: Colors.deepPurple.shade400,
          unselectedIconTheme: IconThemeData(color: Colors.white, opacity: 1),
          unselectedLabelTextStyle: TextStyle(color: Colors.white),
          selectedIconTheme: IconThemeData(color: Colors.deepPurple.shade900),
          destinations: mainMenuItems,
          selectedIndex: widget.selectedMainIndex,
          onDestinationSelected: (index) {
            widget.onMainItemSelected(index);
          },
        ),
        
        // Submenu quando aplicável
        if (subMenuItems.containsKey(widget.selectedMainIndex))
          NavigationRail(
            extended: isExpanded,
            backgroundColor: Colors.deepPurple.shade300,
            unselectedIconTheme: IconThemeData(color: Colors.white, opacity: 1),
            unselectedLabelTextStyle: TextStyle(color: Colors.white),
            selectedIconTheme: IconThemeData(color: Colors.deepPurple.shade900),
            destinations: subMenuItems[widget.selectedMainIndex]!,
            selectedIndex: widget.selectedSubIndex,
            onDestinationSelected: (index) {
              widget.onSubItemSelected(index);
            },
          ),
      ],
    );
  }
}