import 'package:flutter_bloc/flutter_bloc.dart';

/// حالة التابات: التاب الحالي + أي تابات اتفتحت قبل كده (bitmask).
/// التاب اللي ما اتفتحش ما بيتبنيش ولا بيبعت requests (lazy IndexedStack).
class HomeTabState {
  final int index;
  final int builtMask;

  const HomeTabState({this.index = 0, this.builtMask = 1});

  bool isBuilt(int tab) => (builtMask >> tab) & 1 == 1;

  @override
  bool operator ==(Object other) =>
      other is HomeTabState &&
      other.index == index &&
      other.builtMask == builtMask;

  @override
  int get hashCode => Object.hash(index, builtMask);
}

class HomeTabCubit extends Cubit<HomeTabState> {
  HomeTabCubit() : super(const HomeTabState());

  void selectTab(int tab) {
    if (isClosed) return;
    emit(HomeTabState(index: tab, builtMask: state.builtMask | (1 << tab)));
  }
}
