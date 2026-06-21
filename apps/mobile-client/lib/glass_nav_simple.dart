import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

/// Standalone prototype for iOS Liquid Glass bottom navigation
/// Run with: flutter run -t lib/glass_nav_simple.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiquidGlassWidgets.initialize();
  runApp(const GlassNavSimple());
}

class GlassNavSimple extends StatelessWidget {
  const GlassNavSimple({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glass Nav Simple',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: _GlassScaffoldExample(),
    );
  }
}

class _GlassScaffoldExample extends StatefulWidget {
  const _GlassScaffoldExample({super.key});

  @override
  State<_GlassScaffoldExample> createState() => _GlassScaffoldExampleState();
}

class _GlassScaffoldExampleState extends State<_GlassScaffoldExample> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      background: const _GradientBackground(),
      statusBarStyle: GlassStatusBarStyle.light,
      appBar: GlassAppBar(
        title: const Text('Glass Navigation Prototype'),
        backgroundColor: Colors.transparent,
        actions: [
          GlassIconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      bottomBar: GlassBottomBar(
        selectedIndex: _selectedIndex,
        adaptiveBrightness: true,
        onBrightnessChanged: (brightness) {
          debugPrint('Bottom bar brightness: $brightness');
        },
        onTabSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        tabs: const [
          GlassBottomBarTab(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          GlassBottomBarTab(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
          GlassBottomBarTab(
            icon: Icon(Icons.favorite_outlined),
            label: 'Saved',
          ),
          GlassBottomBarTab(
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
        ],
      ),
      body: const _ScrollableContent(),
    );
  }
}

class _GradientBackground extends StatelessWidget {
  const _GradientBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF8A2BE2), // Blue Violet
            Color(0xFF4B0082), // Indigo
            Color(0xFF000080), // Navy
          ],
        ),
      ),
    );
  }
}

class _ScrollableContent extends StatelessWidget {
  const _ScrollableContent();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      itemCount: 25,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _SalonCardRow(),
              SizedBox(height: 12),
              _SalonDescription(),
            ],
          ),
        );
      },
    );
  }
}

class _SalonCardRow extends StatelessWidget {
  const _SalonCardRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _SalonIcon(),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SalonName(),
              _SalonSubtitle(),
            ],
          ),
        ),
        _RatingRow(),
      ],
    );
  }
}

class _SalonIcon extends StatelessWidget {
  const _SalonIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class _SalonName extends StatelessWidget {
  const _SalonName();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Salon Name',
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _SalonSubtitle extends StatelessWidget {
  const _SalonSubtitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Hair Salon • 1.2 km',
      style: TextStyle(
        color: Colors.white.withOpacity(0.7),
        fontSize: 12,
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 20,
        ),
        SizedBox(width: 4),
        Text(
          '4.8',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _SalonDescription extends StatelessWidget {
  const _SalonDescription();

  @override
  Widget build(BuildContext context) {
    return Text(
      'This is a sample salon card that scrolls behind the glass navigation bar. The glass bar adapts its icon color based on the content scrolling behind it.',
      style: TextStyle(
        color: Colors.white.withOpacity(0.85),
        fontSize: 13,
        height: 1.5,
      ),
    );
  }
}