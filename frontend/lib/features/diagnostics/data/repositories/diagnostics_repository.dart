import 'package:farmcom/core/domain/repositories/idiagnostics_repository.dart';
import 'package:farmcom/core/utils/logger.dart';

class DiagnosticsRepository implements IDiagnosticsRepository {
  @override
  Future<Diagnosis> analyzePlantImage(String imagePath) async {
    Logger.warning('Diagnostics feature not yet implemented: analyzePlantImage');
    throw UnimplementedError('AI plant diagnosis not yet implemented. Get Plant.id API key to enable.');
  }
  
  @override
  Future<List<Diagnosis>> getDiagnosisHistory({int page = 1, int pageSize = 20}) async {
    Logger.warning('Diagnostics feature not yet implemented: getDiagnosisHistory');
    return [];
  }
  
  @override
  Stream<List<Diagnosis>> watchDiagnosisHistory() async* {
    Logger.warning('Diagnostics feature not yet implemented: watchDiagnosisHistory');
    yield [];
  }
  
  @override
  Future<void> saveDiagnosis(Diagnosis diagnosis) async {
    Logger.warning('Diagnostics feature not yet implemented: saveDiagnosis');
    // TODO: Implement - save to Isar locally
  }
  
  @override
  Future<void> deleteDiagnosis(String diagnosisId) async {
    Logger.warning('Diagnostics feature not yet implemented: deleteDiagnosis');
    // TODO: Implement
  }
  
  @override
  Future<Diagnosis?> getDiagnosis(String diagnosisId) async {
    Logger.warning('Diagnostics feature not yet implemented: getDiagnosis');
    return null;
  }
  
  @override
  Future<Remedy?> getRemedy(String diseaseId) async {
    Logger.warning('Diagnostics feature not yet implemented: getRemedy');
    return null;
  }
  
  @override
  Future<void> reportFeedback({required String diagnosisId, required bool isAccurate, String? correctDisease, String? notes}) async {
    Logger.warning('Diagnostics feature not yet implemented: reportFeedback');
    // TODO: Implement - improve AI model with feedback
  }
  
  @override
  Future<List<Diagnosis>> getPendingDiagnoses() async {
    Logger.warning('Diagnostics feature not yet implemented: getPendingDiagnoses');
    return [];
  }
  
  @override
  Future<void> syncPendingDiagnoses() async {
    Logger.warning('Diagnostics feature not yet implemented: syncPendingDiagnoses');
    // TODO: Implement - sync diagnoses to Supabase
  }
}
