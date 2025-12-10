import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/tournament_repository_interface.dart';
import 'tournament_event.dart';
import 'tournament_state.dart';

/// Tournament BLoC - إدارة حالة المسابقات
class TournamentBloc extends Bloc<TournamentEvent, TournamentState> {
  final TournamentRepositoryInterface repository;

  TournamentBloc({required this.repository}) : super(const TournamentInitial()) {
    // جلب البطولات
    on<FetchTournaments>(_onFetchTournaments);
    on<FetchTournament>(_onFetchTournament);
    
    // إدارة البطولات
    on<CreateTournament>(_onCreateTournament);
    on<UpdateTournament>(_onUpdateTournament);
    on<DeleteTournament>(_onDeleteTournament);
    
    // إدارة الفرق
    on<RegisterTeam>(_onRegisterTeam);
    on<UnregisterTeam>(_onUnregisterTeam);
    on<FetchTournamentTeams>(_onFetchTournamentTeams);
    
    // إدارة المراحل والمباريات
    on<FetchTournamentStages>(_onFetchTournamentStages);
    on<FetchStageMatches>(_onFetchStageMatches);
    on<FetchMatch>(_onFetchMatch);
    on<UpdateMatchResult>(_onUpdateMatchResult);
    
    // إدارة حالة البطولة
    on<StartStage>(_onStartStage);
    on<CompleteStage>(_onCompleteStage);
    on<StartTournament>(_onStartTournament);
    on<CompleteTournament>(_onCompleteTournament);
    
    // إعادة تعيين
    on<ResetTournamentState>(_onResetTournamentState);
  }

  Future<void> _onFetchTournaments(
    FetchTournaments event,
    Emitter<TournamentState> emit,
  ) async {
    emit(const TournamentLoading());
    try {
      final tournaments = await repository.getAllTournaments(
        status: event.status,
        limit: event.limit,
        offset: event.offset,
      );
      emit(TournamentsLoaded(tournaments));
    } catch (e) {
      emit(TournamentError('Failed to fetch tournaments: $e'));
    }
  }

  Future<void> _onFetchTournament(
    FetchTournament event,
    Emitter<TournamentState> emit,
  ) async {
    emit(const TournamentLoading());
    try {
      final tournament = await repository.getTournamentById(event.tournamentId);
      if (tournament != null) {
        // جلب الفرق والمراحل والـ bracket
        final teams = await repository.getTournamentTeams(event.tournamentId);
        final stages = await repository.getTournamentStages(event.tournamentId);
        final bracket = await repository.getTournamentBracket(event.tournamentId);
        
        emit(TournamentLoaded(
          tournament: tournament,
          teams: teams,
          stages: stages,
          bracket: bracket,
        ));
      } else {
        emit(const TournamentError('Tournament not found'));
      }
    } catch (e) {
      emit(TournamentError('Failed to fetch tournament: $e'));
    }
  }

  Future<void> _onCreateTournament(
    CreateTournament event,
    Emitter<TournamentState> emit,
  ) async {
    emit(const TournamentLoading());
    try {
      final tournament = await repository.createTournament(event.tournament);
      emit(TournamentUpdated(tournament));
    } catch (e) {
      emit(TournamentError('Failed to create tournament: $e'));
    }
  }

  Future<void> _onUpdateTournament(
    UpdateTournament event,
    Emitter<TournamentState> emit,
  ) async {
    try {
      final tournament = await repository.updateTournament(event.tournament);
      emit(TournamentUpdated(tournament));
    } catch (e) {
      emit(TournamentError('Failed to update tournament: $e'));
    }
  }

  Future<void> _onDeleteTournament(
    DeleteTournament event,
    Emitter<TournamentState> emit,
  ) async {
    emit(const TournamentLoading());
    try {
      await repository.deleteTournament(event.tournamentId);
      emit(const TournamentInitial());
    } catch (e) {
      emit(TournamentError('Failed to delete tournament: $e'));
    }
  }

  Future<void> _onRegisterTeam(
    RegisterTeam event,
    Emitter<TournamentState> emit,
  ) async {
    try {
      await repository.registerTeam(event.tournamentId, event.team);
      emit(TeamRegistered(
        tournamentId: event.tournamentId,
        team: event.team,
      ));
    } catch (e) {
      emit(TournamentError('Failed to register team: $e'));
    }
  }

