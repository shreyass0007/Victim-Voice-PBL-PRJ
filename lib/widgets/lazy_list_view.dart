import 'package:flutter/material.dart';

class LazyListView extends StatefulWidget {
  final Future<List<dynamic>> Function(int page, int pageSize) fetchData;
  final Widget Function(BuildContext context, dynamic item) itemBuilder;
  final int pageSize;
  final Widget? loadingWidget;
  final Widget? emptyWidget;
  final String? errorMessage;

  const LazyListView({
    super.key,
    required this.fetchData,
    required this.itemBuilder,
    this.pageSize = 20,
    this.loadingWidget,
    this.emptyWidget,
    this.errorMessage,
  });

  @override
  _LazyListViewState createState() => _LazyListViewState();
}

class _LazyListViewState extends State<LazyListView> {
  final List<dynamic> _items = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  String? _error;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMoreItems();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreItems() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final newItems = await widget.fetchData(_currentPage, widget.pageSize);

      setState(() {
        _items.addAll(newItems);
        _currentPage++;
        _isLoading = false;
        _hasMore = newItems.length == widget.pageSize;
      });
    } catch (e) {
      setState(() {
        _error = widget.errorMessage ?? 'Error loading items';
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreItems();
    }
  }

  Future<void> refresh() async {
    setState(() {
      _items.clear();
      _currentPage = 0;
      _hasMore = true;
      _error = null;
    });
    await _loadMoreItems();
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty && _isLoading) {
      return widget.loadingWidget ??
          const Center(child: CircularProgressIndicator());
    }

    if (_items.isEmpty && !_isLoading) {
      return widget.emptyWidget ?? const Center(child: Text('No items found'));
    }

    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _items.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _items.length) {
            if (_error != null) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(_error!, style: TextStyle(color: Colors.red)),
                    ElevatedButton(
                      onPressed: _loadMoreItems,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return widget.itemBuilder(context, _items[index]);
        },
      ),
    );
  }
}
