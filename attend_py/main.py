import ntpath
import os
import sys

import cv2

from directory_helper import get_filepaths_with_glob, get_path
from face_extractor import get_single_face
from io_helper import save_image, save_rect_image

# print(get_path(2))

# path = get_path(2)
# files = []
# for file in get_filepaths_with_glob(path, r'*[0-9]*.png'):
#     file = ntpath.basename(file)
#     file_without_ext = os.path.splitext(file)[0]
#     files.append(file_without_ext)
# files = sorted(files, key=lambda x: int(x))
# print(files)
# print(get_filepaths_with_glob(path, r'*[0-9]*.png'))
# sorted_paths = sorted(get_filepaths_with_glob(path, r'*[0-9]*.png'))
# print(sorted_paths)

f_images = get_single_face()
f_image = save_image(f_images[1], 2)
# rect_image = save_rect_image(f_images[2], 2)
# cv2.imshow("f", face[2])
# cv2.waitKey()
# save_image(face[1], 2)
# save_image(face[1], 2)
# print(get_filepaths_with_glob("/home/attaf/Projects/attend_automate/uploads/2/", r'*[0-9]*.png'))