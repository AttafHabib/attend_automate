import ntpath
import sys
import time
from pathlib import Path
import shutil

import cv2, numpy, os
import pickle

from directory_helper import get_uploads_dir, get_path, get_last_dir
from face_extractor import get_single_face, get_single_face_, align_face, get_multiple_faces
from io_helper import save_image
from label import create_labels, get_images_labels
from recognizer import train, recognize_face

# from recognizer import train, recognize, recognize2, recognize3, recognize_face

# s_face = "face_recognition_sface_2021dec.onnx"

# path = get_uploads_dir()
# url = "http://192.168.1.101:8080/video"
# url = "http://192.168.2.132:8080/video"
# web_cam = cv2.VideoCapture(url)

# (images, labels) = create_labels(path)
# #
# recognizer = cv2.face.LBPHFaceRecognizer_create(radius=2, neighbors=16, grid_x=8, grid_y=8)
# global detector
# detector = cv2.CascadeClassifier("haarcascade_frontalface_default.xml")
# #
# start = time.time()
# recognizer.train(images, numpy.array(labels))
# end = time.time()
# print("[INFO] training took {:.4f} seconds".format(end - start))
#
# recognizer.save("trained_model.yml")



# recognizer = cv2.face.LBPHFaceRecognizer_create()
# recognizer.read('trained_model.yml')
# cascadePath = "haarcascade_frontalface_default.xml"
# faceCascade = cv2.CascadeClassifier(cascadePath)
# font = cv2.FONT_HERSHEY_SIMPLEX
# (x, face, full_image) = get_single_face()



# while True:
#     (_, im) = web_cam.read()
#     gray = cv2.cvtColor(im, cv2.COLOR_BGR2GRAY)
#     faces = faceCascade.detectMultiScale(gray, 1.5, 5)
#
    # for (x, y, w, h) in faces:
    #     id, conf = recognizer.predict(gray[y:y + h, x:x + w])
    #     cv2.rectangle(im, (x, y), (x + w, y + h), (0, 260, 0), 7)

        # print(id, conf)
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
#     cv2.imshow("dnn", im)
#     q = cv2.waitKey(10)
#     if q==ord("q"):
#             break
    # web_cam.release()
    # cv2.destroyAllWindows()

# recognizer = cv2.face.LBPHFaceRecognizer_create()
# recognizer.read('trained_model.yml')
# cascadePath = "haarcascade_frontalface_default.xml"
# faceCascade = cv2.CascadeClassifier(cascadePath)
# font = cv2.FONT_HERSHEY_SIMPLEX
# url = "http://192.168.2.132:8080/video"
# web_cam = cv2.VideoCapture(0)
# web_cam.set(3, 640)  # set video widht
# web_cam.set(4, 480)  # set video height
# minW = 0.1 * web_cam.get(3)
# minH = 0.1 * web_cam.get(4)

# while True:
#     ret, im = web_cam.read()
#     gray_image = cv2.cvtColor(im, cv2.COLOR_BGR2GRAY)
#     faces = faceCascade.detectMultiScale(gray_image, scaleFactor=1.2, minNeighbors=5, minSize=(int(minW), int(minH)), )
#
#     for (x, y, w, h) in faces:
#         cv2.rectangle(im, (x, y), (x + w, y + h), (0, 255, 0), 2)
#         id, conf = recognizer.predict(gray_image[y:y + h, x:x + w])
#
#         cv2.putText(im, str(id), (x + 5, y - 5), font, 1, (255, 255, 255), 2)
#         cv2.putText(im, str(conf), (x + 5, y + h - 5), font, 1, (255, 255, 0), 1)
#
#     cv2.imshow('camera', im)
#
#     cv2.waitKey(0)
#     web_cam.release()
#     cv2.destroyAllWindows()



# cascade_file1 = 'res10_300x300_ssd_iter_140000.caffemodel'
# config_file1 = 'deploy.prototxt.txt'
# net = cv2.dnn.readNetFromCaffe(config_file1, cascade_file1)
# web_cam = cv2.VideoCapture(0)
# web_cam = cv2.VideoCapture(url)
#
# while(True):
#     (_, image_) = web_cam.read()
#     height, width = image_.shape[:2]
#     resized_image = cv2.resize(image_, (300, 300))
#
#     # ImageNet mean rgb pixel intensity values
#     blob = cv2.dnn.blobFromImage(resized_image, 1.0, (600,600), (104.0, 117.0, 123.0))
#
#     net.setInput(blob)
#     faces = net.forward()
#     # OPENCV DNN
#     #[,frame, no of detections, [classid, class score, conf, x,y,h,w]]
#     for i in range(faces.shape[2]):
#         confidence = faces[0, 0, i, 2]
#         # ensure confidence is greater than minimum confidence
#         if confidence > 0.5:
#             # compute coordinates of the bounding box
#             box = faces[0, 0, i, 3:7] * numpy.array([width, height, width, height])
#             (x, y, w, h) = box.astype("int")
#             face = image_[y:h, x:w]
#             (x_start, y_start, x_end, y_end) = box.astype("int")
#             cv2.rectangle(image_, (x_start, y_start), (x_end, y_end), (0, 0, 255), 2)
# #     camera, frame = cp.read()
# #     if frame is not None:
# #         cv2.imshow("Frame", frame)
#     cv2.imshow("dnn", image_)
#     q = cv2.waitKey(10)
#     if q==ord("q"):
#         break
# cv2.destroyAllWindows()

# path = get_uploads_dir()
# path = 'dataset'
# path = get_uploads_dir()
# train(path)
# train1(path)

# recognize()
# recognize2()
# recognize3()
# web_cam = cv2.VideoCapture(0)
# get_multiple_faces(web_cam)
#
# recognized_ids, file_name = recognize_face()
# path = get_uploads_dir()
recognize_face()
# get_images_labels(path)
# recognize3()
# url = "http://192.168.1.100:8080/video"
# web_cam = cv2.VideoCapture(url)
# faces = get_single_face_(web_cam)
# box = faces[1]
# full_image = faces[3]
# (x, y, w, h) = box.astype("int")
# face = full_image[y:h, x:w]
#
# align_face(face, web_cam)

# faceSampling()
# faceLearning()
# faceRecognition()