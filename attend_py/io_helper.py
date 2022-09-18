import os

from directory_helper import get_path, get_last_dir, get_uploads_dir
import cv2

from label import get_random_string


def save_image(image, user_id, user_name):
    path = get_path(user_id)
    # new_img_no = (int)(get_last_dir(path)) + 1
    # cv2.imwrite('%s/%s_%s.png' % (path, user_name, new_img_no), image)
    cv2.imwrite('%s/%s.png' % (path, user_name), image)
    # return '%s_%s.png' % (user_name, new_img_no)
    return '%s.png' % (user_name)


def save_rect_image(image, user_id):
    path = get_uploads_dir()
    # print(path)
    cv2.imwrite('%s/%s.png' % (path, "face_rect"), image)
    return "face_rect.png"


def save_recog_image(image):
    path = get_uploads_dir()
    file_name = get_random_string(8) + '_processed.png'
    file_path = str(path) + '/' + file_name
    # file_name = '%s/%_%s.png' % (path, get_random_string(6), "processed")
    cv2.imwrite(file_path, image)
    return file_name
