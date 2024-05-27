import 'package:flutter/material.dart';

class MemoryVaultPage extends StatefulWidget {
  const MemoryVaultPage({super.key});

  @override
  State<MemoryVaultPage> createState() => _MemoryVaultPageState();
}

class _MemoryVaultPageState extends State<MemoryVaultPage> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          "Memory vault",
          style: TextStyle(color: Colors.white),
        ),
      ),
    ));
  }
}
