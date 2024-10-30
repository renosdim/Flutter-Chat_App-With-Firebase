import 'package:either_dart/either.dart';

import 'failures/failure.dart';


abstract class UseCase<ReturnType,Params>{

  Future<Either<Failure,ReturnType>> call({required Params params});
}