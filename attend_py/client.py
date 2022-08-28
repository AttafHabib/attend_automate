import io

import cv2
from flask import Flask, send_file, Response, make_response
from face_extractor import get_single_face
from io_helper import save_image

app = Flask(__name__)

@app.route("/user/<id>/extract")
def get_user_face(id):
    face = get_single_face()
    save_image(face[1], id)

    if face[0]:
        retval, buffer = cv2.imencode('.png', face[1])
        response = make_response(buffer.tobytes(), 200)
        response.headers['Content-Type'] = 'image/png'
        return response
    else:
        retval, buffer = cv2.imencode('.png', face[1])
        response = make_response(buffer.tobytes(), 404)
        response.headers['Content-Type'] = 'image/png'
        return response
