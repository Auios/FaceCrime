import os
import json
from PIL import Image
from autocrop import Cropper



# pedo = 100
# sex crime = 95
# violent = 90
# theft = 80
# drug = 70
# court/administrative 30

def inmate_categorize(charges):
    severity = 0
    worst = ""
    for charge in charges:

        sex = ["SEX", "MOLEST", "LEWD"]
        if any(x in charge for x in sex):
            pedo = ["CHILD", "YOA"]
            if any(x in charge for x in pedo):
                if(severity < 100):
                    worst = "PEDO"
                    severity = 100
            
            if(severity < 100):
                worst = "PREDATOR"
                severity = 95
    


        violence = ["ASSAULT", "BATTERY", "VIOLEN", "MURD", "MANSLAUGHT", "DEADLY WEAPON", "THREAT", "CARJACK", "HOMICIDE"]
        if any(x in charge for x in violence):
            if(severity < 90):
                worst = "VIOLENT"
                severity = 90


        thief = ["THEFT", "ROBBERY", "BURGLARY", "SHOPLIFT", "ROB"]
        if any(x in charge for x in thief):
            if(severity < 80):
                worst = "THIEF"
                severity = 80



        drugs = ["DRUG", "POSSESSION", "METH", "COCAINE", "TRAFFICKING", "DUI", "ALCOHOL", "HEROIN"]
        if any(x in charge for x in drugs):
            if(severity < 70):
                worst = "DRUG"
                severity = 70



        admin = ["COURT", "WARRANT", "APPEAR", "MISCHIEF", "VIOLATION", "TRESPASS", "LICENSE", "FRAUD", "PROSTITUT", "SOLICIT"]
        if any(x in charge for x in admin):
            if(severity < 30):
                worst = "ADMIN"
                severity = 30
    
    if(severity == 0):
        worst = "ADMIN"
    
    return worst


def crop_center(pil_img, crop_width, crop_height):
    img_width, img_height = pil_img.size
    return pil_img.crop(((img_width - crop_width) // 2,
                         (img_height - crop_height) // 2,
                         (img_width + crop_width) // 2,
                         (img_height + crop_height) // 2))


data = 'inmates/'
violentCount = 0
adminCount = 0
pedoCount = 0
predatorCount = 0
thiefCount = 0
drugCount = 0


cropper = Cropper(width=256,height=256)

for filename in os.listdir(data):
    f = os.path.join(data, filename)
    if os.path.isfile(f):
        jf = open(f)

        for jsonObj in jf: #some files have duplicate json objs, maybe result of scraper bug? causes json.load(file) to fail due to extra data
            jd = json.loads(jsonObj)
            break

        #for charge in jd["charges"]:
            #print(charge)
        
        crime = inmate_categorize(jd["charges"])

        if(crime == "PEDO"):
            pedoCount += 1
        if(crime == "PREDATOR"):
            predatorCount += 1
        if(crime == "VIOLENT"):
            violentCount += 1
        if(crime == "THIEF"):
            thiefCount += 1
        if(crime == "DRUG"):
            drugCount += 1
        if(crime == "ADMIN"):
            adminCount += 1
    
        cropped_array = cropper.crop("mugshots/" + jd["booking"] + ".png")

        if cropped_array is not None:
            if cropped_array.any():
                cropped_image = Image.fromarray(cropped_array)
            else:
                print("not found")

        cropped_image.save("processed/" + crime + "/" + jd["booking"] + ".jpeg", "JPEG")


        jf.close()


print("PEDO " + str(pedoCount))
print("VIOLENT " + str(violentCount))
print("PREDATOR " + str(predatorCount))
print("THIEF " + str(thiefCount))
print("DRUG " + str(drugCount))
print("ADMIN " + str(adminCount))

print("TOTAL " + str(pedoCount + predatorCount + violentCount + thiefCount + drugCount + adminCount))