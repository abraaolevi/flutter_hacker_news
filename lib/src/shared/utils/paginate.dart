class Paginate<T> {
  final int page;
  final int perPage;

  int _totalItems;
  int get totalItems => _totalItems;

  int _totalPages;
  int get totalPages => _totalPages;

  List<T> _items;
  List<T> get items => _items;

  Paginate({List<T> items, this.page, this.perPage}) {
    this._totalItems = items.length;
    this._totalPages = _getTotalPages();
    this._items = _getData(items);
  }

  int _getTotalPages() {
    return (_totalItems / perPage).ceil();
  }

  List<T> _getData(List<T> items) {
    final offset = (page - 1) * perPage;
    if (offset > _totalItems) {
      return [];
    }
    var paginated = items.sublist(offset);
    // last page?
    if (perPage > paginated.length) {
      return paginated;
    }
    return paginated.sublist(0, perPage);
  }
}
