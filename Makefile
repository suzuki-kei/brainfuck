
.DEFAULT_GOAL := test

.PHONY: test
test:
	@ruby -I. test_brainfuck.rb

.PHONY: run
run:
	@ruby brainfuck.rb

