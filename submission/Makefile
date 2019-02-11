.PHONY: all


#global const's
TYPE=stuff
TESTSET=val
ALG=semantic
#global var's
BASENAME=$(TYPE)_$(TESTSET)_$(ALG)
#procedures

#main
all: $(BASENAME).zip
	du -hs $<
	echo "upload \"$<\""
$(BASENAME).zip: $(BASENAME).json
	zip -9 -r $(basename $<) $< $(basename $<)

