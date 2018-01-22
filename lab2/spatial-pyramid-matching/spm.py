"""
Function to get spatial pyramid features of an images
"""

def get_grid(level, x, y, cols, rows):
    """
    Get the specified grid from the images
    """
    denom = 1<<level
    nx, ny = 0, 0
    for numer in range(denom):
        if (numer/denom)*cols <= x <= ((numer+1)/denom)*cols:
            nx = numer
        if (numer/denom)*rows <= y <= ((numer+1)/denom)*rows:
            ny = numer

    return ny * denom + nx


def get_spatial_pyramid(descriptions, coordinates, dimensions, clusters, L=3, M=200):
    """
    Transforms the images into spatial pyramid
    """
    X = []
    Y = []

    for k in descriptions:
        for idx in range(len(descriptions[k])):

            if descriptions[k][idx] is None:
                X.append([0 for i in range((M * (-1 + 4**(L+1)))//3)])
                Y.append(k)
                continue

            cols = dimensions[k][idx][0]
            rows = dimensions[k][idx][1]

            v = []

            channels = {}
            channels_coordinates = {}

            preds = clusters.predict(descriptions[k][idx])

            for i in range(len(preds)):
                if preds[i] not in channels:
                    channels[preds[i]] = []
                    channels_coordinates[preds[i]] = []
                channels[preds[i]].append(descriptions[k][idx][i].tolist())
                channels_coordinates[preds[i]].append(coordinates[k][idx][i])

            for c in range(M):
                if c not in channels:
                    v += [0 for i in range(((-1 + 4**(L+1)))//3)]
                    continue

                for l in range(L+1):
                    w = 0

                    if l == 0: w = 1/(1<<L)
                    else: w = 1/(1<<(L-l+1))

                    hist = [0 for i in range(4**l)]

                    for i in range(len(channels_coordinates[c])):
                        x = channels_coordinates[c][i][0]
                        y = channels_coordinates[c][i][1]

                        grid = get_grid(l, x, y, cols, rows)

                        hist[grid] += 1

                    hist = [it * w for it in hist]

                    v += hist

            X.append([it/(((M/200) * 25) * (1<<L)) for it in v])
            Y.append(k)
    return X, Y
