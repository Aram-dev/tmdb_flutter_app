import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final int _bottomIndex = 1;
  late TabController _tabController;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Banner
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                'Ad Banner',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Tabs (Search, Find by ID)
          TabBar(
            controller: _tabController,
            labelColor: Color(0xFF92B9F5),
            unselectedLabelColor: Colors.blueGrey[100],
            indicatorColor: Color(0xFF92B9F5),
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'Search'),
              Tab(text: 'Find by ID'),
            ],
          ),
          // Search Field
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search for a movie, tv show...',
                      hintStyle: TextStyle(color: Colors.blueGrey[200]),
                      filled: true,
                      fillColor: Color(0xFF26272E),
                      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.blueGrey[700]!, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Color(0xFF92B9F5), width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Material(
                  color: Colors.blueGrey[700],
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {}, // implement search
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      child: Text(
                        "Search",
                        style: TextStyle(color: Colors.blueGrey[200], fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // You can add more UI here as needed
        ],
      ),
      // bottomNavigationBar: _CustomBottomBar(
      //   index: _bottomIndex,
      //   onTap: (i) => setState(() => _bottomIndex = i),
      // ),
    );
  }
}

class _CustomTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF22232A),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFF377CCF),
                radius: 24,
                child: Icon(Icons.person, color: Colors.white, size: 30),
              ),
              Spacer(),
              // Image.network(
              //   'https://www.themoviedb.org/assets/2/v4/logos/208x226-powered-blue-e0b095a9fbb53e9638a2799c07c2bffb502abf9fbc46ca36a85f9d25efcfeea7.png',
              //   height: 48,
              //   width: 48,
              // ),
              Spacer(),
              CircleAvatar(
                backgroundColor: Color(0xFF377CCF),
                radius: 24,
                child: Icon(Icons.settings, color: Colors.white, size: 30),
              ),
            ],
          ),
        ),
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
    final unselectedColor = Colors.blueGrey[200];
    return Container(
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
              unselectedColor: unselectedColor!,
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
          height: 64,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: selected
                    ? BoxDecoration(
                  color: selectedColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                )
                    : null,
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  icon,
                  color: selected ? selectedColor : unselectedColor,
                  size: 28,
                ),
              ),
              SizedBox(height: 4),
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