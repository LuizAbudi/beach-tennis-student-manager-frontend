import 'package:flutter/material.dart';

class LevelSelector extends StatefulWidget {
  final List<String> levels;
  final Function(String) onSelectedLevelChanged;

  const LevelSelector({
    super.key,
    required this.levels,
    required this.onSelectedLevelChanged,
  });

  @override
  LevelSelectorState createState() => LevelSelectorState();
}

class LevelSelectorState extends State<LevelSelector> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nível',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: widget.levels.asMap().entries.map((entry) {
            int index = entry.key;
            String level = entry.value;
            bool isSelected = _selectedIndex == index;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                  widget.onSelectedLevelChanged(level);
                },
                child: Container(
                  margin: EdgeInsets.only(
                    left: index == 0
                        ? 0.0
                        : 4.0, // Sem margem para o primeiro botão
                    right: 4.0, // Margem à direita para todos os botões
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? const Color.fromRGBO(255, 98, 62, 1)
                          : Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: Text(
                      level,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
