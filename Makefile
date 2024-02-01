.PHONY: test check
build:
	dune build

code:
	-dune build
	code .
	! dune build --watch


utop:
	OCAMLRUNPARAM=b dune utop src

test:
	OCAMLRUNPARAM=b dune exec test/main.exe

plan:
	OCAMLRUNPARAM=b dune exec bin/main.exe

zip:
	rm -f orion-source.zip
	zip -r orion-source.zip . -x@exclude.lst

clean:
	dune clean
	rm -f orion-source.zip

doc:
	dune build @doc

opendoc: doc
	@bash opendoc.sh
