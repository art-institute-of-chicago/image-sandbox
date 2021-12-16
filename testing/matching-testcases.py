import unittest
import dummy_matching
import os
from unittest import TestCase
import random
import argparse
match = dummy_matching.dummy_matching
NUM_TESTS = 2


class QuickTestSuite(TestCase):
    def test_output(self):
        file = ("../matching/images/crop/center/"
                "0f1cc0e0-e42e-be16-3f71-2022da38cb93.jpg")
        result = match.match_image(file)
        self.assertTrue(len(result) > 0)

    def test_match(self):
        file = ("../matching/images/crop/center/"
                "0f1cc0e0-e42e-be16-3f71-2022da38cb93.jpg")
        result = match.match_image(file)
        self.assertEqual(result, file)

    def shared_quick_test(self, dir_path):
        directory = os.listdir(dir_path)
        for k in range(len(directory)):
            current_dir = directory[k]
            if current_dir != ".DS_Store":
                folder_path = dir_path + "/" + str(current_dir)
                images = [x for x in os.listdir(folder_path) if
                          x.endswith(".jpg")]
                for i in range(1, NUM_TESTS+1):
                    current_image = random.choice(images)
                    current_image = current_image.split(".", 1)[0]
                    image_path = folder_path + "/" + str(current_image)
                    result = match.match_image(image_path)
                    with self.subTest(i=("QuickTestSuite", NUM_TESTS*k+i)):
                        self.assertEqual(result, current_image)

    def test_rotate(self):
        rotate_path = "../matching/images/rotate"
        self.shared_quick_test(rotate_path)

    def test_crop(self):
        crop_path = "../matching/images/crop"
        self.shared_quick_test(crop_path)

    def test_color_shifted(self):
        color_shift_path = "../matching/images/color-shift"
        self.shared_quick_test(color_shift_path)

    def test_scale_proportional(self):
        scale_proportional_path = "../matching/images/scale-proportional"
        self.shared_quick_test(scale_proportional_path)

    def test_scale_disproportional(self):
        scale_disproportional_path = "../matching/images/scale-disproportional"
        self.shared_quick_test(scale_disproportional_path)

    def test_change_exif(self):
        change_exif_path = "../matching/images/change-exif"
        directory = os.listdir(change_exif_path)
        for i in range(1, NUM_TESTS+1):
            current_image = random.choice(directory)
            image_path = change_exif_path + "/" + str(current_image)
            result = match.match_image(image_path)
            with self.subTest(i=("QuickTestSuite", i)):
                self.assertEqual(result, current_image)


class FullTestSuite(TestCase):
    def shared_full_test(self, dir_path):
        directory = os.listdir(dir_path)
        test_index = 0
        for k in range(len(directory)):
            current_dir = directory[k]
            if current_dir != ".DS_Store":
                folder_path = dir_path + "/" + str(current_dir)
                images = [x for x in os.listdir(folder_path) if
                          x.endswith(".jpg")]
                for i in range(len(images)):
                    current_image = images[i]
                    current_image = current_image.split(".", 1)[0]
                    image_path = folder_path + "/" + str(current_image)
                    result = match.match_image(image_path)
                    with self.subTest(i=("FullTestSuite", test_index)):
                        self.assertEqual(result, current_image)
                    test_index += 1

    def test_rotate(self):
        rotate_path = "../matching/images/rotate"
        self.shared_full_test(rotate_path)

    def test_crop(self):
        crop_path = "../matching/images/crop"
        self.shared_full_test(crop_path)

    def test_color_shifted(self):
        color_shift_path = "../matching/images/color-shift"
        self.shared_full_test(color_shift_path)

    def test_scale_proportional(self):
        scale_proportional_path = "../matching/images/scale-proportional"
        self.shared_full_test(scale_proportional_path)

    def test_scale_disproportional(self):
        scale_disproportional_path = "../matching/images/scale-disproportional"
        self.shared_full_test(scale_disproportional_path)

    def test_change_exif(self):
        change_exif_path = "../matching/images/change-exif"
        directory = os.listdir(change_exif_path)
        for i in range(len(directory)):
            current_image = directory[i]
            image_path = change_exif_path + "/" + str(current_image)
            result = match.match_image(image_path)
            with self.subTest(i=("FullTestSuite", i)):
                self.assertEqual(result, current_image)


def run_testsuite():
    parser = argparse.ArgumentParser()
    parser.add_argument("--full", help="run full test suite",
                        action="store_true")
    args = parser.parse_args()
    if args.full:
        test_class = FullTestSuite
    else:
        test_class = QuickTestSuite
    loader = unittest.TestLoader()
    runner = unittest.TextTestRunner()
    current_suite = loader.loadTestsFromTestCase(test_class)
    test_suite = unittest.TestSuite(current_suite)
    results = runner.run(test_suite)
    return results


if __name__ == "__main__":
    run_testsuite()
