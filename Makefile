test-formatting:
	flutter format -l 120 --set-exit-if-changed .

lint:
	flutter analyze --fatal-infos .

unittest:
	flutter test test/unit

smoketest:
	flutter test test/smoke

test: test-formatting lint unittest smoketest
