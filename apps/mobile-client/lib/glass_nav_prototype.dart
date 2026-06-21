import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LiquidGlassWidgets.initialize();
  runApp(const GlassNavPrototype());
}

class GlassNavPrototype extends StatefulWidget {
  const GlassNavPrototype({super.key});

  @override
  State<GlassNavPrototype> createState() => _GlassNavPrototypeState();
}

class _GlassNavPrototypeState extends State<GlassNavPrototype> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glass Navigation Prototype',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: GlassScaffold(
        background: const _DemoBackground(),
        statusBarStyle: GlassStatusBarStyle.light,
        appBar: GlassAppBar(
          title: const Text('Glass Navigation Prototype'),
          backgroundColor: Colors.transparent,
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
        body: const _DemoContent(),
      ),
    );
  }
}

class _DemoBackground extends StatelessWidget {
  const _DemoBackground();

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

class _DemoContent extends StatelessWidget {
  const _DemoContent();

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
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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