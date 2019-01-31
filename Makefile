.PHONY: all test convert_json docs setup

#commands
PYTHON=~/anaconda3/bin/python3
PYTHON2=~/anaconda2/bin/python2
#variables
SEMANTIC_SEGMENTATION_JSON=./coco/annotations/semantic_segmentation.json
PANOPTIC2SEMANTIC_SEGMENTATION=./converters/panoptic2semantic_segmentation.py
INPUT_JSON_FILE=./coco/annotations/panoptic_train2017.json
CATEGORIES_JSON_FILE=./coco/annotations/panoptic_coco_categories.json

#phony target rules
all: convert_json
test:
	./pl/view_json.pl \
		--cmds misc/view_json.txt \
		--json $(SEMANTIC_SEGMENTATION_JSON)
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
		--categories_json_file $(CATEGORIES_JSON_FILE)\
		2>log/$(notdir $(basename $(SEMANTIC_SEGMENTATION_JSON))).log.txt
