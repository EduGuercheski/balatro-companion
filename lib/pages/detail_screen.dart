// lib/detail_screen.dart
import 'package:flutter/material.dart';
import '../data/game_data.dart';
import '../utils/helpers.dart';
import 'item_description_screen.dart';

// 1. Convertemos para StatefulWidget
class DetailScreen extends StatefulWidget {
  final String title;
  const DetailScreen({super.key, required this.title});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // 2. Variáveis de estado para controlar a busca e a lista
  late final TextEditingController _searchController;
  late List<Map<String, String>> _originalItems;
  late List<Map<String, String>> _filteredItems;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    // Carrega a lista original de itens uma vez
    _originalItems = gameData[widget.title] ?? [];
    // Inicialmente, a lista filtrada é igual à original
    _filteredItems = List.from(_originalItems);

    // Adiciona um "ouvinte" que chama a função de filtro sempre que o texto muda
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    // Limpa o controller para evitar vazamentos de memória
    _searchController.removeListener(_filterItems);
    _searchController.dispose();
    super.dispose();
  }

  // 3. Lógica para filtrar os itens
  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _originalItems.where((item) {
        final cardName = item['name']!.toLowerCase();
        return cardName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4F7768),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFF4F7768),
      // 4. O body agora é uma Column para conter a busca e a grade
      body: Column(
        children: [
          // Barra de Busca
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar carta...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF426458),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // 5. A grade agora usa a lista filtrada e está dentro de um Expanded
          Expanded(
            child: _filteredItems.isEmpty
                ? const Center(
              child: Text(
                'Nenhuma carta encontrada.',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return _buildGridItem(context, item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, Map<String, String> item) {
    final cardName = item['name']!;
    // Agora usamos widget.title para acessar a propriedade da classe StatefulWidget
    final imagePath = generateImagePath(widget.title, cardName);

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      color: const Color(0xFF426458),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemDescriptionScreen(
                itemName: cardName,
                itemDescription: item['description']!,
                itemImagePath: imagePath,
              ),
            ),
          );
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned.fill(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported, size: 50);
                },
              ),
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.0),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                cardName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  shadows: [Shadow(blurRadius: 2.0, color: Colors.black)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}