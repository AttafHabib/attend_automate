import os
import cv2
import numpy


def create_labels(path):
    # Create a list of images and a list of corresponding names
    (images, labels, u_ids, id) = ([], [], {}, 0)
    for (subdirs, dirs, files) in os.walk(path):
        for subdir in dirs:
            # u_ids[id] = subdir
            subjectpath = os.path.join(path, subdir)
            for filename in os.listdir(subjectpath):
                path_ = subjectpath + '/' + filename
                img = cv2.resize(cv2.imread(path_, 0), (100, 100))
                images.append(img)
                labels.append(int(subdir))
            id += 1
    # (im_width, im_height) = (112, 92)

    # Create a Numpy array from the two lists above
    (images, labels) = [numpy.array(lis) for lis in [images, labels]]
    return (images, labels)