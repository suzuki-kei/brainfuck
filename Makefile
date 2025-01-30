
.DEFAULT_GOAL := test

.PHONY: test
test:
	@ruby -I./src/main/ ./src/test/all.rb

.PHONY: demonstrate-generators
demonstrate-generators:
	@bash ./src/scripts/demonstrate-generators.sh

.PHONY: character-to-code-map
character-to-code-map:
	@ruby -I./src/main/ ./src/main/main.character_to_code_map.rb

