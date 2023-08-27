import 'package:flutter/material.dart';
import 'package:netwolf/src/core/constants.dart';
import 'package:netwolf/src/core/enums.dart';
import 'package:netwolf/src/core/netwolf_controller.dart';
import 'package:netwolf/src/models/netwolf_request.dart';
import 'package:netwolf/src/ui/widgets/netwolf_app_bar.dart';
import 'package:netwolf/src/ui/widgets/netwolf_request_listview.dart';
import 'package:netwolf/src/ui/widgets/netwolf_search_bar.dart';
import 'package:netwolf/src/ui/widgets/settings_dialog.dart';
import 'package:notification_dispatcher/notification_dispatcher.dart';

class NetwolfLandingPage extends StatefulWidget {
  const NetwolfLandingPage({super.key});

  @override
  State<NetwolfLandingPage> createState() => _NetwolfLandingPageState();
}

class _NetwolfLandingPageState extends State<NetwolfLandingPage> {
  String _searchTerm = '';
  HttpRequestMethod? _method;
  HttpResponseStatus? _status;

  List<NetwolfRequest> _requests = [];

  @override
  void initState() {
    super.initState();
    _getRequests();
    NotificationDispatcher.instance.addObserver(
      this,
      name: NotificationName.refetchRequests.name,
      callback: (_) => _getRequests(),
    );
  }

  @override
  void dispose() {
    NotificationDispatcher.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NetwolfAppBar(
        title: kPackageName,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => SettingsDialog(
                onClearDataPressed: _getRequests,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: kDefaultPadding.top,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: kDefaultPadding.copyWith(top: 0, bottom: 0),
              child: NetwolfSearchBar(
                onSearchChanged: _onSearchTermChanged,
                onFilterChanged: _onUpdateFilters,
                onFiltersCleared: _onClearFilters,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: NetwolfRequestListView(
                searchTerm: _searchTerm,
                method: _method,
                status: _status,
                requests: _requests,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getRequests() {
    NetwolfController.instance.getRequests().then((value) {
      _requests = value.data ?? _requests;
      if (mounted) setState(() {});
    });
  }

  void _onSearchTermChanged(String searchTerm) {
    setState(() {
      _searchTerm = searchTerm;
    });
  }

  void _onUpdateFilters(HttpRequestMethod? method, HttpResponseStatus? status) {
    setState(() {
      _method = method;
      _status = status;
    });
  }

  void _onClearFilters() {
    setState(() {
      _method = null;
      _status = null;
    });
  }
}
