from pathlib import Path


def get_uploads_dir():
    curr_path = Path().absolute()
    proj_path = Path(curr_path).parents[0]
    uploads_path = Path.joinpath(proj_path, "uploads")
    return uploads_path

def get_path(user_id):
    up_path = get_uploads_dir()
    