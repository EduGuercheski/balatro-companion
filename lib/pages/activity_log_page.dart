import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ActivityLogPage extends StatefulWidget {
  const ActivityLogPage({super.key});

  @override
  State<ActivityLogPage> createState() => _ActivityLogPageState();
}

class _ActivityLogPageState extends State<ActivityLogPage> {
  // 1. Dicionário de traduções para as ações
  final Map<String, String> _actionTranslations = {
    'card_viewed': 'Cartão Visualizado',
    'user_login': 'Login de Usuário',
    // Adicione outras traduções aqui no futuro
  };

  // Variáveis de estado para a seleção de usuário
  bool _isUsersLoading = true;
  String? _selectedUserId;
  List<Map<String, dynamic>> _allUsers = [];
  String? _errorMessage;

  // Variáveis de estado para os logs e o filtro de AÇÕES
  bool _isLogsLoading = false;
  List<QueryDocumentSnapshot> _allLogsForUser = [];
  List<QueryDocumentSnapshot> _filteredLogsForUser = [];

  List<String> _uniqueActions = [];
  String? _selectedAction;
  static const String _showAllOption = 'Todas as Ações';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 2. Função auxiliar para traduzir uma chave de ação
  String _translateAction(String actionKey) {
    // Se for a opção "Todas as Ações", retorna ela mesma
    if (actionKey == _showAllOption) {
      return _showAllOption;
    }
    // Procura no dicionário, se não encontrar, retorna a chave original
    return _actionTranslations[actionKey] ?? actionKey;
  }

  Future<void> _fetchUsers() async {
    try {
      final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
      _allUsers = usersSnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'email': doc.data()['email'] ?? 'Email desconhecido',
        };
      }).toList();
      _allUsers.sort((a, b) => a['email']!.compareTo(b['email']!));
    } catch (e) {
      _errorMessage = 'Falha ao carregar a lista de usuários.';
    }
    setState(() => _isUsersLoading = false);
  }

  Future<void> _fetchLogsForUser(String userId) async {
    setState(() {
      _isLogsLoading = true;
      _errorMessage = null;
      _allLogsForUser = [];
      _filteredLogsForUser = [];
      _uniqueActions = [];
      _selectedAction = null;
    });

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('activity_logs')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(500)
          .get();

      final actions = querySnapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['action'] as String? ?? 'Ação desconhecida')
          .toSet()
          .toList();
      actions.sort();

      setState(() {
        _allLogsForUser = querySnapshot.docs;
        _filteredLogsForUser = List.from(_allLogsForUser);
        _uniqueActions = [_showAllOption, ...actions];
        _selectedAction = _showAllOption;
      });
    } catch (e) {
      setState(() => _errorMessage = 'Falha ao carregar os logs do usuário.');
    } finally {
      setState(() => _isLogsLoading = false);
    }
  }

  void _applyActionFilter(String? selectedAction) {
    setState(() {
      _selectedAction = selectedAction;
      if (selectedAction == null || selectedAction == _showAllOption) {
        _filteredLogsForUser = List.from(_allLogsForUser);
      } else {
        _filteredLogsForUser = _allLogsForUser.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final action = data['action'] as String? ?? '';
          return action == selectedAction;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildUserSelector(),
        const Divider(height: 1, thickness: 1),
        Expanded(
          child: _buildLogsDisplay(),
        ),
      ],
    );
  }

  Widget _buildUserSelector() {
    // ... (nenhuma mudança aqui)
    if (_isUsersLoading) {
      return const Padding(padding: EdgeInsets.all(16.0), child: Center(child: CircularProgressIndicator()));
    }
    return Container(
      padding: const EdgeInsets.all(12.0),
      color: Colors.grey.shade200,
      child: DropdownButtonFormField<String>(
        value: _selectedUserId,
        hint: const Text('Selecione um usuário para ver os relatórios'),
        isExpanded: true,
        items: _allUsers.map((user) {
          return DropdownMenuItem(
            value: user['id'] as String,
            child: Text(user['email'] as String),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => _selectedUserId = value);
            _fetchLogsForUser(value);
          }
        },
        decoration: const InputDecoration(
          labelText: 'Usuário',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildLogsDisplay() {
    if (_selectedUserId == null) {
      return const Center(child: Text('Selecione um usuário para ver os relatórios.'));
    }
    if (_isLogsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
          child: DropdownButtonFormField<String>(
            value: _selectedAction,
            isExpanded: true,
            items: _uniqueActions.map((actionKey) {
              return DropdownMenuItem(
                value: actionKey,
                // 3. Usa a função de tradução para o texto do item do dropdown
                child: Text(_translateAction(actionKey)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                _applyActionFilter(value);
              }
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.filter_list),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: _filteredLogsForUser.isEmpty
              ? const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Nenhum log encontrado para a ação selecionada.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.only(top: 12.0),
            itemCount: _filteredLogsForUser.length,
            itemBuilder: (context, index) {
              final doc = _filteredLogsForUser[index];
              return _buildLogListItem(doc);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLogListItem(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final actionKey = data['action'] as String? ?? 'Ação desconhecida';
    final detailsMap = data['details'] as Map<String, dynamic>? ?? {};
    final detailsString = detailsMap.values.join(', ');
    final formattedTimestamp = _formatTimestamp(data['timestamp'] as Timestamp?);
    final subtitleText = detailsString.isNotEmpty
        ? 'Detalhes: $detailsString\n$formattedTimestamp'
        : formattedTimestamp;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        // A função do ícone continua usando a chave original, o que é correto
        leading: Icon(_getIconForAction(actionKey), color: const Color(0xFF4F7768)),
        // 4. Usa a função de tradução para o título do ListTile
        title: Text(
          _translateAction(actionKey),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitleText),
        isThreeLine: detailsString.isNotEmpty,
      ),
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Data indisponível';
    return DateFormat('dd/MM/yyyy HH:mm').format(timestamp.toDate());
  }

  IconData _getIconForAction(String actionKey) {
    // A lógica dos ícones permanece com as chaves originais
    switch (actionKey) {
      case 'card_viewed': return Icons.visibility;
      case 'user_login': return Icons.login; // Sugestão de ícone para login
      case 'category_searched': return Icons.search;
      default: return Icons.history;
    }
  }
}