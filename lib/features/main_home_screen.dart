import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'screens.dart';

@RoutePage()
class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> widgetOptions = const [
    HomeScreen(),
    MoviesScreen(),
    TvShowsScreen(),
    ActorsScreen(),
    SearchScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Movies'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TalkerScreen(talker: GetIt.I<Talker>()),
                ),
              );
            },
            icon: Icon(Icons.document_scanner_outlined),
          ),
        ],
      ),
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: _CustomBottomBar(
        index: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}


class _CustomBottomBar extends StatelessWidget {
  final int index;
  final Function(int) onTap;
  const _CustomBottomBar({required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final selectedColor = Color(0xFF92B9F5);
    final unselectedColor = Colors.blueGrey[200]!;
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: Color(0xFF22232A),
        border: Border(top: BorderSide(color: Colors.black26)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            _BottomBarItem(
              icon: Icons.home,
              label: "Home",
              selected: index == 0,
              onTap: () => onTap(0),
              selectedColor: selectedColor,
              unselectedColor: unselectedColor,
            ),
            _BottomBarItem(
              icon: Icons.local_movies,
              label: "Movies",
              selected: index == 1,
              onTap: () => onTap(1),
              selectedColor: selectedColor,
              unselectedColor: unselectedColor,
            ),
            _BottomBarItem(
              icon: Icons.tv,
              label: "TV Shows",
              selected: index == 2,
              onTap: () => onTap(2),
              selectedColor: selectedColor,
              unselectedColor: unselectedColor,
            ),
            _BottomBarItem(
              icon: Icons.people,
              label: "People",
              selected: index == 3,
              onTap: () => onTap(3),
              selectedColor: selectedColor,
              unselectedColor: unselectedColor,
            ),
            _BottomBarItem(
              icon: Icons.search,
              label: "Search",
              selected: index == 4,
              onTap: () => onTap(4),
              selectedColor: selectedColor,
              unselectedColor: unselectedColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color unselectedColor;
  const _BottomBarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.selectedColor,
    required this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 2),
              Container(
                width: 64,
                height: 30,
                decoration: selected
                    ? BoxDecoration(
                  color: selectedColor.withAlpha(38),
                  borderRadius: BorderRadius.circular(20),
                )
                    : null,
                padding: const EdgeInsets.all(2.0),
                child: Icon(
                  icon,
                  color: selected ? selectedColor : unselectedColor,
                  size: 24,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: selected ? selectedColor : unselectedColor,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
