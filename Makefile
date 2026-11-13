.PHONY: all check note pre

all: note pre
check: all

note:
	mkdir -p build
	typst compile --root . templates/note/main.typ build/note.pdf

pre:
	mkdir -p build
	typst compile --root . templates/pre/main.typ build/pre.pdf
