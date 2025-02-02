
.DEFAULT_GOAL := test

.PHONY: test
test:
	@ruby -I./src/main/ ./src/test/all.rb

.PHONY: demonstrate-generators
demonstrate-generators:
	@bash ./src/scripts/demonstrate-generators.sh

