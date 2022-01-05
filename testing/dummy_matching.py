import os
import random


class dummy_matching():
    def match_image(file_path):
        downloaded_path = "../matching/images/downloaded"
        images = [x for x in os.listdir(downloaded_path) if x.endswith(".jpg")]
        image_file = random.choice(images)
        return image_file.split(".", 1)[0]
