//Ahmet Talha Biçer-Erciyes Üniversitesi-Bilgisayar Mühendisliği-Mobile Application Development-Fehim Köylü
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // yerel depolama için gerekli kütüphane

class CheckboxFormPage extends StatefulWidget {
  const CheckboxFormPage({super.key});

  @override
  State<CheckboxFormPage> createState() => _CheckboxFormPageState();
}

class _CheckboxFormPageState extends State<CheckboxFormPage>
    with SingleTickerProviderStateMixin {
  // Kontrol edeceğimiz seçimler
  bool isJavaSelected = false;
  bool isPythonSelected = false;
  bool isFlutterSelected = false;
  bool isReactSelected = false;

  // Sayfa yüklenirken
  bool _isLoading = true;

  // Animasyon kontrolcüsü
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animasyon kontrolcüsü
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Uygulama başladığında kaydedilmiş verileri yükle
    _loadSavedPreferences();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

    // Animasyonu başlat
    _animationController.forward();
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
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            const Text('Tercihleriniz kaydedildi'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        elevation: 4,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Programlama Tercihleri'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Uygulama Hakkında'),
                      content: const Text(
                        'Bu uygulama, programlama dili tercihlerinizi kaydetmenize olanak tanır.\n\n'
                        'Erciyes Üniversitesi\nBilgisayar Mühendisliği\nMobile Application Development',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Kapat'),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Tercihleriniz Yükleniyor...',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              )
              : FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.blue.shade50, Colors.white],
                      stops: const [0.0, 0.3],
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 24),
                          _buildCheckboxes(primaryColor, isDark),
                          const SizedBox(height: 32),
                          _buildSaveButton(primaryColor),
                          const SizedBox(height: 32),
                          _buildSelectedSection(primaryColor, isDark),
                        ],
                      ),
                    ),
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.blue.shade100, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.code, color: Colors.blue.shade700, size: 28),
              const SizedBox(width: 12),
              const Text(
                'Programlama Tercihleri',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Hangi programlama dillerini/frameworkleri biliyorsunuz?',
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxes(Color primaryColor, bool isDark) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Column(
          children: [
            _buildCheckboxTile(
              title: 'Java',
              value: isJavaSelected,
              onChanged:
                  (value) => setState(() => isJavaSelected = value ?? false),
              icon: Icons.code,
              primaryColor: primaryColor,
              isDark: isDark,
              subtitle: 'Nesne yönelimli programlama dili',
            ),
            _buildDivider(),
            _buildCheckboxTile(
              title: 'Python',
              value: isPythonSelected,
              onChanged:
                  (value) => setState(() => isPythonSelected = value ?? false),
              icon: Icons.data_object,
              primaryColor: primaryColor,
              isDark: isDark,
              subtitle: 'Genel amaçlı programlama dili',
            ),
            _buildDivider(),
            _buildCheckboxTile(
              title: 'Flutter',
              value: isFlutterSelected,
              onChanged:
                  (value) => setState(() => isFlutterSelected = value ?? false),
              icon: Icons.flutter_dash,
              primaryColor: primaryColor,
              isDark: isDark,
              subtitle: 'Cross-platform UI framework',
            ),
            _buildDivider(),
            _buildCheckboxTile(
              title: 'React',
              value: isReactSelected,
              onChanged:
                  (value) => setState(() => isReactSelected = value ?? false),
              icon: Icons.web,
              primaryColor: primaryColor,
              isDark: isDark,
              subtitle: 'JavaScript kütüphanesi',
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
    required Color primaryColor,
    required bool isDark,
    required String subtitle,
  }) {
    return CheckboxListTile(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  value ? primaryColor.withOpacity(0.2) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: value ? primaryColor : Colors.grey.shade600,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: value ? primaryColor : null,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
      value: value,
      onChanged: onChanged,
      activeColor: primaryColor,
      checkColor: Colors.white,
      controlAffinity: ListTileControlAffinity.trailing,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      tileColor: value ? primaryColor.withOpacity(0.05) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      indent: 16,
      endIndent: 16,
      color: Colors.grey.shade300,
    );
  }

  Widget _buildSaveButton(Color primaryColor) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: _savePreferences,
        icon: const Icon(Icons.save),
        label: const Text(
          'Tercihleri Kaydet',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: primaryColor.withOpacity(0.4),
        ),
      ),
    );
  }

  Widget _buildSelectedSection(Color primaryColor, bool isDark) {
    final hasSelectedItems =
        isJavaSelected ||
        isPythonSelected ||
        isFlutterSelected ||
        isReactSelected;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline, color: primaryColor),
              const SizedBox(width: 10),
              const Text(
                'Seçilen Teknolojiler',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 20),
          hasSelectedItems
              ? _buildSelectedItemsGrid(primaryColor)
              : Column(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.grey.shade500,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Henüz bir teknoloji seçilmedi',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bildiğiniz teknolojileri yukarıdan seçebilirsiniz',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
        ],
      ),
    );
  }

  Widget _buildSelectedItemsGrid(Color primaryColor) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        if (isJavaSelected)
          _buildSelectedChip('Java', Icons.code, primaryColor),
        if (isPythonSelected)
          _buildSelectedChip('Python', Icons.data_object, primaryColor),
        if (isFlutterSelected)
          _buildSelectedChip('Flutter', Icons.flutter_dash, primaryColor),
        if (isReactSelected)
          _buildSelectedChip('React', Icons.web, primaryColor),
      ],
    );
  }

  Widget _buildSelectedChip(String label, IconData icon, Color primaryColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: primaryColor.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: primaryColor, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
