part of '../widget.dart';

class NetwolfLanding extends StatelessWidget {
  const NetwolfLanding({super.key, required this.controller});

  final NetwolfController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetwolfAppBar(
            title: 'Netwolf',
            controller: controller,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildSearchBar(context),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _RequestListView(
              key: controller._listingKey,
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _SearchBar(controller: controller)),
        const SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.sort, color: Colors.grey[600]),
          onPressed: () => NetwolfRouter.of(context).present(
            FilterDialog(
              initialRequestMethod: controller._filteredMethod,
              initialResponseStatus: controller._filteredStatus,
              onClearFiltersPressed: controller._clearFilters,
              onSorted: controller.updateFilter,
            ),
          ),
        ),
      ],
    );
  }
}
