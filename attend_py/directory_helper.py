import os
from pathlib import Path


def get_uploads_dir():
    curr_path = Path().absolute()
    proj_path = Path(curr_path).parents[0]
    uploads_path = Path.joinpath(proj_path, "uploads")
    return uploads_path

def get_path(user_id):
    up_path = get_uploads_dir()
    user_images_path = Path.joinpath(up_path, str(user_id))
    if not Path.is_dir(user_images_path):
        Path.mkdir(user_images_path)
    return user_images_path

def get_last_dir(path):
    sorted_paths = sorted(os.listdir(path))
    if not sorted_paths:
        return 0
    else:
        return 1