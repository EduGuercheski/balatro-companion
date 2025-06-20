import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ActivityLogPage extends StatefulWidget {
  const ActivityLogPage({super.key});

  @override
  State<ActivityLogPage> createState() => _ActivityLogPageState();
}

class _ActivityLogPageState extends State<ActivityLogPage> {
  // 1. Novas variáveis de estado para a seleção de usuário
  bool _isUsersLoading = true;
  String? _selectedUserId;
  List<Map<String, dynamic>> _allUsers = [];

  // Variáveis de estado para os logs do usuário selecionado
  bool _isLogsLoading = false;
  String? _errorMessage;
  final _searchController = TextEditingController();
  List<QueryDocumentSnapshot> _allLogsForUser = [];
  List<QueryDocumentSnapshot> _filteredLogsForUser = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Agora, iniciamos buscando a lista de usuários
    _searchController.addListener(_filterLogs);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  // 3. A função de buscar logs agora aceita um userId
  Future<void> _fetchLogsForUser(String userId) async {
    setState(() {
      _isLogsLoading = true;
      _errorMessage = null;
      _allLogsForUser = []; // Limpa os logs antigos
      _filteredLogsForUser = [];
    });

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('activity_logs')
          .where('userId', isEqualTo: userId) // <-- O FILTRO PRINCIPAL
          .orderBy('timestamp', descending: true)
          .limit(500)
          .get();

      setState(() {
        _allLogsForUser = querySnapshot.docs;
        _filteredLogsForUser = List.from(_allLogsForUser);
      });
    } catch (e) {
      setState(() => _errorMessage = 'Falha ao carregar os logs do usuário.');
    } finally {
      setState(() => _isLogsLoading = false);
    }
  }

  // A função de filtro agora opera na lista de logs do usuário selecionado
  void _filterLogs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLogsForUser = _allLogsForUser.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final action = (data['action'] as String? ?? '').toLowerCase();
        // Filtra pela ação, já que o usuário já foi pré-selecionado
        return action.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 4. Área de seleção do usuário
        _buildUserSelector(),
        const Divider(height: 1, thickness: 1),
        // 5. Área de exibição dos logs
        Expanded(
          child: _buildLogsDisplay(),
        ),
      ],
    );
  }

  // Widget para o dropdown de seleção de usuário
  Widget _buildUserSelector() {
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
            _fetchLogsForUser(value); // Busca os logs quando um usuário é selecionado
          }
        },
        decoration: const InputDecoration(
          labelText: 'Usuário',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  // Widget que exibe a barra de busca e a lista de logs
  Widget _buildLogsDisplay() {
    // Se nenhum usuário foi selecionado ainda
    if (_selectedUserId == null) {
      return const Center(child: Text('Nenhum usuário selecionado.'));
    }
    // Se os logs do usuário estiverem carregando
    if (_isLogsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    // Se houve erro ao carregar os logs
    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }
    // Se não houver logs para o usuário selecionado
    if (_filteredLogsForUser.isEmpty) {
      return const Center(child: Text('Nenhum log de atividade para este usuário.', style: TextStyle(color: Colors.white),));
    }

    // Se tudo deu certo, mostra a busca e a lista
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Filtrar por ação...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
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

  // Widget que constrói cada item da lista de logs
  Widget _buildLogListItem(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final action = data['action'] as String? ?? 'Ação desconhecida';
    final detailsMap = data['details'] as Map<String, dynamic>? ?? {};
    final detailsString = detailsMap.values.join(', ');
    final formattedTimestamp = _formatTimestamp(data['timestamp'] as Timestamp?);
    final subtitleText = detailsString.isNotEmpty
        ? 'Detalhes: $detailsString\n$formattedTimestamp'
        : formattedTimestamp;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Icon(_getIconForAction(action), color: const Color(0xFF4F7768)),
        title: Text(
          action,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        // 3. Usa a nova string formatada no subtítulo.
        subtitle: Text(subtitleText),
        isThreeLine: detailsString.isNotEmpty,
      ),
    );
  }

  // As funções _formatTimestamp e _getIconForAction permanecem as mesmas
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Data indisponível';
    return DateFormat('dd/MM/yyyy HH:mm').format(timestamp.toDate());
  }

  IconData _getIconForAction(String action) {
    switch (action) {
      case 'card_viewed': return Icons.visibility;
      case 'category_searched': return Icons.search;
      default: return Icons.history;
    }
  }
}