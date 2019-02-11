import argparse;
import os;
import cv2;
import numpy as np


#procedures
def totwochan(args):
    v = vars(args);
    if not os.path.exists( args.to ):
        os.makedirs( args.to );
    for filename in os.listdir( v['from'] ):
        fullpath = "{}/{}".format(v['from'],filename);
        outpath = "{}/{}".format(v['to'],filename);
        print( fullpath );
        if(os.path.exists(outpath)):
            continue;
        image = cv2.imread(fullpath,-1);
        shape = image.shape;
        print("shape: {}".format(shape));
        if(len(shape)==2):
            #image[x,y] = (0,0,pix);
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
        #exit();

#main
parser = argparse.ArgumentParser();
parser.add_argument('--from', type=str,required=True, help='');
parser.add_argument('--to', type=str,required=True, help='');
parser.add_argument('--mode', type=str,required=True, help='');
args = parser.parse_args();
print( args );
if( args.mode == 'TOTWOCHAN' ):
    totwochan( args );
else:
    print("unknown mode {}".format(args.mode));
