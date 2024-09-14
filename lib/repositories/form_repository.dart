import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'form_repository.g.dart';

class FormRepository {
  Future<bool> submitForm({
    required String name,
    required String email,
    required String phone,
  }) async {
    // Імітація відправки форми на сервер
    await Future.delayed(const Duration(seconds: 2));
    return DateTime.now().second.isEven;
  }
}

@riverpod
FormRepository formRepository(FormRepositoryRef ref) {
  return FormRepository();
}
