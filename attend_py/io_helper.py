from directory_helper import get_path, get_last_dir, get_uploads_dir
import cv2

def save_image(image, user_id, user_name):
    path = get_path(user_id)
    new_img_no = (int)(get_last_dir(path)) + 1
    cv2.imwrite('%s/%s_%s.png' % (path, user_name, new_img_no), image)
    return ('%s_%s.png' % (user_name, new_img_no))
def save_rect_image(image, user_id):
    path = get_uploads_dir()
    # print(path)
    cv2.imwrite('%s/%s.png' % (path, "face_rect"), image)
    return ("face_rect.png")