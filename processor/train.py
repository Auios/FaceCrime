from fastai.vision.all import *
path = "data/"
dls = ImageDataLoaders.from_folder(path, train='TRAIN', valid='TEST', bs=128, num_workers=0, item_tfms=Resize(224))


learn = cnn_learner(dls, resnet34, metrics=error_rate)
learn.fine_tune(100)
learn.export()