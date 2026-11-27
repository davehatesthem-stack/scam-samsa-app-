import 'dart:convert';
import 'package:dasturnomi/src/core/const/appcolors.dart';
import 'package:dasturnomi/src/core/model/samsa_model.dart';
import 'package:dasturnomi/src/features/admin/admin_home/provider/home_provider.dart';
import 'package:dasturnomi/src/features/admin/admin_home/widgets/TopAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _apiUrl =
      'https://6b043efc9e7cafb37dc01ceb.mockapi.io/samsa';
  List<SamsaModel> allSamsas = [];
  List<SamsaModel> filteredSamsas = [];
  bool isLoading = true;
  int currentTab = 0;

  @override
  void initState() {
    super.initState();
    _fetchSamsas();
  }

  Future<void> _fetchSamsas() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> decoded = json.decode(response.body);
        final items = decoded.map((e) => SamsaModel.fromJson(e)).toList();
        setState(() {
          allSamsas = items;
          filteredSamsas = items;
          isLoading = false;
        });
      }
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  void _onSearch(String query) {
    final q = query.toLowerCase();
    setState(() {
      filteredSamsas = allSamsas.where((item) {
        return item.name.toLowerCase().contains(q) ||
            item.ingredients.toLowerCase().contains(q);
      }).toList();
    });
  }

  Future<void> deleteSamsa(String id) async {
    await http.delete(Uri.parse('$_apiUrl/$id'));
    _fetchSamsas();
  }

  void _showAddSamsaDialog() {
    final nameController = TextEditingController();
    final ingredientsController = TextEditingController();
    final doughController = TextEditingController();
    final qualityController = TextEditingController(text: 'Freshly Baked');
    final priceController = TextEditingController();
    bool isSaving = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add samsa type',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: darkText,
                            fontFamily: 'Serif',
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: mutedText),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDialogField(
                      'Samsa Name',
                      'e.g. Beef & Onion',
                      nameController,
                    ),
                    const SizedBox(height: 12),
                    _buildDialogField(
                      'Ingredients',
                      'e.g. Beef, onion, cumin',
                      ingredientsController,
                    ),
                    const SizedBox(height: 12),
                    _buildDialogField(
                      'Dough Type',
                      'e.g. Puff pastry',
                      doughController,
                    ),
                    const SizedBox(height: 12),
                    _buildDialogField(
                      'Quality Badge',
                      'e.g. Freshly Baked',
                      qualityController,
                    ),
                    const SizedBox(height: 12),
                    _buildDialogField(
                      'Price',
                      'e.g. 15,000 UZS',
                      priceController,
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isSaving
                            ? null
                            : () async {
                                if (nameController.text.trim().isEmpty) return;
                                setDialogState(() => isSaving = true);

                                await http.post(
                                  Uri.parse(_apiUrl),
                                  headers: {'Content-Type': 'application/json'},
                                  body: json.encode({
                                    'name': nameController.text.trim(),
                                    'ingredients': ingredientsController.text
                                        .trim(),
                                    'dough': doughController.text.trim(),
                                    'quality': qualityController.text.trim(),
                                    'price': priceController.text.trim(),
                                  }),
                                );

                                if (context.mounted) Navigator.pop(context);
                                _fetchSamsas();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryOrange,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Save samsa',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDialogField(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: darkText,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: mutedText, fontSize: 14),
            filled: true,
            fillColor: backgroundColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5DDD3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5DDD3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primaryOrange),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        buildTopAppBar(),
                        const SizedBox(height: 24),
                        buildHeroHeader(),
                        const SizedBox(height: 24),
                        buildStatsRow(),
                        const SizedBox(height: 24),
                        const Text(
                          'Your samsa types',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: darkText,
                            fontFamily: 'Serif',
                          ),
                        ),
                        const SizedBox(height: 12),
                        buildSearchBar(),
                        const SizedBox(height: 16),
                        buildSamsaList(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                buildBottomNav(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeroHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Manage samsa',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: darkText,
            fontFamily: 'Serif',
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Add and organize your menu',
          style: TextStyle(
            fontSize: 15,
            color: mutedText,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 18),
        ElevatedButton.icon(
          onPressed: _showAddSamsaDialog,
          icon: const Icon(Icons.add, size: 20, color: Colors.white),
          label: const Text(
            'Add samsa type',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryOrange,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.layers_rounded,
            iconColor: accentAmber,
            title: '${allSamsas.length}',
            subtitle: 'Types',
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _StatCard(
            icon: Icons.monetization_on_rounded,
            iconColor: accentAmber,
            topLabel: 'From',
            title: '13,000 UZS',
          ),
        ),
      ],
    );
  }

  Widget buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5DDD3)),
      ),
      child: TextField(
        onChanged: _onSearch,
        decoration: const InputDecoration(
          hintText: 'Search by type or ingredient...',
          hintStyle: TextStyle(color: mutedText, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: mutedText),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget buildSamsaList() {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(color: primaryOrange),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredSamsas.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final item = filteredSamsas[index];
        return SamsaItemCard(
          item: item,
          onEdit: () {},
          onDelete: () => deleteSamsa(item.id),
        );
      },
    );
  }

  Widget buildBottomNav() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEDE4DA))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavButton(
            icon: Icons.home_rounded,
            label: 'Home',
            isSelected: currentTab == 0,
            onTap: () => setState(() => currentTab = 0),
          ),
          NavButton(
            icon: Icons.settings_rounded,
            label: 'Settings',
            isSelected: currentTab == 1,
            onTap: () => setState(() => currentTab = 1),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final String? topLabel;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.topLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 32),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (topLabel != null)
                Text(
                  topLabel!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B5E55),
                  ),
                ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E1611),
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B5E55),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class SamsaItemCard extends StatelessWidget {
  final SamsaModel item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SamsaItemCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/samsa_pic.png',
                width: 96,
                height: 108,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E1611),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDFF4E1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 13,
                          color: Color(0xFF288B44),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.quality,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF288B44),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/onion.svg',
                        width: 14,
                        height: 14,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Ingredients: ${item.ingredients}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B5E55),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/dough.svg',
                        width: 14,
                        height: 14,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Dough: ${item.dough}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B5E55),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 8, color: Color(0xFFF0EAE1)),
                  Text(
                    item.price,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E1611),
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(
              width: 20,
              thickness: 1,
              color: Color(0xFFF0EAE1),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ActionIconButton(
                  assetPath: 'assets/icons/edit.svg',
                  bgColor: const Color(0xFFF2F2F2),
                  onTap: onEdit,
                ),
                ActionIconButton(
                  assetPath: 'assets/icons/delete.svg',
                  bgColor: const Color(0xFFFCE8E8),
                  onTap: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ActionIconButton extends StatelessWidget {
  final String assetPath;
  final Color bgColor;
  final VoidCallback onTap;

  const ActionIconButton({
    super.key,
    required this.assetPath,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 36,
        height: 36,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SvgPicture.asset(assetPath),
      ),
    );
  }
}

class NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const NavButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? const Color(0xFFE25D20)
        : const Color(0xFF4A423D);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: isSelected ? 64 : 0,
            decoration: BoxDecoration(
              color: const Color(0xFFE25D20),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
