import 'package:flutter_hacker_news/src/shared/utils/paginate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  Paginate paginate;

  test('Paginte should paginate array correctly', () {
    paginate = Paginate(items: array, page: 1, perPage: 5);
    expect(paginate.items.length, 5);
    expect(paginate.items, [0, 1, 2, 3, 4]);
    expect(paginate.totalPages, 3);

    paginate = Paginate(items: array, page: 2, perPage: 5);
    expect(paginate.items.length, 5);
    expect(paginate.items, [5, 6, 7, 8, 9]);
    expect(paginate.totalPages, 3);

    paginate = Paginate(items: array, page: 3, perPage: 5);
    expect(paginate.items.length, 1);
    expect(paginate.items, [10]);
    expect(paginate.totalPages, 3);

    paginate = Paginate(items: array, page: 4, perPage: 5);
    expect(paginate.items.length, 1);
    expect(paginate.items, []);
    expect(paginate.totalPages, 3);
  });

  test('Paginate should return empty when invalid page', () {
    paginate = Paginate(items: array, page: -1, perPage: 5);
    expect(paginate.items.length, 0);
    expect(paginate.items, []);

    paginate = Paginate(items: array, page: 0, perPage: 5);
    expect(paginate.items.length, 0);
    expect(paginate.items, []);

    paginate = Paginate(items: array, page: 100, perPage: 5);
    expect(paginate.items.length, 0);
    expect(paginate.items, []);
  });

  test('Paginate should return all set when perPage is more than size List',
      () {
    paginate = Paginate(items: array, page: 1, perPage: 20);
    expect(paginate.items.length, array.length);
    expect(paginate.items, array);
  });
}
