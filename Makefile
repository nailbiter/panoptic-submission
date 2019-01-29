.PHONY: all test convert_json

#variables
PYTHON=~/anaconda3/bin/python3
SEMANTIC_SEGMENTATION_JSON=semantic_segmentation.json
PANOPTIC2SEMANTIC_SEGMENTATION=../panopticapi/converters/panoptic2semantic_segmentation.py
INPUT_JSON_FILE=panoptic_train2017.json

#phony target rules
all: convert_json
test:
	$(PYTHON) test.py
convert_json: $(SEMANTIC_SEGMENTATION_JSON)

#universal rules
#non-universal rules
$(SEMANTIC_SEGMENTATION_JSON): 
	$(PYTHON) $(PANOPTIC2SEMANTIC_SEGMENTATION)\
		--input_json_file $(INPUT_JSON_FILE)\
		--output_json_file $(SEMANTIC_SEGMENTATION_JSON) 2>log/$(SEMANTIC_SEGMENTATION_JSON).log.txt
