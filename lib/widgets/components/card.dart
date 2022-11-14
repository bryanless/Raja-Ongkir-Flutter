part of '../widgets.dart';

class ElevatedCard extends StatelessWidget {
  const ElevatedCard({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: child,
    );
  }
}

class FilledCard extends StatelessWidget {
  const FilledCard({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: child,
    );
  }
}

class OutlinedCard extends StatelessWidget {
  const OutlinedCard({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: child,
    );
  }
}
