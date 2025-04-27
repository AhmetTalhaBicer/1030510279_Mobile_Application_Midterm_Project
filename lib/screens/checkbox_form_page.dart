import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // yerel depolama için gerekli kütüphane

class CheckboxFormPage extends StatefulWidget {
  const CheckboxFormPage({super.key});

  @override
  State<CheckboxFormPage> createState() => _CheckboxFormPageState();
}

class _CheckboxFormPageState extends State<CheckboxFormPage> {
  // Kontrol edeceğimiz seçimler
  bool isJavaSelected = false;
  bool isPythonSelected = false;
  bool isFlutterSelected = false;
  bool isReactSelected = false;

  // Sayfa yüklenirken
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Uygulama başladığında kaydedilmiş verileri yükle
    _loadSavedPreferences();
  }

  // Kaydedilmiş verileri yükle
  Future<void> _loadSavedPreferences() async {
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isJavaSelected = prefs.getBool('java') ?? false;
      isPythonSelected = prefs.getBool('python') ?? false;
      isFlutterSelected = prefs.getBool('flutter') ?? false;
      isReactSelected = prefs.getBool('react') ?? false;
      _isLoading = false;
    });
  }

  // Seçimleri kaydet
  Future<void> _savePreferences() async {
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('java', isJavaSelected);
    await prefs.setBool('python', isPythonSelected);
    await prefs.setBool('flutter', isFlutterSelected);
    await prefs.setBool('react', isReactSelected);

    setState(() => _isLoading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Tercihleriniz kaydedildi'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Programlama Tercihleri'), elevation: 0),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 24),
                      _buildCheckboxes(),
                      const SizedBox(height: 32),
                      _buildSaveButton(),
                      const SizedBox(height: 32),
                      _buildSelectedSection(),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Text(
        'Hangi programlama dillerini/frameworkleri biliyorsunuz?',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCheckboxes() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            _buildCheckboxTile(
              title: 'Java',
              value: isJavaSelected,
              onChanged:
                  (value) => setState(() => isJavaSelected = value ?? false),
              icon: Icons.code,
            ),
            _buildDivider(),
            _buildCheckboxTile(
              title: 'Python',
              value: isPythonSelected,
              onChanged:
                  (value) => setState(() => isPythonSelected = value ?? false),
              icon: Icons.data_object,
            ),
            _buildDivider(),
            _buildCheckboxTile(
              title: 'Flutter',
              value: isFlutterSelected,
              onChanged:
                  (value) => setState(() => isFlutterSelected = value ?? false),
              icon: Icons.flutter_dash,
            ),
            _buildDivider(),
            _buildCheckboxTile(
              title: 'React',
              value: isReactSelected,
              onChanged:
                  (value) => setState(() => isReactSelected = value ?? false),
              icon: Icons.web,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxTile({
    required String title,
    required bool value,
    required Function(bool?) onChanged,
    required IconData icon,
  }) {
    return CheckboxListTile(
      title: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.blue,
      checkColor: Colors.white,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 16, endIndent: 16);
  }

  Widget _buildSaveButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: _savePreferences,
        icon: const Icon(Icons.save),
        label: const Text('Tercihleri Kaydet', style: TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildSelectedSection() {
    final hasSelectedItems =
        isJavaSelected ||
        isPythonSelected ||
        isFlutterSelected ||
        isReactSelected;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          const Text(
            'Seçilen Teknolojiler',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          hasSelectedItems
              ? Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  if (isJavaSelected) _buildSelectedChip('Java'),
                  if (isPythonSelected) _buildSelectedChip('Python'),
                  if (isFlutterSelected) _buildSelectedChip('Flutter'),
                  if (isReactSelected) _buildSelectedChip('React'),
                ],
              )
              : const Text(
                'Henüz bir teknoloji seçilmedi',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildSelectedChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.blue.shade100,
      labelStyle: const TextStyle(color: Colors.black87),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      avatar: const Icon(Icons.check_circle, color: Colors.blue, size: 16),
      elevation: 2,
      shadowColor: Colors.grey.shade300,
    );
  }
}
