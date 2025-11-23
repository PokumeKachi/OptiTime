PHONY_TARGETS := compile watch git run todo flake-develop
.PHONY: $(PHONY_TARGETS)

all:
	@printf '%s\n' $(PHONY_TARGETS) | fzf | xargs -r make

flake-develop:
	@bash -c '\
		h=$$(nix hash path ./flake.nix); \
		if [ "$$FLAKE_HASH" != "$$h" ]; then \
			FLAKE_HASH=$$h exec nix develop; \
			exit 1;\
		else \
			echo "FLAKE_HASH=$$FLAKE_HASH OK"; \
		fi'

compile: flake-develop
	flutter run

run: flake-develop
	flutter run -d linux

web-run: flake-develop
	flutter run -d chrome
	# flutter run

apk-run: flake-develop
	clear && flutter run -d R58WA1L5GYY | grep -v "VRI\|InsetsController\|InteractionJankMonitor\|ProfileInstaller"
	# | grep -v "I/VRI" | grep -v "I/InsetsController"
	# flutter run

watch: flake-develop
	foot -e sh -c 'exec watchexec -r --ignore .git/ --ignore .gitignore --ignore .target-clippy/ --ignore build/ -- make run' & disown

git:
	gitui

todo:
	taskwarrior-tui --taskdata .tasks

