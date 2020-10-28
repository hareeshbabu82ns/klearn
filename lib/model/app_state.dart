import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'child_model.dart';

class ChildModelNotifier extends StateNotifier<List<ChildModel>> {
  ChildModelNotifier([List<ChildModel> init]) : super(init ?? []);

  /// Adds [ChildModel] to user.
  void add(ChildModel child) {
    state = [...state, child];
  }
}

final childsListProvider = StateNotifierProvider<ChildModelNotifier>((ref) {
  return ChildModelNotifier([
    ChildModel(id: 1, name: 'Laasya'),
  ]);
});

final selectedChild = StateProvider((ref) => 1);
final currentChild = Provider<ChildModel>((ref) {
  final childId = ref.watch(selectedChild).state;
  final childs = ref.watch(childsListProvider.state);

  return childs.firstWhere((e) => e.id == childId);
});

final sideMenuSelection = StateProvider((ref) => 1);
