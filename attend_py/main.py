import os
import sys

from face_extractor import get_single_face
from io_helper import save_image

face = get_single_face()
print(face[0])
# save_image(face, 2)