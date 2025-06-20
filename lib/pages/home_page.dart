import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'activity_log_page.dart';
import 'login_page.dart';
import 'standard_area.dart';
import 'vip_area.dart';
import 'role_management_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userRole = '';
  bool isLoading = true;
  User? user;
  Widget? selectedPage;
  String appBarTitle = 'Guias';

  @override
  void initState() {
    super.initState();
    fetchUserRole();
  }

  Future<void> fetchUserRole() async {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      setState(() {
        userRole = doc.data()?['role'] ?? 'standard';
        selectedPage = const StandardArea();
        appBarTitle = 'Guias';
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF4F7768),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF4F7768),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4F7768),
        title: Text(appBarTitle, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF4F7768),
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF4F7768)),
              accountName: Text(userRole.toUpperCase(), style: const TextStyle(color: Colors.white)),
              accountEmail: Text(user?.email ?? 'desconhecido', style: const TextStyle(color: Colors.white)),
              currentAccountPicture: ClipOval(
                child: Image.asset(
                  'assets/images/blackboard.png',
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            _buildDrawerItem(Icons.home, "Guias", () {
              setState(() {
                selectedPage = const StandardArea();
                appBarTitle = "Guias";
              });
              Navigator.pop(context);
            }),
            _buildDrawerItem(
              Icons.calculate,
              "Calculadora de pontuações",
              userRole == 'vip' || userRole == 'admin'
                  ? () {
                setState(() {
                  selectedPage = const VipArea();
                  appBarTitle = "Calculadora de pontuações";
                });
                Navigator.pop(context);
              }
                  : null,
            ),
            if (userRole == 'admin') ...[
              _buildDrawerItem(Icons.manage_accounts, "Gerenciar Papéis", () {
                setState(() {
                  selectedPage = const RoleManagementPage();
                  appBarTitle = "Gerenciar Papéis";
                });
                Navigator.pop(context);
              }),
              // NOVO ITEM DO MENU ADICIONADO AQUI
              _buildDrawerItem(Icons.analytics_outlined, "Relatório de Atividades", () {
                setState(() {
                  selectedPage = const ActivityLogPage();
                  appBarTitle = "Relatório de Atividades";
                });
                Navigator.pop(context);
              }),
            ],
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Sair", style: TextStyle(color: Colors.red)),
              onTap: logout,
            ),
          ],
        ),
      ),
      body: selectedPage ??
          const Center(
            child: Text(
              "Nenhuma página selecionada",
              style: TextStyle(color: Colors.white),
            ),
          ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback? onTap) {
    return ListTile(
      leading: Icon(icon, color: onTap != null ? Colors.white : Colors.grey),
      title: Text(
        title,
        style: TextStyle(color: onTap != null ? Colors.white : Colors.grey),
      ),
      onTap: onTap,
      enabled: onTap != null,
    );
  }
}
