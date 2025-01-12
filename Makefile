
.DEFAULT_GOAL := test

.PHONY: test
test:
	@ruby -I./src/main/ ./src/test/test_brainfuck.rb

.PHONY: run
run:
	@ruby -I./src/main/ ./src/main/brainfuck.rb

