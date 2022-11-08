import face_recognition
import cv2
import numpy as np

from directory_helper import get_uploads_dir
from io_helper import save_recog_image
from label import get_images_labels, get_encoding_labels


def recognize_face():
    path = get_uploads_dir()
    labels = get_images_labels(path)
    (encodings, names) = get_encoding_labels(labels)

    (test_loc, test_enc, test_image) = get_test_location_encoding()

    recognized_names, recognized_ids = match_face(names, encodings, test_enc)

    draw_rectangle(test_loc, test_image, recognized_names)

    file_name = save_recog_image(test_image)

    return recognized_ids, file_name

def get_test_location_encoding():
    # url = "http://192.168.1.100:8080/video"
    # web_cam = cv2.VideoCapture(url)
    # web_cam = cv2.VideoCapture(0)
    #
    # x, test_img = web_cam.read()

    test_img = cv2.imread('testing_data/4.jpg')
    rgb_image = test_img[:, :, ::-1]

    loc = face_recognition.face_locations(rgb_image)
    enc = face_recognition.face_encodings(rgb_image, loc)

    return loc, enc, test_img


def match_face(known_names, known_enc, test_enc):
    (names, ids) = [], []
    for enc in test_enc:
        name = 'Unknown'
        face_distances = face_recognition.face_distance(known_enc, enc) # get euclidean distance
        results = list(face_distances <= 0.45) # list of true/false result

        match_index = np.argmin(face_distances) # get indexes of min distance
        print(match_index)
        # check if result at that index satisfies threshold
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













# def train(path):
#     (images, labels) = create_labels(path)
#     recognizer = cv2.face.LBPHFaceRecognizer_create()
#     detector = cv2.CascadeClassifier("haarcascade_frontalface_default.xml")
#     recognizer.train(images, labels)
#
#     recognizer.write('trained_model.yml')