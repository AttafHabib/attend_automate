import os
import pickle

import cv2
import sys

import numpy as np
import cv2
# from PIL import Image
import os

from directory_helper import get_path
from face_extractor import get_single_face_

from label import create_labels




def train(path):
    (images, labels) = create_labels(path)
    recognizer = cv2.face.LBPHFaceRecognizer_create()
    detector = cv2.CascadeClassifier("haarcascade_frontalface_default.xml")
    recognizer.train(images, labels)

    recognizer.write('trained_model.yml')

# def train1(path):
#     (images, labels) = create_labels(path)
#     recognizer = cv2.face.LBPHFaceRecognizer_create(radius=2, neighbors=16, grid_x=8, grid_y=8)
#     detector = cv2.CascadeClassifier("haarcascade_frontalface_default.xml")
#     recognizer.train(images, labels)
#
#     recognizer.write('trained_model1.yml')

def recognize():
    recognizer = cv2.face.LBPHFaceRecognizer_create()
    recognizer.read('trained_model.yml')
    cascadePath = "haarcascade_frontalface_default.xml"
    faceCascade = cv2.CascadeClassifier(cascadePath)
    font = cv2.FONT_HERSHEY_SIMPLEX
    url = "http://192.168.1.100:8080/video"
    web_cam = cv2.VideoCapture(url)
    web_cam.set(3, 640)  # set video widht
    web_cam.set(4, 480)  # set video height
    minW = 0.1 * web_cam.get(3)
    minH = 0.1 * web_cam.get(4)

    while True:
        ret, im = web_cam.read()
        gray_image = cv2.cvtColor(im, cv2.COLOR_BGR2GRAY)

        faces = faceCascade.detectMultiScale(gray_image,scaleFactor=1.2,minNeighbors=5,minSize=(int(minW), int(minH)),)

        for (x, y, w, h) in faces:

            cv2.rectangle(im, (x, y), (x + w, y + h), (0, 255, 0), 2)
            id, conf = recognizer.predict(gray_image[y:y + h, x:x + w])

            cv2.putText(im, str(id), (x + 5, y - 5), font, 1, (255, 255, 255), 2)
            cv2.putText(im, str(conf), (x + 5, y + h - 5), font, 1, (255, 255, 0), 1)

        cv2.imshow("dnn", im)
        q = cv2.waitKey(10)
        if q == ord("q"):
            break
    # while True:

def recognize1():
    recognizer = cv2.face.LBPHFaceRecognizer_create()
    recognizer.read('trained_model.yml')
    font = cv2.FONT_HERSHEY_SIMPLEX
    url = "http://192.168.1.100:8080/video"
    web_cam = cv2.VideoCapture(url)
    # web_cam.set(3, 640)  # set video widht
    # web_cam.set(4, 480)  # set video height
    while True:
        f_images = get_single_face_(web_cam)
        if f_images[0]:
            face = f_images[1]
            box = f_images[1]
            full_image = f_images[2]
            (x, y, w, h) = box.astype("int")
            face = full_image[y:h, x:w]

            id, conf = recognizer.predict(face)
            print(id, conf)
            cv2.rectangle(full_image, (x, y), (w, h), (0, 0, 255), 2)

            cv2.putText(full_image, str(id), (x + 5, y - 5), font, 1, (255, 255, 255), 2)
            cv2.putText(full_image, str(conf), (x + 35, y - 5), font, 1, (255, 255, 0), 2)
        else:
            print("Not Found")

        cv2.imshow("dnn", full_image)
        q = cv2.waitKey(10)
        if q == ord("q"):
            break

#     ret, im = web_cam.read()
#     gray = cv2.cvtColor(im, cv2.COLOR_BGR2GRAY)
#     faces = faceCascade.detectMultiScale(gray, 1.5, 5)
#
#     for (x, y, w, h) in faces:
#         id, conf = recognizer.predict(gray[y:y + h, x:x + w])
#         cv2.rectangle(im, (x, y), (x + w, y + h), (0, 260, 0), 7)
#
#         print(id, conf)
#
#         # If confidence is less them 100 ==> "0" : perfect match
#         # if (conf < 100):
#         #     conf = "  {0}%".format(round(100 - conf))
#         # else:
#         #     id = "unknown"
#         #     conf = "  {0}%".format(round(100 - conf))
#
#         cv2.putText(im, str(id), (x + 5, y - 5), font,  1,  (255, 255, 255), 2 )
#         # cv2.putText(im, str(Id), (x, y - 40), font, 2, (255, 255, 255), 3)
#
# cv2.imshow('im', face)
# cv2.waitKey(0)
# id, conf = recognizer.predict(face)
# print(id, conf)


