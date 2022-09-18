import face_recognition
import cv2
import numpy as np

from directory_helper import get_uploads_dir
from face_extractor import get_single_face_, get_multiple_faces
from io_helper import save_recog_image
from label import create_labels, get_images_labels, get_encoding_labels


def train(path):
    (images, labels) = create_labels(path)
    recognizer = cv2.face.LBPHFaceRecognizer_create()
    detector = cv2.CascadeClassifier("haarcascade_frontalface_default.xml")
    recognizer.train(images, labels)

    recognizer.write('trained_model.yml')


# def recognize():
#     recognizer = cv2.face.LBPHFaceRecognizer_create()
#     recognizer.read('trained_model.yml')
#     font = cv2.FONT_HERSHEY_SIMPLEX
#     url = "http://192.168.1.100:8080/video"
#     web_cam = cv2.VideoCapture(url)
#     # web_cam.set(3, 640)  # set video widht
#     # web_cam.set(4, 480)  # set video height
#     f_images = get_multiple_faces(web_cam)
#     (gray_img, full_image) = f_images[0]
#     del f_images[0]
#     for box in f_images:
#         # box = f_images[1]
#         # full_image = f_images[2]
#         (x, y, w, h) = box.astype("int")
#         face = gray_img[y:h, x:w]
#         id, conf = recognizer.predict(face)
#         print(id, conf)
#         if conf < 100:
#             cv2.rectangle(full_image, (x, y), (w, h), (0, 0, 255), 2)
#
#             cv2.putText(full_image, str(id), (x + 5, y - 5), font, 1, (255, 255, 255), 2)
#             cv2.putText(full_image, str(conf), (x + 35, y - 5), font, 1, (255, 255, 0), 2)
#     rec_ids = []
#     # if f_images[0]:
#     #     # face = f_images[1]
#     #     box = f_images[1]
#     #     full_image = f_images[2]
#     #     (x, y, w, h) = box.astype("int")
#     #     face = full_image[y:h, x:w]
#     #     id, conf = recognizer.predict(face)
#     #     print(id, conf)
#     #     cv2.rectangle(full_image, (x, y), (w, h), (0, 0, 255), 2)
#     #
#     #     cv2.putText(full_image, str(id), (x + 5, y - 5), font, 1, (255, 255, 255), 2)
#     #     cv2.putText(full_image, str(conf), (x + 35, y - 5), font, 1, (255, 255, 0), 2)
#     # else:
#     #     print("Not Found")
#
#     image_ = cv2.resize(full_image, (1200, 1200))
#     cv2.imshow("dnn", image_)
#     q = cv2.waitKey(0)
#     if q == ord("q"):
#         cv2.destroyAllWindows()


# def recognize2():
#     recognizer = cv2.face.LBPHFaceRecognizer_create()
#     recognizer.read('trained_model.yml')
#     cascadePath = "haarcascade_frontalface_default.xml"
#     faceCascade = cv2.CascadeClassifier(cascadePath)
#     font = cv2.FONT_HERSHEY_SIMPLEX
#     url = "http://192.168.1.100:8080/video"
#     web_cam = cv2.VideoCapture(url)
#     web_cam.set(3, 640)  # set video widht
#     web_cam.set(4, 480)  # set video height
#     minW = 0.1 * web_cam.get(3)
#     minH = 0.1 * web_cam.get(4)
#
#     ret, im = web_cam.read()
#     im = cv2.imread('3.jpg')
#
#     gray_image = cv2.cvtColor(im, cv2.COLOR_BGR2GRAY)
#
#     faces = faceCascade.detectMultiScale(gray_image, scaleFactor=1.2, minNeighbors=5, minSize=(int(minW), int(minH)), )
#
#     for (x, y, w, h) in faces:
#         cv2.rectangle(im, (x, y), (x + w, y + h), (0, 255, 0), 2)
#         id, conf = recognizer.predict(gray_image[y:y + h, x:x + w])
#         print(id, conf)
#
#         cv2.putText(im, str(id), (x + 5, y - 5), font, 1, (255, 255, 255), 2)
#         cv2.putText(im, str(conf), (x + 5, y + h - 5), font, 1, (255, 255, 0), 1)
#
#     im = cv2.resize(im, (960, 540))
#     cv2.imshow("dnn", im)
#     q = cv2.waitKey(0)
#     if q == ord("q"):
#         cv2.destroyAllWindows()
#     # while True:


def recognize_face():
    path = get_uploads_dir()
    labels = get_images_labels(path)
    (encodings, names) = get_encoding_labels(labels)

    (test_loc, test_enc, test_image) = get_test_location_encoding()

    recognized_names, recognized_ids = match_face(names, encodings, test_enc)

    draw_rectangle(test_loc, test_image, recognized_names)
    # test_image=cv2.resize(test_image, (1500,1200))

    file_name = save_recog_image(test_image)

    return recognized_ids, file_name
    #
    # cv2.imshow('Video', test_image)
    #
    # q = cv2.waitKey(0)
    # if q == ord("q"):
    #     cv2.destroyAllWindows()


def get_test_location_encoding():
    url = "http://192.168.1.100:8080/video"
    web_cam = cv2.VideoCapture(url)

    x, test_img = web_cam.read()

    # test_img = cv2.imread('2.jpg')
    rgb_image = test_img[:, :, ::-1]

    loc = face_recognition.face_locations(rgb_image)
    enc = face_recognition.face_encodings(rgb_image, loc)

    return loc, enc, test_img


def match_face(known_names, known_enc, test_enc):
    (names, ids) = [], []
    for enc in test_enc:
        name = 'Unknown'
        results = face_recognition.compare_faces(known_enc, enc, 0.45)
        face_distances = face_recognition.face_distance(known_enc, enc)

        match_index = np.argmin(face_distances)
        if results[match_index]:
            name = known_names[match_index]
            name_list = name.split('-')
            name = name_list[1]
            ids.append(name_list[0])

        names.append(name)
    return names, ids


def draw_rectangle(locations, image, labels):
    for (x, y, w, h), label in zip(locations, labels):
        cv2.rectangle(image, (h, x), (y, w), (0, 0, 255), 2)
        font = cv2.FONT_HERSHEY_SIMPLEX
        cv2.putText(image, label.capitalize(), (h + 5, w - 5), font, 1, (5, 248, 2), 2)
