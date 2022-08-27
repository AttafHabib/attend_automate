# # psycopg2
# import psycopg2
import cv2
#
# database="attend_automate_dev"
# user="postgres"
# password="postgres"
# hostname="localhost"
#
# def connect():
#     conn = None
#     try:
#         # connect to postgres
#         conn = psycopg2.connect(f'dbname={database} user={user} password={password} host={hostname}')
#
#         return conn
#     except (Exception, psycopg2.DatabaseError) as error:
#         return conn
#     # finally:
#     #     if conn is not None:
#     #         conn.close()
#     #         print('Database connection closed.')
#
def save_image(image, path, no):
    cv2.imwrite('%s/%s.png' % (path, no), image)
