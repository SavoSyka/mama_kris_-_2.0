import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mama_kris/core/error/failures.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef ResultVoid = ResultFuture<void>;
typedef ResultStream<T> = Stream<Either<Failure, T>>;
typedef DataMap = Map<String, dynamic>;
typedef ApiResponse = Response<DataMap>;
typedef ApiCall<T> = Future<Response<T>> Function();
