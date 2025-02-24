
.DEFAULT_GOAL := test

.PHONY: test
test:
	@ruby -I./src/main/ ./src/test/all.rb

.PHONY: demonstrate-output-string-generators
demonstrate-output-string-generators:
	@bash ./src/scripts/demonstrate-output-string-generators.sh

