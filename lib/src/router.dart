import 'package:go_router/go_router.dart';
import 'package:kana_to_kanji/src/sample_feature/sample_item_details_view.dart';
import 'package:kana_to_kanji/src/sample_feature/sample_item_list_view.dart';

final router = GoRouter(routes: [
  GoRoute(
      path: SampleItemDetailsView.routeName,
      builder: (_, __) => const SampleItemDetailsView()),
  GoRoute(
      path: SampleItemListView.routeName,
      builder: (_, __) => const SampleItemListView())
]);
