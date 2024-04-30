import 'package:frontend/model/utils/action_types_for_pop_payload.dart';

class PopPayload<T> {
  final ActionType actionType;
  final T? data;
  PopPayload(this.actionType, this.data);
}
