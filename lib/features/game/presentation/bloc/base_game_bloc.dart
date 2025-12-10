import 'package:flutter_bloc/flutter_bloc.dart';

import 'game_event.dart';
import 'game_state.dart';

abstract class BaseGameBloc extends Bloc<GameEvent, GameState> {
  BaseGameBloc() : super(const GameInitial());
}

