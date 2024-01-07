import 'package:ale/src/core/typedefs.dart';

abstract class UsecaseWithParam<TypeReturn, TypeParam> {
  const UsecaseWithParam();
  ResultFuture<TypeReturn> call(TypeParam param);
}

abstract class UsecaseWithoutParam<TypeReturn> {
  const UsecaseWithoutParam();
  ResultFuture<TypeReturn> call();
}
