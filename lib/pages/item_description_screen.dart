// lib/item_description_screen.dart
import 'package:flutter/material.dart';

class ItemDescriptionScreen extends StatelessWidget {
  final String itemName;
  final String itemDescription;
  final String itemImagePath;

  const ItemDescriptionScreen({
    super.key,
    required this.itemName,
    required this.itemDescription,
    required this.itemImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4F7768),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white, // Define que a cor dos ícones (incluindo a seta) será branca
        ),
      ),
      backgroundColor: const Color(0xFF4F7768),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagem em destaque
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  itemImagePath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              // Título
              Text(
                itemName,
                style: const TextStyle(
                  fontSize: 28, // Um pouco maior para dar mais destaque
                  fontWeight: FontWeight.bold,
                  // 2. Cor do texto alterada para branco
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              // Descrição
              Text(
                itemDescription,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.5, // Espaçamento entre linhas para melhor leitura
                  // Cor do texto alterada para um branco levemente opaco
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}