from fastai.vision.all import *
path = "data/export.pkl"
#dls = ImageDataLoaders.from_folder(path, train='TRAIN', valid='TEST', bs=128, num_workers=0, item_tfms=Resize(224))


learn = load_learner(path)

files = get_image_files("test/")

for pic in files:
    print(learn.predict(pic))