import 'package:flutter/material.dart';

/* ** Usage **
 *
 * ExpandableSection(
 *    title: 'Popular',
 *    isExpanded: isExpanded,
 *    onToggle: () => setState(() {
 *      isExpanded = !isExpanded;
 *    }),
 *    isLoading: state is PopularMoviesLoading,
 *    items: movies.map((movie) => MovieCard(movie: movie)).toList(),
 *    onViewAll: () {
 *      // Navigator.push(context, MaterialPageRoute(builder: (_) => FullListScreen()));
 *    })
 */

class ExpandableSection extends StatefulWidget {
  final String title;
  final List<Widget> items;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback? onViewAll;
  final bool isLoading;

  const ExpandableSection({
    super.key,
    required this.title,
    required this.items,
    required this.isExpanded,
    required this.onToggle,
    this.onViewAll,
    this.isLoading = false,
  });

  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection>
    with SingleTickerProviderStateMixin {
  final GlobalKey _listKey = GlobalKey();
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    if (widget.isExpanded) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(ExpandableSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
        _scrollToList();
      } else {
        _controller.reverse();
      }
    }
  }

  void _scrollToList() {
    Future.delayed(const Duration(milliseconds: 300), () {
      final context = _listKey.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 400),
          alignment: 0.0,
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: widget.onToggle,
            borderRadius: BorderRadius.circular(12),
            splashColor: Color.alphaBlend(
              colorScheme.primary.withAlpha(31),
              colorScheme.surface,
            ),
            child: Ink(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    widget.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (widget.onViewAll != null)
                    TextButton(
                      onPressed: widget.onViewAll,
                      child: const Text("View All"),
                    ),
                  AnimatedRotation(
                    turns: widget.isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(Icons.expand_more),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _expandAnimation,
          axisAlignment: -1,
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: SizedBox(
              key: _listKey,
              height: 220,
              child: widget.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.items.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, index) => widget.items[index],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
