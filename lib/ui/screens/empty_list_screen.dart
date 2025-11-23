import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptyListView extends StatefulWidget {
  const EmptyListView({super.key});

  @override
  State<EmptyListView> createState() => _EmptyListViewState();
}

class _EmptyListViewState extends State<EmptyListView>
    with SingleTickerProviderStateMixin {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    // Fade-in עדין
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _opacity = 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  theme.colorScheme.surface.withOpacity(0.00),
                  theme.colorScheme.surfaceContainerHighest.withOpacity(0.25),
                ]
              : [
                  theme.colorScheme.surface.withOpacity(0.00),
                  theme.colorScheme.primary.withOpacity(0.04),
                ],
        ),
      ),
      alignment: Alignment.center,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        opacity: _opacity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 6),
                    color: theme.colorScheme.primary.withOpacity(0.1),
                  ),
                ],
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 46,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              tr.noPackagesYet,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              tr.yourListOfPackagesWillAppearHereOnceYouAddOne,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
