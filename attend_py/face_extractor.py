import cv2
import sys

from io_helper import save_image

# from flask import Flask

cascade_file = 'haarcascade_frontalface_default.xml'
resize_scale = 3
image_size = 64
face_cascade = cv2.CascadeClassifier(cascade_file)

def get_single_face():
    web_cam = cv2.VideoCapture(0)
    (_, image_) = web_cam.read()

    gray_image = cv2.cvtColor(image_, cv2.COLOR_BGR2GRAY)
    mini_image = cv2.resize(gray_image,
                            ((int)(gray_image.shape[1] / resize_scale), (int)(gray_image.shape[0] / resize_scale)))
    faces = face_cascade.detectMultiScale(mini_image)

    if not len(faces)==0:
        face_i = faces[0]

        (x, y, w, h) = (v * resize_scale for v in face_i)

        # Numpy slicing image
        face = gray_image[y:y + h, x:x + w]
        face_resize = cv2.resize(face, (image_size, image_size))

        cv2.rectangle(image_, (x, y), (x + w, y + h), (0, 255, 0), 3)

        cv2.destroyAllWindows()
        web_cam.release()

        return (1, face, image_)
    else:
        return (0, image_)