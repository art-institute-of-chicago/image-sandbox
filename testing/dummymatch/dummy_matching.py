import os 
import random
class dummy_matching():
    def match_image(file_path):
        downloaded_path = "../matching/images/downloaded"
        image_file = random.choice(os.listdir(downloaded_path))
        return image_file.split(".",1)[0]