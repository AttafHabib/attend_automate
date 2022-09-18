import os
import random
import string

import cv2
import face_recognition
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


def get_images_labels(path):
    # Create a list of images and a list of corresponding names
    # (images, labels, u_ids, id) = ([], [], {}, 0)
    labels = []
    for (subdirs, dirs, files) in os.walk(path):
        for subdir in dirs:
            file_dir_path = os.path.join(path, subdir)
            for filename in os.listdir(file_dir_path):
                name = os.path.splitext(filename)[0]
                name_list = name.split('_')
                file_path = os.path.join(file_dir_path, filename)
                name = str(subdir) + '-' + name_list[0]

                # labels.append((name, ))
                # print(os.path.splitext(filename)[0])
                # print(file_path)
                labels.append((file_path, name))
                break
    return labels


def get_encoding_labels(labels):
    (known_enc, known_labels) = ([], [])
    for (path, name) in labels:
        image = face_recognition.load_image_file(path)
        image_enc = face_recognition.face_encodings(image)[0]
        known_enc.append(image_enc)
        known_labels.append(name)
    return known_enc, known_labels


def get_random_string(length):
    letters = string.ascii_lowercase
    result_str = ''.join(random.choice(letters) for i in range(length))
    return result_str
