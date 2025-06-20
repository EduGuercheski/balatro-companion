// lib/detail_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import '../services/activity_log_service.dart';
import '../services/cloud_firestore.dart';
import '../utils/helpers.dart';
import 'item_description_screen.dart';

class DetailScreen extends StatefulWidget {
  final String title;
  const DetailScreen({super.key, required this.title});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _searchController = TextEditingController();
  final _firestoreService = FirestoreService();
  final _logService = ActivityLogService();

  // Listas para a lógica de busca
  List<Map<String, dynamic>> _originalItems = [];
  List<Map<String, dynamic>> _filteredItems = [];

  // Variáveis para controlar os estados de carregamento e erro
  bool _isLoading = true;
  String? _errorMessage;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged); // <-- MUDOU PARA ESTA FUNÇÃO
    _fetchItems();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged); // Já deve estar com o nome novo
    _searchController.dispose();
    _debounce?.cancel(); // <-- ADICIONE ESTA LINHA
    super.dispose();
  }

  void _onSearchChanged() {
    // 1. O filtro da UI continua instantâneo para uma boa experiência do usuário
    _filterItems();

    // 2. A lógica do "debounce" para o logging
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Este código só roda 500ms depois que o usuário para de digitar
    });
  }

  // Função que busca os dados do Firestore QUANDO A TELA INICIA
  Future<void> _fetchItems() async {
    try {
      final collectionName = _getCollectionNameFromTitle(widget.title);
      final items = await _firestoreService.getItemsForCategory(collectionName);

      // Quando os dados chegam, atualizamos o estado
      setState(() {
        _originalItems = items;
        _filteredItems = List.from(_originalItems);
        _isLoading = false;
      });
    } catch (e) {
      // Em caso de erro, também atualizamos o estado
      setState(() {
        _errorMessage = 'Falha ao carregar as cartas.';
        _isLoading = false;
      });
    }
  }

  // A mesma função de filtro de antes, agora operando sobre os dados do estado
  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _originalItems.where((item) {
        final cardName = (item['name'] as String).toLowerCase();
        return cardName.contains(query);
      }).toList();
    });
  }

  String _getCollectionNameFromTitle(String screenTitle) {
    const categoryMap = {
      'Baralhos': 'Baralhos',
      'Coringas': 'Coringas',
      'Cartas de Tarô': 'Cartas de Tarô',
      'Cartas Celestiais': 'Cartas Celestiais',
      'Cartas Espectrais': 'Cartas Espectrais',
    };
    return categoryMap[screenTitle] ?? 'default';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4F7768),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF4F7768),
      // 4. O body agora verifica os estados de carregamento e erro ANTES de construir a UI
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!, style: const TextStyle(color: Colors.white)));
    }

    return Column(
      children: [
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
              crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.75,
            ),
            itemCount: _filteredItems.length,
            itemBuilder: (context, index) {
              final item = _filteredItems[index];
              return _buildGridItem(context, item);
            },
          ),
        ),
      ],
    );
  }

  // O _buildGridItem permanece idêntico
  Widget _buildGridItem(BuildContext context, Map<String, dynamic> item) {
    final cardName = item['name'] as String;
    final imagePath = generateImagePath(widget.title, cardName);

    return Card(
      // ... (código do card inalterado)
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      color: const Color(0xFF426458),
      child: InkWell(
        onTap: () {
          _logService.logCardView(cardName: cardName, category: widget.title);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemDescriptionScreen(
                itemName: cardName,
                itemDescription: item['description'] as String,
                itemImagePath: imagePath,
              ),
            ),
          );
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned.fill(
              child: Image.asset(imagePath, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 50)),
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withOpacity(0.8), Colors.black.withOpacity(0.0)]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                cardName,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, shadows: [Shadow(blurRadius: 2.0, color: Colors.black)]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}