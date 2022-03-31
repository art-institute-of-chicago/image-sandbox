import sys
import image_hash
from elasticsearch import Elasticsearch
from PIL import Image
import imagehash


class search_hash():
    def get_hash(file_path):
        image_hash = imagehash.average_hash(Image.open(file_path))
        return image_hash

    def create_query(image_hash):
        # https://github.com/JohannesBuchner/imagehash/issues/51
        # https://stackoverflow.com/questions/61791924
        curr_hash_flattened = image_hash.hash.flatten().tolist()

        hash_fields = []
        for i in range(len(curr_hash_flattened)):
            term = {}
            term['term'] = {'hash_' + str(i): curr_hash_flattened[i]}
            hash_fields.append(term)

        query_dict = {
            'query': {
                'bool': {
                    'minimum_should_match': '80%',
                    'should': hash_fields
                }
            }
        }
        return query_dict

    def match_image(file_path):
        es = Elasticsearch("http://localhost:2200")
        image_hash = search_hash.get_hash(file_path)
        query = search_hash.create_query(image_hash)
        res = es.search(index="hash_index", doc_type="image", body=query)
        num_hits = res['hits']['total']
        if (num_hits < 1):
            return("no match")
        else:
            output_match = res['hits']['hits'][0]['_source']['image_file_name']
            return output_match


if __name__ == "__main__":
    print(search_hash.match_image(sys.argv[1]))
