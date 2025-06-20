import 'package:flutter/material.dart';

import 'detail_screen.dart';

// Classe principal que você já tinha, agora com os cards
class StandardArea extends StatelessWidget {
  const StandardArea({super.key});

  // Lista de dados para os cards.
  // Manter os dados separados da UI é uma boa prática.
  final List<Map<String, dynamic>> _cardItems = const [
    {
      'icon': Icons.style, // Ícone que se assemelha a um leque de cartas
      'title': 'Baralhos',
    },
    {
      'icon': Icons.sentiment_very_satisfied, // Ícone de um "Joker" ou coringa
      'title': 'Coringas',
    },
    {
      'icon': Icons.visibility, // Ícone de "visão" ou "clarividência" para o Tarô
      'title': 'Cartas de Tarô',
    },
    {
      'icon': Icons.auto_awesome, // Ícone de estrelas/brilho para Celestial
      'title': 'Cartas Celestiais',
    },
    {
      'icon': Icons.blur_on, // Ícone abstrato para Espectral
      'title': 'Cartas Espectrais',
    },
  ];


  @override
  Widget build(BuildContext context) {
    // Usamos o mesmo Scaffold e cor de fundo para manter a identidade
    return Scaffold(
      backgroundColor: const Color(0xFF4F7768),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // GridView.builder é eficiente para criar grades com muitos itens
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 colunas
            crossAxisSpacing: 16, // Espaçamento horizontal entre os cards
            mainAxisSpacing: 16, // Espaçamento vertical entre os cards
            childAspectRatio: 1.2, // Proporção do card (largura / altura)
          ),
          itemCount: _cardItems.length,
          itemBuilder: (context, index) {
            final item = _cardItems[index];
            return _buildCardItem(
              context: context,
              icon: item['icon'],
              title: item['title'],
            );
          },
        ),
      ),
    );
  }

  // Widget para construir cada card individualmente
  Widget _buildCardItem({
    required BuildContext context,
    required IconData icon,
    required String title,
  }) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell( // Adiciona o efeito de "splash" ao tocar
        onTap: () {
          // Ação de navegação ao tocar no card
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(title: title),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: const Color(0xFF4F7768)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
