import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'detail_screen.dart'; // Mantenha sua importação para a tela de detalhes

// ===================================================================
// DADOS DO JOGO - Incluídos aqui para o exemplo ser completo
// ===================================================================
const Map<String, List<Map<String, String>>> gameData = {
  'Cartas de Tarô': [
    {'name': 'A Carruagem', 'description': 'Melhora 1 carta selecionada em uma Carta de Aço.'},
    // ... cole o resto dos seus dados aqui
  ],
  'Cartas Espectrais': [
    {'name': 'A Alma', 'description': 'Cria um Coringa Lendário (necessário espaço para armazená-lo).'},
    // ...
  ],
  'Baralhos': [
    {'name': 'Baralho Abandonado', 'description': 'Comece a tentativa sem Cartas de Realeza no seu baralho.'},
    // ...
  ],
  'Coringas': [
    {'name': '9dades', 'description': 'Descrição do coringa 9dades...'},
    // ...
  ],
  'Cartas Celestiais': [
    {'name': 'Ceres', 'description': 'Subir de nível, Flush House, +4 Multi e +40 fichas.'},
    // ...
  ],
};


// ===================================================================
// LÓGICA DE UPLOAD PARA O FIRESTORE
// ===================================================================
class FirestoreUploader {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadGameData() async {
    final WriteBatch batch = _firestore.batch();

    // Verifica se os dados não estão vazios antes de prosseguir
    if (gameData.isEmpty || gameData.values.every((list) => list.isEmpty)) {
      throw Exception("gameData está vazio. Não há nada para enviar.");
    }

    for (var entry in gameData.entries) {
      String collectionName = entry.key;
      List<Map<String, String>> documents = entry.value;
      CollectionReference collection = _firestore.collection(collectionName);

      print('Preparando o upload para a coleção: $collectionName');

      for (var docData in documents) {
        // Usa o nome da carta como ID do documento para evitar duplicatas
        // Se o nome não for único, use collection.doc() para gerar IDs automáticos
        DocumentReference docRef = collection.doc(docData['name']);
        batch.set(docRef, docData);
      }
    }

    await batch.commit();
  }
}

// ===================================================================
// WIDGET DA TELA PRINCIPAL - Agora com o botão de upload
// ===================================================================
class StandardArea extends StatelessWidget {
  const StandardArea({super.key});

  final List<Map<String, dynamic>> _cardItems = const [
    {'icon': Icons.style, 'title': 'Baralhos'},
    {'icon': Icons.sentiment_very_satisfied, 'title': 'Coringas'},
    {'icon': Icons.visibility, 'title': 'Cartas de Tarô'},
    {'icon': Icons.auto_awesome, 'title': 'Cartas Celestiais'},
    {'icon': Icons.blur_on, 'title': 'Cartas Espectrais'},
  ];

  void _handleUpload(BuildContext context) {
    // Exibe uma notificação de que o processo começou
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Iniciando envio para o Firestore...'),
        backgroundColor: Colors.blue,
      ),
    );

    final uploader = FirestoreUploader();
    uploader.uploadGameData().then((_) {
      // Exibe uma notificação de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dados enviados com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      // Exibe uma notificação de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Falha no envio: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4F7768),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
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
      // NOVO: FloatingActionButton para o upload
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleUpload(context),
        tooltip: 'Enviar Dados para Firestore',
        backgroundColor: const Color(0xFFD3A165), // Uma cor de destaque
        child: const Icon(Icons.cloud_upload),
      ),
    );
  }

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
      child: InkWell(
        onTap: () {
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