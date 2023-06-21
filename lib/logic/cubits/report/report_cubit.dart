
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_camp/data/repository/report_repository.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final ReportRepository repository;
  ReportCubit(this.repository) : super(const ReportState());
   FutureOr<Uint8List> generatePdf(String campsiteId) async {
    return await repository.makePdf(campsiteId);
   }
}
