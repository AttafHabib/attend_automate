import os
import sys

from directory_helper import get_filepaths_with_glob, get_path
from face_extractor import get_single_face
from io_helper import save_image

# print(get_path(2))

face = get_single_face()
# save_image(face[1], 2)
save_image(face[1], 2)
# print(get_filepaths_with_glob("/home/attaf/Projects/attend_automate/uploads/2/", r'*[0-9]*.png'))