  Future<void> _onUnregisterTeam(
    UnregisterTeam event,
    Emitter<TournamentState> emit,
  ) async {
    try {
      await repository.unregisterTeam(event.tournamentId, event.teamId);
      // إعادة جلب البطولة
      add(FetchTournament(event.tournamentId));
    } catch (e) {
      emit(TournamentError('Failed to unregister team: $e'));
    }
  }

  Future<void> _onFetchTournamentTeams(
    FetchTournamentTeams event,
    Emitter<TournamentState> emit,
  ) async {
    try {
      final teams = await repository.getTournamentTeams(event.tournamentId);
      emit(TeamsLoaded(
        tournamentId: event.tournamentId,
        teams: teams,
      ));
    } catch (e) {
      emit(TournamentError('Failed to fetch teams: $e'));
    }
  }

  Future<void> _onFetchTournamentStages(
    FetchTournamentStages event,
    Emitter<TournamentState> emit,
  ) async {
    try {
      final stages = await repository.getTournamentStages(event.tournamentId);
      emit(StagesLoaded(
        tournamentId: event.tournamentId,
        stages: stages,
      ));
    } catch (e) {
      emit(TournamentError('Failed to fetch stages: $e'));
    }
  }

  Future<void> _onFetchStageMatches(
    FetchStageMatches event,
    Emitter<TournamentState> emit,
  ) async {
    try {
      final matches = await repository.getStageMatches(
        event.tournamentId,
        event.stageId,
      );
      emit(MatchesLoaded(
        tournamentId: event.tournamentId,
        stageId: event.stageId,
        matches: matches,
      ));
    } catch (e) {
      emit(TournamentError('Failed to fetch matches: $e'));
    }
  }

  Future<void> _onFetchMatch(
    FetchMatch event,
    Emitter<TournamentState> emit,
  ) async {
    try {
      final match = await repository.getMatchById(
        event.tournamentId,
        event.matchId,
      );
      if (match != null) {
        emit(MatchLoaded(match));
      } else {
        emit(const TournamentError('Match not found'));
      }
    } catch (e) {
      emit(TournamentError('Failed to fetch match: $e'));
    }
  }

  Future<void> _onUpdateMatchResult(
    UpdateMatchResult event,
    Emitter<TournamentState> emit,
  ) async {
    try {
      await repository.updateMatchResult(
        event.tournamentId,
        event.matchId,
        event.match,
      );
      emit(MatchResultUpdated(event.match));
    } catch (e) {
      emit(TournamentError('Failed to update match result: $e'));
    }
  }

  Future<void> _onStartStage(
    StartStage event,
    Emitter<TournamentState> emit,
  ) async {
    try {
      await repository.startStage(event.tournamentId, event.stageId);
      // إعادة جلب البطولة
      add(FetchTournament(event.tournamentId));
    } catch (e) {
      emit(TournamentError('Failed to start stage: $e'));
    }
  }

  Future<void> _onCompleteStage(
    CompleteStage event,
    Emitter<TournamentState> emit,
  ) async {
    try {
      await repository.completeStage(event.tournamentId, event.stageId);
      // إعادة جلب البطولة
      add(FetchTournament(event.tournamentId));
    } catch (e) {
      emit(TournamentError('Failed to complete stage: $e'));
    }
  }

  Future<void> _onStartTournament(
    StartTournament event,
    Emitter<TournamentState> emit,
  ) async {
    emit(const TournamentLoading());
    try {
      await repository.startTournament(event.tournamentId);
      // إعادة جلب البطولة
      add(FetchTournament(event.tournamentId));
    } catch (e) {
      emit(TournamentError('Failed to start tournament: $e'));
    }
  }

  Future<void> _onCompleteTournament(
    CompleteTournament event,
    Emitter<TournamentState> emit,
  ) async {
    emit(const TournamentLoading());
    try {
      await repository.completeTournament(event.tournamentId);
      // إعادة جلب البطولة
      add(FetchTournament(event.tournamentId));
    } catch (e) {
      emit(TournamentError('Failed to complete tournament: $e'));
    }
  }

  void _onResetTournamentState(
    ResetTournamentState event,
    Emitter<TournamentState> emit,
  ) {
    emit(const TournamentInitial());
  }
}

