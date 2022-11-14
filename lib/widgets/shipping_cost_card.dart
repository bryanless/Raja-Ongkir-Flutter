part of 'widgets.dart';

class ShippingCostCard extends StatelessWidget {
  const ShippingCostCard({
    super.key,
    required this.costs,
  });

  final Costs costs;

  @override
  Widget build(BuildContext context) {
    return FilledCard(
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Space.medium,
              vertical: Space.small,
            ),
            title: Text('${costs.description} (${costs.service})'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Biaya: ${costs.cost!.first.value}'),
                Text('Estimasi tiba: ${costs.cost!.first.etd}')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
