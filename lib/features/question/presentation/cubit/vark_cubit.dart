import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/ml_prediction.dart';
import '../../domain/usecases/get_ml_prediction.dart';

abstract class VarkCubitState extends Equatable {
  const VarkCubitState();

  @override
  List<Object?> get props => [];
}

class VarkCubitInitial extends VarkCubitState {}

class VarkCubitConnecting extends VarkCubitState {}

class VarkCubitPredicting extends VarkCubitState {
  final String message;

  const VarkCubitPredicting({this.message = 'Menganalisis dengan ML...'});

  @override
  List<Object?> get props => [message];
}

class VarkCubitPredictionSuccess extends VarkCubitState {
  final MLPrediction prediction;

  const VarkCubitPredictionSuccess(this.prediction);

  @override
  List<Object?> get props => [prediction];
}

class VarkCubitConnectionError extends VarkCubitState {
  final String message;

  const VarkCubitConnectionError(this.message);

  @override
  List<Object?> get props => [message];
}

class VarkCubitServerHealthy extends VarkCubitState {
  final bool isHealthy;

  const VarkCubitServerHealthy(this.isHealthy);

  @override
  List<Object?> get props => [isHealthy];
}

class VarkCubit extends Cubit<VarkCubitState> {
  final GetMLPrediction getMLPrediction;

  VarkCubit({required this.getMLPrediction}) : super(VarkCubitInitial());

  /// Check server health
  Future<void> checkServerHealth() async {
    emit(VarkCubitConnecting());

    try {
      // Call health check dari use case
      final result = await getMLPrediction.checkHealth();

      result.fold(
        (failure) {
          emit(
            VarkCubitConnectionError(
              'Server tidak dapat dijangkau: ${failure.message}',
            ),
          );
          emit(VarkCubitServerHealthy(false));
        },
        (isHealthy) {
          emit(VarkCubitServerHealthy(isHealthy));
        },
      );
    } catch (e) {
      emit(VarkCubitConnectionError('Error: $e'));
      emit(VarkCubitServerHealthy(false));
    }
  }

  /// Get prediction dari ML server
  Future<void> getPrediction({
    required int visualScore,
    required int auditoryScore,
    required int readingScore,
    required int kinestheticScore,
  }) async {
    emit(const VarkCubitPredicting());

    try {
      final result = await getMLPrediction(
        MLPredictionParams(
          visualScore: visualScore,
          auditoryScore: auditoryScore,
          readingScore: readingScore,
          kinestheticScore: kinestheticScore,
        ),
      );

      result.fold(
        (failure) {
          emit(VarkCubitConnectionError(failure.message));
        },
        (prediction) {
          emit(VarkCubitPredictionSuccess(prediction));
        },
      );
    } catch (e) {
      emit(VarkCubitConnectionError('Gagal mendapatkan prediksi: $e'));
    }
  }

  /// Reset state
  void reset() {
    emit(VarkCubitInitial());
  }
}
