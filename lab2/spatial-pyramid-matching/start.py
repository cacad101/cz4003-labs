"""
Start script
"""
import os
import cv2
from sklearn.metrics import accuracy_score
from sklearn.svm import LinearSVC
from sklearn.cluster import KMeans
import numpy as np

import utils
import spm

def main():
    """ load data, extract feature (spatial pyramid), train model, test """
    rootdir = os.getcwd() + '/101_ObjectCategories'
    categories = os.listdir(rootdir)

    descriptions = {}
    descriptions_test = {}

    coordinates = {}
    coordinates_test = {}

    sizes = {}
    sizes_test = {}
    
    for cat in categories:
        files = os.listdir(rootdir + '/' + str(cat))
        descriptions[cat] = []
        coordinates[cat] = []
        sizes[cat] = []

        descriptions_test[cat] = []
        coordinates_test[cat] = []
        sizes_test[cat] = []

        for i in range(len(files)):
            each = files[i]
            if i <= 29:
                img = cv2.imread(rootdir + '/' + str(cat) + '/' + str(each))
                img_gray = utils.image_to_gray(img)
                kp, descriptions = utils.get_sift_features(img_gray)
                kp = [it.pt for it in kp]
                descriptions[cat].append(descriptions)
                coordinates[cat].append(kp)
                sizes[cat].append((img_gray.shape[1], img_gray.shape[0]))
            elif 30 <= i <= 30+50-1:
                img = cv2.imread(rootdir + '/' + str(cat) + '/' + str(each))
                img_gray = to_gray(img)
                kp, descriptions = utils.get_sift_features(img_gray)
                kp = [it.pt for it in kp]
                descriptions_test[cat].append(descriptions)
                coordinates_test[cat].append(kp)
                sizes_test[cat].append((img_gray.shape[1], img_gray.shape[0]))

    features = []
    for k in descriptions:
        for it in descriptions[k]:
            if it is None:
                continue
            for i in range(len(it)):
                features.append(it[i])
    features = np.array(features)

    M = 200
    clusters = KMeans(n_clusters=M, n_jobs=-1)
    clusters.fit(features)

    for L in range(4):
        X_train, Y_train = spm.get_spatial_pyramid(descriptions, coordinates, sizes, clusters, L, M)
        X_test, Y_test = spm.get_spatial_pyramid(descriptions, coordinates, sizes, clusters, L, M)
        model = LinearSVC()
        model.fit(X_train, Y_train)

        print("Level " + str(L) + ": " + str(accuracy_score(Y_test, model.predict(X_test))))

if __name__ == "__main__":
    main()
