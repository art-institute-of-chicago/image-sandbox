import unittest
import dummy_matching
import os
from unittest import TestCase
import random
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

    def test_rotate(self):
        rotate_path = "../matching/images/rotate"
        directory = os.listdir(rotate_path)
        for k in range(len(directory)):
            current_dir = directory[k]
            if current_dir != ".DS_Store":
                folder_path = rotate_path + "/" + str(current_dir)
                images = os.listdir(folder_path)
                for i in range(1, NUM_TESTS+1):
                    current_image = random.choice(images)
                    image_path = folder_path + "/" + str(current_image)
                    result = match.match_image(image_path)
                    with self.subTest(i=("QuickTestSuite", NUM_TESTS*k+i)):
                        self.assertEqual(result, current_image)

    def test_crop(self):
        crop_path = "../matching/images/crop"
        directory = os.listdir(crop_path)
        for k in range(len(directory)):
            current_dir = directory[k]
            if current_dir != ".DS_Store":
                folder_path = crop_path + "/" + str(current_dir)
                images = os.listdir(folder_path)
                for i in range(1, NUM_TESTS+1):
                    current_image = random.choice(images)
                    image_path = folder_path + "/" + str(current_image)
                    result = match.match_image(image_path)
                    with self.subTest(i=("QuickTestSuite", NUM_TESTS*k+i)):
                        self.assertEqual(result, current_image)

    def test_color_shifted(self):
        color_shift_path = "../matching/images/color-shift"
        directory = os.listdir(color_shift_path)
        for k in range(len(directory)):
            current_dir = directory[k]
            if current_dir != ".DS_Store":
                folder_path = color_shift_path + "/" + str(current_dir)
                images = os.listdir(folder_path)
                for i in range(1, NUM_TESTS+1):
                    current_image = random.choice(images)
                    image_path = folder_path + "/" + str(current_image)
                    result = match.match_image(image_path)
                    with self.subTest(i=("QuickTestSuite", NUM_TESTS*k+i)):
                        self.assertEqual(result, current_image)

    def test_scale_proportional(self):
        scale_proportional_path = "../matching/images/scale-proportional"
        directory = os.listdir(scale_proportional_path)
        for k in range(len(directory)):
            current_dir = directory[k]
            if current_dir != ".DS_Store":
                folder_path = scale_proportional_path + "/" + str(current_dir)
                images = os.listdir(folder_path)
                for i in range(1, NUM_TESTS+1):
                    current_image = random.choice(images)
                    image_path = folder_path + "/" + str(current_image)
                    result = match.match_image(image_path)
                    with self.subTest(i=("QuickTestSuite", NUM_TESTS*k+i)):
                        self.assertEqual(result, current_image)

    def test_scale_disproportional(self):
        scale_disproportional_path = "../matching/images/scale-disproportional"
        directory = os.listdir(scale_disproportional_path)
        for k in range(len(directory)):
            current_dir = directory[k]
            if current_dir != ".DS_Store":
                folder_path = (
                    scale_disproportional_path + "/" + str(current_dir))
                images = os.listdir(folder_path)
                for i in range(1, NUM_TESTS+1):
                    current_image = random.choice(images)
                    image_path = folder_path + "/" + str(current_image)
                    result = match.match_image(image_path)
                    with self.subTest(i=("QuickTestSuite", NUM_TESTS*k+i)):
                        self.assertEqual(result, current_image)

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
    def test_rotate(self):
        rotate_path = "../matching/images/rotate"
        directory = os.listdir(rotate_path)
        test_index = 0
        for k in range(len(directory)):
            current_dir = directory[k]
            if current_dir != ".DS_Store":
                folder_path = rotate_path + "/" + str(current_dir)
                images = os.listdir(folder_path)
                for i in range(len(images)):
                    current_image = images[i]
                    image_path = folder_path + "/" + str(current_image)
                    result = match.match_image(image_path)
                    with self.subTest(i=("FullTestSuite", test_index)):
                        self.assertEqual(result, current_image)
                    test_index += 1

    def test_crop(self):
        crop_path = "../matching/images/crop"
        directory = os.listdir(crop_path)
        test_index = 0
        for k in range(len(directory)):
            current_dir = directory[k]
            if current_dir != ".DS_Store":
                folder_path = crop_path + "/" + str(current_dir)
                images = os.listdir(folder_path)
                for i in range(len(images)):
                    current_image = images[i]
                    image_path = folder_path + "/" + str(current_image)
                    result = match.match_image(image_path)
                    with self.subTest(i=("FullTestSuite", test_index)):
                        self.assertEqual(result, current_image)
                    test_index += 1

    def test_color_shifted(self):
        color_shift_path = "../matching/images/color-shift"
        directory = os.listdir(color_shift_path)
        test_index = 0
        for k in range(len(directory)):
            current_dir = directory[k]
            if current_dir != ".DS_Store":
                folder_path = color_shift_path + "/" + str(current_dir)
                images = os.listdir(folder_path)
                for i in range(len(images)):
                    current_image = images[i]
                    image_path = folder_path + "/" + str(current_image)
                    result = match.match_image(image_path)
                    with self.subTest(i=("FullTestSuite", test_index)):
                        self.assertEqual(result, current_image)
                    test_index += 1

    def test_scale_proportional(self):
        scale_proportional_path = "../matching/images/scale-proportional"
        directory = os.listdir(scale_proportional_path)
        test_index = 0
        for k in range(len(directory)):
            current_dir = directory[k]
            if current_dir != ".DS_Store":
                folder_path = scale_proportional_path + "/" + str(current_dir)
                images = os.listdir(folder_path)
                for i in range(len(images)):
                    current_image = images[i]
                    image_path = folder_path + "/" + str(current_image)
                    result = match.match_image(image_path)
                    with self.subTest(i=("FullTestSuite", test_index)):
                        self.assertEqual(result, current_image)
                    test_index += 1

    def test_scale_disproportional(self):
        scale_disproportional_path = "../matching/images/scale-disproportional"
        directory = os.listdir(scale_disproportional_path)
        test_index = 0
        for k in range(len(directory)):
            current_dir = directory[k]
            if current_dir != ".DS_Store":
                folder_path = (
                    scale_disproportional_path + "/" + str(current_dir))
                images = os.listdir(folder_path)
                for i in range(len(images)):
                    current_image = images[i]
                    image_path = folder_path + "/" + str(current_image)
                    result = match.match_image(image_path)
                    with self.subTest(i=("FullTestSuite", test_index)):
                        self.assertEqual(result, current_image)
                    test_index += 1

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
    test_classes = [QuickTestSuite, FullTestSuite]
    loader = unittest.TestLoader()
    runner = unittest.TextTestRunner()
    list_suites = []
    for test in test_classes:
        current_suite = loader.loadTestsFromTestCase(test)
        list_suites.append(current_suite)

    test_suite = unittest.TestSuite(list_suites)
    results = runner.run(test_suite)
    return results


if __name__ == "__main__":
    run_testsuite()
