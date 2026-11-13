.PHONY: all install check note pre

all: note pre
check: all

install:
	python3 scripts/install.py

note: install
	mkdir -p build
	typst compile --root note/0.1.0 note/0.1.0/template/main.typ build/note.pdf

pre: install
	mkdir -p build
	typst compile --root pre/0.1.0 pre/0.1.0/template/main.typ build/pre.pdf
