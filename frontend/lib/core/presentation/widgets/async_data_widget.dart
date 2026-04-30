import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:farmlink_ug/core/presentation/widgets/state_widgets.dart';

typedef AsyncWidgetBuilder<T> = Widget Function(BuildContext context, T data);
typedef AsyncErrorBuilder = Widget Function(
  BuildContext context,
  String error,
  VoidCallback retry,
);

/// A generic async data widget that handles loading, error, and data states
class AsyncDataWidget<T> extends StatelessWidget {
  final AsyncValue<T> asyncValue;
  final AsyncWidgetBuilder<T> data;
  final AsyncErrorBuilder? error;
  final Widget? loading;
  final Widget? empty;
  final bool Function(T)? isEmpty;

  const AsyncDataWidget({
    super.key,
    required this.asyncValue,
    required this.data,
    this.error,
    this.loading,
    this.empty,
    this.isEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      data: (value) {
        // Check if data is empty
        if (isEmpty?.call(value) ?? false) {
          return empty ?? const SizedBox.shrink();
        }
        return data(context, value);
      },
      loading: () => loading ?? const LoadingState(),
      error: (err, stack) {
        return error?.call(
              context,
              err.toString(),
              () {
                // Retry logic would be handled by the parent
              },
            ) ??
            ErrorState(
              title: 'Something went wrong',
              description: err.toString(),
            );
      },
    );
  }
}

extension AsyncValueExtension<T> on AsyncValue<T> {
  /// Check if currently loading
  bool get isLoading => this is AsyncLoading;

  /// Check if has error
  bool get hasError => this is AsyncError;

  /// Check if has data
  bool get hasData => this is AsyncData;

  /// Get data safely
  T? get dataOrNull => whenData((data) => data) as T?;

  /// Get error safely
  Object? get errorOrNull {
    if (this is AsyncError) {
      return (this as AsyncError).error;
    }
    return null;
  }
}

/// Example usage in a ConsumerWidget:
/// 
/// final dataAsync = ref.watch(myDataProvider);
/// 
/// return AsyncDataWidget<List<Item>>(
///   asyncValue: dataAsync,
///   data: (context, items) => ListView(
///     children: items.map((e) => ListTile(title: Text(e.name))).toList(),
///   ),
///   error: (context, error, retry) => ErrorState(
///     title: 'Failed to load items',
///     description: error,
///     onRetry: retry,
///   ),
///   loading: const ShimmerLoader(
///     isLoading: true,
///     child: ListSkeleton(),
///   ),
///   empty: const NoDataState(
///     title: 'No items found',
///     description: 'There are no items to display',
///   ),
///   isEmpty: (items) => items.isEmpty,
/// );
