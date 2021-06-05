test-formatting:
	flutter format -l 120 --set-exit-if-changed .

lint:
	flutter analyze --fatal-infos .

unittest:
	flutter test test/unit

test-widgets:
	flutter test test/widget_test.dart

test: test-formatting lint unittest test-widgets
