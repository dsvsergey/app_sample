import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'animation_repository.g.dart';

class AnimationRepository {
  Future<void> performAnimation() async {
    // Імітація асинхронної операції
    await Future.delayed(const Duration(seconds: 2));
  }
}

@riverpod
AnimationRepository animationRepository(AnimationRepositoryRef ref) {
  return AnimationRepository();
}
