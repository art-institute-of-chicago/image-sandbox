import sys
import image_hash
import json
from elasticsearch import Elasticsearch
import datetime
import re


class store_hash():
    def create_index():
        if es.indices.exists(index='hash_index'):
            print("index exists...")
            # store_hash.insert_hashes()

        else:
            # create hash storage index
            request_body = {
                    "settings": {
                        "number_of_shards": 1
                    },

                    'mappings': {
                        'image': {
                            'properties': {
                                'image_file_name': {'type': 'keyword'},
                                'hash_type': {'type': 'keyword'},
                                'image_hash': {'type': 'text'}
                            }}}
            }
            print("creating 'hash_index' index...")
            es.indices.create(index='hash_index', body=request_body)
            print("index created...")
            print("_mapping response:",
                  json.dumps(request_body, indent=4), "\n")
            # store_hash.insert_hashes()

    def insert_hashes():
        # get image hashes to store in elasticsearch index
        image = image_hash.image_hash
        images = image.get_image_directory()
        image_hashes = image.generate_hashes(images)

        # insert hashes into index format
        for curr_image in image_hashes:
            curr_hashes = image_hashes[curr_image]
            hash_type = curr_hashes[0][0]
            curr_hash = curr_hashes[0][1]
            print(curr_image, hash_type, curr_hash)
            data_dict = {
                'image_file_name': curr_image,
                'hash_type': hash_type,
                'image_hash': curr_hash
            }
            res = es.index(index='hash_index',
                           doc_type='image', body=data_dict)
            print("\n", res)
            print(dir(res))


if __name__ == "__main__":
    # configure elasticsearch
    es = Elasticsearch("http://localhost:2200")
    store_hash.create_index()
    store_hash.insert_hashes()
