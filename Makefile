.PHONY: all test convert_json docs setup test2

#commands
PYTHON=~/anaconda3/bin/python3
PYTHON2=~/anaconda2/bin/python2
#variables
SEMANTIC_SEGMENTATION_JSON=./coco/annotations/semantic_segmentation.json
PANOPTIC2SEMANTIC_SEGMENTATION=./converters/panoptic2semantic_segmentation.py
INPUT_JSON_FILE=./coco/annotations/panoptic_train2017.json
CATEGORIES_JSON_FILE=./coco/annotations/panoptic_coco_categories.json
SEMANTIC_SEG_FOLDER=coco/annotations/semantic_segmentation_pngs
CLASS_DICT=coco/annotations/class_dict.csv

#phony target rules
all: test2
test2: $(CLASS_DICT)
test:
	./pl/view_json.pl \
		--log log/view_json.log.txt\
		--json $(SEMANTIC_SEGMENTATION_JSON)
convert_json: $(SEMANTIC_SEGMENTATION_JSON)
docs:
	make -C docs/
setup:
	./pl/commit.pl setup

#universal rules
#non-universal rules
$(CLASS_DICT): $(CATEGORIES_JSON_FILE) pl/converter.pl
	./pl/converter.pl --in $< --mode SEGTOCSV > $@
$(SEMANTIC_SEGMENTATION_JSON): 
	$(PYTHON2) $(PANOPTIC2SEMANTIC_SEGMENTATION)\
		--input_json_file $(INPUT_JSON_FILE)\
		--output_json_file $(SEMANTIC_SEGMENTATION_JSON) \
		--categories_json_file $(CATEGORIES_JSON_FILE)\
		2>log/$(notdir $(basename $(SEMANTIC_SEGMENTATION_JSON))).log.txt
	mkdir -p $(SEMANTIC_SEG_FOLDER)
	$(PYTHON2) $(PANOPTIC2SEMANTIC_SEGMENTATION)\
		--input_json_file $(INPUT_JSON_FILE)\
	  	--semantic_seg_folder $(SEMANTIC_SEG_FOLDER)\
		--categories_json_file $(CATEGORIES_JSON_FILE)\
		2>log/$(notdir $(basename $(SEMANTIC_SEGMENTATION_JSON))).log.txt
