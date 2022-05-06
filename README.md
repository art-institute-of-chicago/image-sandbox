![Art Institute of Chicago](https://raw.githubusercontent.com/Art-Institute-of-Chicago/template/master/aic-logo.gif)

# image-sandbox

The image sandbox contains the infrastructure for implementing a reverse image search using image hashing and fingerprinting. 
This reverse image search functionality allows for a desired image to be inputted by the user and for visually similar images to be returned by the 
infrastructure. There are a myraid of applications that can stem from this infrastructure such as finding duplicate images in the website's media library, 
matching artwork at the Art Institute of Chicago to other museums, and allowing a search by image feature on the museum's website. This project currently focuses 
on applying the reverse image search infrastructure towards creating a prototype search by image feature on the museum dashboard. 

## Features
* Downloads and converts set of artwork images into different test cases (ex. scaling, resizing, rotating, etc.)
* Converts set of artwork images into average and perceptual hashes and stores them in Elasticsearch index as binary hashes
* Query Elasticsearch index using input image to find best artwork image match
* Update data aggregator to store hashes as binaries to allow for efficient querying

## Overview

### Matching

Contains scripts to download selected set of 30 test artwork images from the museum's collection and converts set of images into different test cases. 
Proportionally scaled, disproportionally scaled, resize, rotated, color filtered, crop, and altered image exif data images are created from each image in the test suite.

### In-gallery

Contains scripts to download selected set of 20 test artwork images and their matching in gallery images of the artwork.

### Testing

Contains scripts to test accuracy of matching algorithm to see if inputted altered image matches with its corresponding artwork. 

### Hashing

Contains scripts to convert selected set of 30 test artwork images into average and perceptual hashes.

### Searching

Contains script to store hashes of set of 30 test artwork images as image hash binaries in Elasticsearch index. Also contains script to search Elasticsearch 
index for matching artwork images of given input image based on percentage of matching binaries.

## Requirements

The project is includes the following requirements:
* Pillow 8.1.*
* ImageHash 4.0
* Elasticsearch 6.3.1


For development, we recommend that you use [Laravel Homestead](https://laravel.com/docs/5.8/homestead). It includes everything you need to run this project.
Note that you will need to [enable the optional Elasticsearch feature](https://laravel.com/docs/5.8/homestead#installing-optional-features) in your Homestead.yaml.

## Installing

In order to get project installation set up use the following tutorial to get set up with Homestead and Elasticsearch.
https://art-institute-of-chicago.atlassian.net/wiki/spaces/DD/pages/24477699/Setting+up+Homestead#Setting-up-Elasticsearch

Once you have set up Homestead and Elasticsearch run Homestead in vagrant to get local host output.

Make sure to forward port from your host to Homestead and to have the correct ports set up. Currently, the code uses port 2200 in search_hashes.py and store_hashes.py scripts. Make sure to alter these ports either in your Homestead.yaml file or the appropriate scripts to match.

```shell
ports:
    - send: 2200
      to: 2200
      protocol: tcp
```
## Developing

To start developing further, clone the repository and download the given requirements:

```shell
git clone https://github.com/art-institute-of-chicago/image-sandbox.git
pip -r requirements.lock
```

## Acknowledgements

The following sources have been referenced in the development of the store_hashes.py and search_hashes.py scripts.
https://github.com/JohannesBuchner/imagehash/issues/51
https://stackoverflow.com/questions/61791924/how-do-i-convert-an-array-of-numpy-booleans-to-python-booleans-for-serialization

## Licensing

This project is licensed under the [GNU Affero General Public License
Version 3](LICENSE).
