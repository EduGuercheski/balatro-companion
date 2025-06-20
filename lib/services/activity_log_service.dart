// lib/services/activity_log_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ActivityLogService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Método privado genérico para evitar repetição de código
  Future<void> _logActivity(String action, Map<String, dynamic> details) async {
    final currentUser = _auth.currentUser;

    // Só registra a atividade se houver um usuário logado
    if (currentUser == null) {
      print("Nenhum usuário logado, atividade não registrada.");
      return;
    }

    try {
      // Adiciona um novo documento à coleção 'activity_logs'
      await _db.collection('activity_logs').add({
        'userId': currentUser.uid,
        'userEmail': currentUser.email,
        'action': action,
        'details': details,
        'timestamp': FieldValue.serverTimestamp(), // Usa o timestamp do servidor
      });
    } catch (e) {
      print("Erro ao registrar atividade: $e");
      // Em um app de produção, você poderia usar um logger mais sofisticado
    }
  }

  /// Registra a visualização de uma carta específica.
  void logCardView({required String cardName, required String category}) {
    _logActivity('card_viewed', {
      'cardName': cardName,
      'category': category,
    });
  }

  /// Registra um termo que foi pesquisado em uma categoria.
  void logCategorySearch({required String searchTerm, required String category}) {
    // Não registra buscas vazias
    if (searchTerm.trim().isEmpty) return;

    _logActivity('category_searched', {
      'searchTerm': searchTerm,
      'category': category,
    });
  }

  Future<void> logUserLogin() async {
    await _logActivity('user_login', {});
  }
}