# One entry point for every check. Same commands on macOS, in Claude cloud sessions and in CI.

GDTOOLKIT_VERSION := 4.5.0
SRC := src tests tools

ifeq ($(shell uname -s),Darwin)
GODOT ?= /Applications/Godot.app/Contents/MacOS/Godot
SHOTS_RUN :=
else
GODOT ?= ./.tools/godot
SHOTS_RUN := xvfb-run -a
endif

.PHONY: setup import lint fmt fmt-check test sim balance shots check

setup:
	GDTOOLKIT_VERSION=$(GDTOOLKIT_VERSION) ./scripts/setup.sh

import:
	$(GODOT) --headless --import

lint:
	gdlint $(SRC)

fmt:
	gdformat $(SRC)

fmt-check:
	gdformat --check $(SRC)

test: import
	$(GODOT) --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests -ginclude_subdirs -gexit

# Headless AI-only races on fixed seeds. Lands in M2.6.
sim:
	@echo "make sim: not built yet (ROADMAP M2.6)"; exit 1

# Monte Carlo of seeded runs through the core rules. Lands in M3.7.
balance:
	@echo "make balance: not built yet (ROADMAP M3.7)"; exit 1

# Renders 90 frames of the showcase scene to reports/shots/ so you (or Claude) can look at them.
shots: import
	mkdir -p reports/shots
	$(SHOTS_RUN) $(GODOT) --rendering-method gl_compatibility --resolution 1280x720 \
		--write-movie reports/shots/frame.png --fixed-fps 30 --quit-after 90 \
		res://scenes/debug/showcase.tscn

check: import lint fmt-check test
