import 'package:flutter/material.dart';
import 'package:globox/models/classes/package.dart';
import 'package:globox/ui/items/map_card_item.dart';

class HorizontalCardScroller extends StatefulWidget {
  const HorizontalCardScroller({
    super.key,
    required this.packagesForSingleLocation,
  });

  final List<Package> packagesForSingleLocation;

  @override
  State<HorizontalCardScroller> createState() => _HorizontalCardScrollerState();
}

class _HorizontalCardScrollerState extends State<HorizontalCardScroller> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        children: [
          SizedBox(
            height: 320,
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.packagesForSingleLocation.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: MapCardItem(
                      package: widget.packagesForSingleLocation[index],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // 👇 the circles
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                List.generate(widget.packagesForSingleLocation.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentIndex == index ? 12 : 8,
                height: _currentIndex == index ? 12 : 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index
                      ? Colors.blue
                      : Colors.grey.shade400,
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
