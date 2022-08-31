import glob
import ntpath
import os
from pathlib import Path


def get_uploads_dir():
    curr_path = Path().absolute()
    proj_path = Path(curr_path).parents[0]
    uploads_path = Path.joinpath(proj_path, "apps/app_web/priv/uploads")
    return uploads_path

def get_path(user_id):
    up_path = get_uploads_dir()
    user_images_path = Path.joinpath(up_path, str(user_id))
    if not Path.is_dir(user_images_path):
        Path.mkdir(user_images_path)
    return user_images_path

def get_last_dir(path):
    files = []
    for file in get_filepaths_with_glob(path, r'*[0-9]*.png'):
        file = ntpath.basename(file)
        file_without_ext = os.path.splitext(file)[0]
        files.append(file_without_ext)
    files = sorted(files, key=lambda x: int(x))
    if not files:
        return 0
    else:
        return files[-1]

def get_filepaths_with_glob(root_path: str, file_regex: str):
    return glob.glob(os.path.join(root_path, file_regex))