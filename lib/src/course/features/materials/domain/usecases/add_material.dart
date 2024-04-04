import 'package:tdd_education_app/core/usecases/usecases.dart';
import 'package:tdd_education_app/core/utils/typedefs.dart';
import 'package:tdd_education_app/src/course/features/materials/domain/entities/resource.dart';
import 'package:tdd_education_app/src/course/features/materials/domain/repos/material_repo.dart';

class AddMaterial extends FutureUsecaseWithParams<void, Resource> {
  const AddMaterial(this._repo);

  final MaterialRepo _repo;

  @override
  ResultFuture<void> call(Resource params) => _repo.addMaterial(params);
}
