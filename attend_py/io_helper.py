from directory_helper import get_path, get_last_dir
import cv2

def save_image(image, user_id):
    path = get_path(user_id)
    new_img_no = (int)(get_last_dir(path)) + 1
    cv2.imwrite('%s/%s.png' % (path, new_img_no), image)
    return ('%s.png' % new_img_no)
def save_rect_image(image, user_id):
    path = get_path(user_id)
    # print(path)
    cv2.imwrite('%s/%s.png' % (path, "face_rect"), image)
    return ("face_rect.png")