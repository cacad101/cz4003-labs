""" Utils for SPM """

import cv2
import matplotlib.pyplot as plt

def image_to_gray(color_img):
    """ Convert image to gray """
    gray = cv2.cvtColor(color_img, cv2.COLOR_BGR2GRAY)
    return gray

def get_sift_features(gray_img):
    """ Generate sift features """
    sift = cv2.xfeatures2d.SIFT_create()
    kp, description = sift.detectAndCompute(gray_img, None)
    return kp, description