# cascade_file = 'haarcascade_frontalface_default.xml'
# resize_scale = 3
# image_size = 64
# face_cascade = cv2.CascadeClassifier(cascade_file)
#
# web_cam = cv2.VideoCapture(0)
# (_, image_) = web_cam.read()
#
# gray_image = cv2.cvtColor(image_, cv2.COLOR_BGR2GRAY)
# mini_image = cv2.resize(gray_image, ((int)(gray_image.shape[1]/resize_scale), (int)(gray_image.shape[0]/resize_scale)))
# faces = face_cascade.detectMultiScale(mini_image)
#
# face_i = faces[0]
#
# (x,y, w, h) = (v * resize_scale for v in face_i)
#
# # Numpy slicing image
# face = gray_image[y:y + h, x:x + w]
# face_resize = cv2.resize(face, (image_size, image_size))
#
# cv2.rectangle(image_, (x, y), (x + w, y + h), (0, 255, 0), 3)
#
# cv2.imshow("gray_image", face)
#
# cv2.waitKey()

# def save_face(face_image, user_id, image_no):
#     get_path(user_id)

#
# def faceSampling():
#     # cam = cv2.VideoCapture('http://192.168.1.100:8080/video')
#     cam = cv2.VideoCapture(0)
#     cam.set(3, 640) # set video width
#     cam.set(4, 480) # set video height
#
#     face_detector = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')
#
#     name = input('Enter name for the Face: ')
#
#     print('''\n
#     Look in the camera Face Sampling has started!.
#     Try to move your face and change expression for better face memory registration.\n
#     ''')
#     # Initialize individual sampling face count
#     count = 0
#
#     while(True):
#
#         ret, img = cam.read()
#         gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
#         faces = face_detector.detectMultiScale(gray, 1.3, 5)
#
#         for (x,y,w,h) in faces:
#
#             cv2.rectangle(img, (x,y), (x+w,y+h), (255,0,0), 2)
#             count += 1
#
#             # Save the captured image into the datasets folder
#             cv2.imwrite("dataset/"+name+"." + str(count) + '.' + str(count) + ".jpg", gray[y:y+h,x:x+w])
#
#             cv2.imshow('image', img)
#
#         print(count)
#
#         k = cv2.waitKey(100) & 0xff # Press 'ESC' for exiting video
#         if k == 27:
#             break
#         elif count >= 80: # Take 80 face sample and stop video
#              break
#
#     # Do a bit of cleanup
#     print("Your Face has been registered as {}\n\nExiting Sampling Program".format(name.upper()))
#     cam.release()
#     cv2.destroyAllWindows()
# def faceLearning():
#     # Path for face image database
#     path = 'dataset'
#
#     recognizer =  cv2.face.FisherFaceRecognizer_create()
#
#     (images, labels) = create_labels(path)
#     print(images)
#     print(labels)
#     recognizer.train(images, labels)
#
#     # Save the model into trainer/trainer.yml
#     recognizer.write('trainer1.yml')
#
#     # Print the numer of faces trained and end program
#     # print("{0} faces trained. Exiting Training Program".format(len(np.unique(ids))))
# def faceRecognition():
#     print('\nStarting Recognizer....')
#     # recognizer = cv2.face.LBPHFaceRecognizer_create()
#     recognizer = cv2.face.FisherFaceRecognizer_create()
#     recognizer.read('trainer1.yml')
#     cascadePath = "haarcascade_frontalface_default.xml"
#     faceCascade = cv2.CascadeClassifier(cascadePath);
#
#     font = cv2.FONT_HERSHEY_SIMPLEX
#
#     # Starting realtime video capture
#     cam = cv2.VideoCapture(0)
#     # cam = cv2.VideoCapture('http://192.168.1.100:8080/video')
#     cam.set(3, 640) # set video widht
#     cam.set(4, 480) # set video height
#
#     # Define min window size to be recognized as a face
#     minW = 0.1*cam.get(3)
#     minH = 0.1*cam.get(4)
#
#     while True:
#
#         ret, img =cam.read()
#
#         gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
#
#         faces = faceCascade.detectMultiScale(
#             gray,
#             scaleFactor = 1.2,
#             minNeighbors = 5,
#             minSize = (int(minW), int(minH)),
#            )
#
#         for(x,y,w,h) in faces:
#
#             cv2.rectangle(img, (x,y), (x+w,y+h), (0,255,0), 2)
#             g_image = gray[y:y + h, x:x + w]
#             # g_image = cv2.equalizeHist(g_image)
#             g_image = cv2.resize(g_image, (100, 100))
#
#             id, confidence = recognizer.predict(g_image)
#             id_=id
#
#             # Check if confidence is less them 100 ==> "0" is perfect match
#             if (confidence < 100):
#                 id_ = id_
#                 confidence = "  {0}%".format(round(100 - confidence))
#             else:
#                 id_ = "unknown"
#                 confidence = "  {0}%".format(round(100 - confidence))
#
#             cv2.putText(img, str(id_), (x+5,y-5), font, 1, (255,255,255), 2)
#             cv2.putText(img, str(confidence), (x+5,y+h-5), font, 1, (255,255,0), 1)
#
#         cv2.imshow('camera',img)
#
#         k = cv2.waitKey(10) & 0xff # Press 'ESC' for exiting video
#         if k == 27:
#             break
#
#     # Do a bit of cleanup
#     print("\nExiting Recognizer.")
#     cam.release()
#     cv2.destroyAllWindows()
#
