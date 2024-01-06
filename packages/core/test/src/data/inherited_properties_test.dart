import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(_MockBuildContext());
  });

  group('InheritedProperties', () {
    group('get', () {
      final dep1 = _Dep1();
      final resolved = InheritedProperties([dep1]);

      test('returns value', () {
        final dep = resolved.get<_Dep1>();
        expect(dep, equals(dep1));
      });

      test('returns null', () {
        expect(resolved.get<_Dep2>(), isNull);
      });
    });

    group('get<TextStyle>', () {
      const height40px = CssLineHeight(CssLength(40.0));

      test('returns original line-height null', () {
        const textStyle = TextStyle(fontSize: 20.0);
        final root = InheritedProperties.root(const [textStyle]);
        final props = root.copyWith<CssLineHeight>(value: height40px);
        final height = props.get<TextStyle>()!.height;
        expect(height, isNull);
      });

      test('returns original line-height value', () {
        const textStyle = TextStyle(fontSize: 20.0, height: 1.0);
        final root = InheritedProperties.root(const [textStyle]);
        final props = root.copyWith<CssLineHeight>(value: height40px);
        final height = props.get<TextStyle>()!.height;
        expect(height, equals(1.0));
      });
    });

    group('prepareTextStyle', () {
      test('returns original line-height value', () {
        const textStyle = TextStyle(fontSize: 20.0, height: 1.0);
        final root = InheritedProperties.root(const [textStyle]);
        final props = root.copyWith();
        expect(props.prepareTextStyle().height, equals(1.0));
      });

      test('returns CSS line-height value', () {
        const textStyle = TextStyle(fontSize: 20.0, height: 1.0);
        final root = InheritedProperties.root(const [textStyle]);
        final props = root.copyWith(value: const CssLineHeight(CssLength(40)));
        expect(props.prepareTextStyle().height, equals(2.0));
      });
    });
  });

  group('InheritanceResolvers', () {
    group('isIdenticalWith', () {
      test('returns true with itself', () {
        final resolvers = InheritanceResolvers();
        final actual = resolvers.isIdenticalWith(resolvers);
        expect(actual, isTrue);
      });

      test('returns true with same parent', () {
        final parent = InheritanceResolvers();
        final r1 = parent.sub();
        final r2 = parent.sub();

        expect(r1.isIdenticalWith(r2), isTrue);
        expect(r2.isIdenticalWith(r1), isTrue);
      });

      test('returns true with same parent/grandparent', () {
        final parent = InheritanceResolvers();
        final f1a = parent.sub();
        final f1b = parent.sub();
        final f2 = f1b.sub();

        expect(f1a.isIdenticalWith(f2), isTrue);
        expect(f2.isIdenticalWith(f1a), isTrue);
      });

      test('returns false', () {
        final parent = InheritanceResolvers();
        final r1 = parent.sub();
        final r2 = parent.sub();
        r2.enqueue((resolving, __) => resolving);

        expect(r1.isIdenticalWith(r2), isFalse);
        expect(r2.isIdenticalWith(r1), isFalse);
      });
    });

    group('resolve', () {
      test('triggers callback', () {
        final resolvers = InheritanceResolvers();
        final dep1 = _Dep1();
        resolvers.enqueue((resolving, _) => resolving.copyWith(value: dep1));

        final resolved = resolvers.resolve(_MockBuildContext());
        expect(resolved.get<_Dep1>(), equals(dep1));
      });

      test('triggers all callbacks', () {
        final resolvers = InheritanceResolvers();
        final dep1 = _Dep1();
        resolvers.enqueue((resolving, _) => resolving.copyWith(value: dep1));
        final dep2 = _Dep2();
        resolvers.enqueue((resolving, _) => resolving.copyWith(value: dep2));

        final resolved = resolvers.resolve(_MockBuildContext());
        expect(resolved.get<_Dep1>(), equals(dep1));
        expect(resolved.get<_Dep2>(), equals(dep2));
      });

      test('triggers callback with input', () {
        final resolvers = InheritanceResolvers();
        final dep1 = _Dep1();
        resolvers.enqueue((r, v) => r.copyWith(value: v), dep1);

        final resolved = resolvers.resolve(_MockBuildContext());
        expect(resolved.get<_Dep1>(), equals(dep1));
      });

      test('returns parent properties', () {
        final parent = _MockInheritanceResolvers();
        final parentProperties = InheritedProperties([DateTime.now()]);
        when(() => parent.resolve(any())).thenReturn(parentProperties);

        final resolvers = InheritanceResolvers(parent);
        final resolved = resolvers.resolve(_MockBuildContext());
        expect(resolved, equals(parentProperties));
      });

      test('triggers callback with parent properties', () {
        final parent = _MockInheritanceResolvers();
        final now = DateTime.now();
        when(() => parent.resolve(any()))
            .thenReturn(InheritedProperties([now]));

        final resolvers = InheritanceResolvers(parent);
        final dep1 = _Dep1();
        resolvers.enqueue((resolving, _) => resolving.copyWith(value: dep1));

        final resolved = resolvers.resolve(_MockBuildContext());
        expect(resolved.get<DateTime>(), equals(now));
        expect(resolved.get<_Dep1>(), equals(dep1));
      });

      test('returns cached output', () {
        final parent = _MockInheritanceResolvers();
        when(() => parent.resolve(any()))
            .thenReturn(const InheritedProperties([]));

        final resolvers = InheritanceResolvers(parent);
        resolvers.enqueue((r, _) => r.copyWith(value: DateTime.now()));

        final resolved1 = resolvers.resolve(_MockBuildContext());
        final resolved2 = resolvers.resolve(_MockBuildContext());
        expect(resolved2, equals(resolved1));
      });

      test('throws if output is not copied with', () {
        final resolvers = InheritanceResolvers();
        resolvers.enqueue((_, __) => InheritedProperties([DateTime.now()]));

        expect(
          () => resolvers.resolve(_MockBuildContext()),
          throwsAssertionError,
        );
      });
    });
  });
}

class _Dep1 {}

class _Dep2 {}

class _MockInheritanceResolvers extends Mock implements InheritanceResolvers {}

class _MockBuildContext extends Mock implements BuildContext {}
