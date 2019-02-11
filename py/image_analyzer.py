import sys;
import cv2;
import argparse;


#procedures
def parseArgs():
    parser = argparse.ArgumentParser();
    parser.add_argument('--mode',type=str,default='COUNTPIXELS',help='');
    parser.add_argument('files',type=str,nargs='+');
    args = parser.parse_args();
    return vars(args);
def countPixels(filename,args):
    image = cv2.imread(filename,-1);
    shape = image.shape;
    print("shape: {}".format(shape));
    dic = {};
    for x in range(shape[0]):
        for y in range(shape[1]):
            pix = tuple(image[x,y]);
            if( pix not in dic ):
                dic[pix] = 0;
            dic[pix] = dic[pix]+1;
    keys = sorted(dic.keys());
    print("{} different values".format(len(keys)));
    for key in keys:
        print("{0:<20}: {1:<20}".format(str(key),dic[key]));

#main
args = parseArgs();
for filename in args['files']:
    print("****** process {} with {} ******".format(filename,args['mode']));
    if(args['mode'] == 'COUNTPIXELS'):
        countPixels(filename,args);
    else:
        print("unknown mode {}".format(args['mode']));
