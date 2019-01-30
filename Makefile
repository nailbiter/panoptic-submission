.PHONY: all test convert_json docs setup

#commands
PYTHON=~/anaconda3/bin/python3
#variables
SEMANTIC_SEGMENTATION_JSON=semantic_segmentation.json
PANOPTIC2SEMANTIC_SEGMENTATION=./converters/panoptic2semantic_segmentation.py
INPUT_JSON_FILE=./coco/annotations/panoptic_train2017.json

#phony target rules
all: convert_json
test:
	$(PYTHON) test.py
convert_json: $(SEMANTIC_SEGMENTATION_JSON)
docs:
	make -C docs/
setup:
	./pl/commit.pl setup

#universal rules
#non-universal rules

$(SEMANTIC_SEGMENTATION_JSON): 
	$(PYTHON) $(PANOPTIC2SEMANTIC_SEGMENTATION)\
		--input_json_file $(INPUT_JSON_FILE)\
		--output_json_file $(SEMANTIC_SEGMENTATION_JSON) \
		2>log/$(SEMANTIC_SEGMENTATION_JSON).log.txt
