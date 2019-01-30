.PHONY: all

#commands
MDFLAGS=-x table
MD=pandoc
MDFLAGS=
#variabls
HEAD=md.head.html

all: README.html
README.html: README.md $(HEAD)
	cat $(HEAD) > $@
	$(MD) $(MDFLAGS) $< >> $@
