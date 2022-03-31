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
            hash_fields = {}

            for i in range(64):
                hash_fields['hash_' + str(i)] = {
                    'type': 'boolean'
                }

            properties = {
                'image_file_name': {'type': 'keyword'},
                'hash_type': {'type': 'keyword'},
            }

            properties.update(hash_fields)

            # create hash storage index
            request_body = {
                'settings': {
                    'number_of_shards': 1
                },

                'mappings': {
                    'image': {
                        'properties': properties
                    }
                }
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

            # https://github.com/JohannesBuchner/imagehash/issues/51
            # https://stackoverflow.com/questions/61791924
            curr_hash_flattened = curr_hash.hash.flatten().tolist()
            hash_fields = {}

            for i in range(len(curr_hash_flattened)):
                hash_fields['hash_' + str(i)] = curr_hash_flattened[i]

            data_dict = {
                'image_file_name': curr_image,
                'hash_type': hash_type,
            }

            data_dict.update(hash_fields)

            res = es.index(
                index='hash_index',
                doc_type='image',
                body=data_dict
            )

            print("\n", res)
            print(dir(res))


if __name__ == "__main__":
    # configure elasticsearch
    es = Elasticsearch("http://localhost:2200")
    store_hash.create_index()
    store_hash.insert_hashes()
