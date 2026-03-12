/*
  Bottom navigation bar that works for guests and authenticated users,
  and includes a centered add button plus icons for home, groups, notifications, and profile.
*/
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildItem(context, icon: Icons.home, index: 0),
            _buildItem(context, icon: Icons.group, index: 1),

            // ➕ Center button
            GestureDetector(
              onTap: () => onChanged(2),
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(242, 242, 249, 1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: const Icon(Icons.add, color: Colors.black, size: 28),
              ),
            ),

            _buildItem(context, icon: Icons.notifications, index: 3),
            _buildItem(context, icon: Icons.person, index: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context, {
    required IconData icon,
    required int index,
  }) {
    final bool isActive = index == currentIndex;

    return InkWell(
      onTap: () => onChanged(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: isActive ? 56 : 40,
        height: 40,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: isActive ? 28 : 22,
          color: isActive ? const Color.fromARGB(255, 15, 15, 17) : Colors.grey,
        ),
      ),
    );
  }
}
