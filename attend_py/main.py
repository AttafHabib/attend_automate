from face_extractor import get_single_face
from io_helper import save_image

face = get_single_face()
save_image(face, 2)
