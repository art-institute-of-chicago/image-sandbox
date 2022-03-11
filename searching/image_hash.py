from PIL import Image
import imagehash
import os

hashfuncs = [
    ('ahash', imagehash.average_hash),
    ('phash', imagehash.phash),
    ('dhash', imagehash.dhash),
    ('whash', imagehash.whash)
]

FILE_PATH = "../matching/images/downloaded"


class image_hash():
    def get_image_directory():
        image_directory = [x for x in os.listdir(FILE_PATH)
                           if x.endswith(".jpg")]
        return image_directory

    def image_loader(hashfunc):
        def function(path):
            image = Image.open(path)
            return hashfunc(image)
        return function

    def generate_hashes(image_directory):
        hashfuncopeners = [(name, image_hash.image_loader(func)) for
                           name, func in hashfuncs]
        image_hashes = {}
        for image in image_directory:
            path = FILE_PATH + '/' + image
            hashes = [(name, hashfuncopener(path)) for name,
                      hashfuncopener in hashfuncopeners]
            image_hashes[image] = hashes
        return image_hashes


if __name__ == "__main__":
    images = image_hash.get_image_directory()
    # print(images)
    print(image_hash.generate_hashes(images))
