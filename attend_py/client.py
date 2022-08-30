import io

import cv2
from flask import Flask, send_file, Response, make_response
from face_extractor import get_single_face
from io_helper import save_image, save_rect_image

app = Flask(__name__)

@app.route("/user/<id>/extract")
def get_user_face(id):
    f_images = get_single_face()

    if f_images[0]:
        f_image = save_image(f_images[1], id)
        rect_image = save_rect_image(f_images[2], id)
        data = {"data": {"f_image": f_image, "full_image": rect_image}, "message": "Image Extracted"}

        response = make_response(data, 200)

        # retval, buffer = cv2.imencode('.png', f_images[1])
        # response = make_response(buffer.tobytes(), 200)
        # response.headers['Content-Type'] = 'image/png'
        response.headers['Content-Type'] = 'application/json'
        return response
    else:
        rect_image = save_rect_image(f_images[1], id)
        data = {"data": {"f_image": None, "rect_image": rect_image}, "message": "Error"}

        response = make_response(data, 400)

        # retval, buffer = cv2.imencode('.png', f_images[1])
        # response = make_response(buffer.tobytes(), 404)
        response.headers['Content-Type'] = 'application/json'
        return response