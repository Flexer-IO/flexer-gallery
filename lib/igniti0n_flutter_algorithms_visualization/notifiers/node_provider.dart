import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'common/models/node.dart';
import 'notifiers/nodes_state_notifier.dart';

final nodeProvider =
    StateProvider.family<Node, NodeCoordinate>((ref, coordinates) {
  final nodes = ref.watch(nodesStateNotifierProvider);
  final node = nodes.elementAt(coordinates.x).elementAt(coordinates.y);
  final someNode = node.copyWith(
      x: node.x,
      y: node.y,
      isGoalNode: node.isGoalNode,
      isWall: node.isWall,
      isVisited: node.isVisited,
      isStart: node.isStart,
      isOnTraceablePathToGoal: node.isOnTraceablePathToGoal,
      cameFromNode: node.cameFromNode,
      isInStack: node.isInStack,
      isCurrentlyBeingVisited: node.isCurrentlyBeingVisited,
      isTopPriority: node.isTopPriority);
  return someNode;
});
