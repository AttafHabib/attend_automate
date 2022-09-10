import cv2
import sys

import numpy

from io_helper import save_image

# from flask import Flask

# cascade_file_ = 'haarcascade_frontalface_default.xml'
cascade_file = 'res10_300x300_ssd_iter_140000.caffemodel'
config_file = 'deploy.prototxt.txt'
# load modal
net = cv2.dnn.readNetFromCaffe(config_file, cascade_file)
resize_scale = 3
image_size = 68
# face_cascade = cv2.CascadeClassifier(cascade_file_)
url = "http://192.168.1.101:8080/video"

def get_single_face():
    # open webcam
    web_cam = cv2.VideoCapture(0)
    # read image
    (_, image_) = web_cam.read()
    img1 = image_.copy()
    gray_img = cv2.cvtColor(img1, cv2.COLOR_BGR2GRAY)

    height, width = image_.shape[:2]
    resized_image = cv2.resize(image_, (300, 300))

    # ImageNet mean rgb pixel intensity values
    blob = cv2.dnn.blobFromImage(resized_image, 1.0, (600, 600), (104.0, 117.0, 123.0))

    net.setInput(blob)
    faces = net.forward()
    # OPENCV DNN
    # [,frame, no of detections, [classid, class score, conf, x,y,h,w]]
    for i in range(faces.shape[2]):
        confidence = faces[0, 0, i, 2]
        # ensure confidence is greater than minimum confidence
        if confidence > 0.5:
            # compute coordinates of the bounding box
            box = faces[0, 0, i, 3:7] * numpy.array([width, height, width, height])

            (x_start, y_start, x_end, y_end) = box.astype("int")

            face = gray_img[y_start:y_end, x_start:x_end]

            face_resize = cv2.resize(face, (image_size, image_size))

            cv2.rectangle(image_, (x_start, y_start), (x_end, y_end), (0, 0, 255), 2)

            cv2.destroyAllWindows()
            web_cam.release()

            return (1, face_resize, image_)
        else:
            cv2.destroyAllWindows()
            web_cam.release()
            return (0, image_)

    #HarCascade
    # gray_image = cv2.cvtColor(image_, cv2.COLOR_BGR2GRAY)
    # mini_image = cv2.resize(gray_image,
    #                         ((int)(gray_image.shape[1] / resize_scale), (int)(gray_image.shape[0] / resize_scale)))
    # faces = face_cascade.detectMultiScale(mini_image)

    # if not len(faces)==0:
    #     face_i = faces[0]
    #
    #     (x, y, w, h) = (v * resize_scale for v in face_i)
    #
    #     # Numpy slicing image
    #     face = gray_image[y:y + h, x:x + w]
    #     # face_resize = cv2.resize(face, (image_size, image_size))
    #
    #     cv2.rectangle(image_, (x, y), (x + w, y + h), (0, 255, 0), 3)
    #
    #     cv2.destroyAllWindows()
    #     web_cam.release()
    #
    #     return (1, face, image_)
    # else:
    #     return (0, image_)