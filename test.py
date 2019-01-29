import json;
import cv2;

print("hi");
with open('panoptic_train2017.json','r') as f:
    data = json.load(f);

##{'segments_info': [{'id': 8345037, 'category_id': 51, 'iscrowd': 0, 'bbox': [0, 14, 434, 374], 'area': 24315}, {'id': 6968006, 'category_id': 51, 'iscrowd': 0, 'bbox': [312, 4, 319, 229], 'area': 34234}, {'id': 2005197, 'category_id': 51, 'iscrowd': 0, 'bbox': [1, 189, 612, 285], 'area': 70036}, {'id': 3658235, 'category_id': 55, 'iscrowd': 0, 'bbox': [387, 74, 83, 70], 'area': 3566}, {'id': 2803959, 'category_id': 55, 'iscrowd': 0, 'bbox': [376, 40, 76, 47], 'area': 2241}, {'id': 2992357, 'category_id': 55, 'iscrowd': 0, 'bbox': [364, 2, 94, 71], 'area': 2963}, {'id': 2271460, 'category_id': 55, 'iscrowd': 0, 'bbox': [466, 39, 58, 46], 'area': 1660}, {'id': 1720367, 'category_id': 56, 'iscrowd': 0, 'bbox': [250, 229, 316, 245], 'area': 49529}, {'id': 8922372, 'category_id': 189, 'iscrowd': 0, 'bbox': [0, 0, 319, 118], 'area': 17245}, {'id': 7113394, 'category_id': 196, 'iscrowd': 0, 'bbox': [0, 11, 640, 469], 'area': 84156}], 'file_name': '000000000009.png', 'image_id': 9}
##print(data['annotations'][0]);
set1 = set([]);
for segment in data['annotations'][0]['segments_info']:
    set1.add(segment['id']);
##    set1.add(segment['id']);
print(set1);

file_name = (data['annotations'][0]['file_name']);
image_in = cv2.imread('panoptic_train2017/'+file_name);
set2 = set([]);
for i in range(image_in.shape[0]):
    for j in range(image_in.shape[1]):
        (r,g,b) = (0,1,2);
        set2.add(256*256*image_in[i,j][r]+256*image_in[i,j][g]+image_in[i,j][b]);
print(set2);
print((set2-set1)==set([0]));
