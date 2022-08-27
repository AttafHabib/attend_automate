from pathlib import Path

curr_path = Path().absolute()
proj_path = Path(curr_path).parents[0]
uploads_path = Path.joinpath(proj_path, "uploads")
