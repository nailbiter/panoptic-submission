import argparse;
import os;
import cv2;
import numpy as np


#procedures
def totwochan(args):
    if not os.path.exists( args['to'] ):
        os.makedirs( args['to'] );
    for filename in os.listdir( args['from'] ):
        fullpath = "{}/{}".format(args['from'],filename);
        outpath = "{}/{}".format(args['to'],filename);
        print( fullpath );
        if( (not args['industrious']) and os.path.exists(outpath) ):
            continue;
        image = cv2.imread(fullpath,-1);
        shape = image.shape;
        print("shape: {}".format(shape));
        if(len(shape)==2):
            print('grayscale');
            new_image = np.zeros((shape[0],shape[1],3));
            for x in range(shape[0]):
                for y in range(shape[1]):
                    new_image[x,y] = (0,0,image[x,y]);
            image = new_image;
        elif(len(shape)==3):
            print('rgb');
            for x in range(shape[0]):
                for y in range(shape[1]):
                    pix = image[x,y];
                    image[x,y] = (0,0,pix[2]);
        else:
            raise Exception('test');
        cv2.imwrite(outpath,image);
def parseArgs():
    parser = argparse.ArgumentParser();
    parser.add_argument('--from', type=str,required=True, help='');
    parser.add_argument('--to', type=str,required=True, help='');
    parser.add_argument('--mode', type=str,required=True, help='');
    parser.add_argument('--industrious', action='store_true')
    args = parser.parse_args();
    return vars(args);

#main
args = parseArgs();
if not True:
    print(args);
    exit();
print( args );
if( args['mode'] == 'TOTWOCHAN' ):
    totwochan( args );
else:
    print("unknown mode {}".format(args['mode']));
