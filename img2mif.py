import Image
import os.path
from math import log, ceil


while True:
    bi = raw_input("Bits per channel: ")
    while True:
        try:
            bit = int(bi)
        except ValueError:
            if bi == "": raise SystemExit
            print "\tInput not an integer"
            bi = raw_input("Bits per channel: ")
            continue
        if bit < 1 or bit > 8:
            print "\tInput not in range 1-8"
            bi = raw_input("Bits per channel: ")
        else:
            break

    col = raw_input("'Mono' or 'Colour': ").lower()
    while col not in ["mono", "colour"]:
        if col == "": raise SystemExit
        print "\tInvalid choice"
        col = raw_input("'Mono' or 'Colour': ").lower()
    
    fimg = raw_input("File Name: ")
    
    while fimg:
        try:
            img = Image.open(fimg)
        except IOError:
            print ("\tCannot open " + fimg) if os.path.isfile(fimg) else ("\tNo such file")
            fimg = raw_input("File Name: ")
            continue
            
        (wid, hei) = img.size
        pix = img.convert(("L" if col=="mono" else "RGB"), colors=2**bit).getdata()

        print "\tConverting " + fimg + " to " + os.path.splitext(fimg)[0] + ".mif"
        print "\t" + str(wid) + "px",
        try:
            print u'\u00D7', 
        except UnicodeEncodeError:
            print "*",
        print str(hei) + "px; \t" + str(bit) + " bit " + col
        out = "Depth = " + str(wid*hei) + ";\n" \
            "Width = " + str((1 if col=="mono" else 3) * 2**(bit-1)) + ";\n" \
            "Address_radix=hex;\n" \
            "Data_radix=bin;\n" \
            "Content\n" \
            "BEGIN"

        for j in xrange(hei):
            out += "\n\t" + ("{0:"+str(int(ceil(log(wid*hei,16))))+"X}").format(j*wid) + ":\t"
            for i in xrange(wid):
                if col=="mono":
                    out += ("{0:0"+str(bit)+"b}").format(pix[wid*j+i] >> (8 - bit))
                else:
                    for n in pix[wid*j+i]:
                        out += ("{0:0"+str(bit)+"b}").format(n >> (8 - bit))
                out += " "
            out = out[:-1] + ";"

        out += "\nEND;"

        fmif = open(os.path.splitext(fimg)[0] + ".mif", 'w')
        fmif.write(out)
        fmif.close()

        print "\tConversion complete"

        fimg = raw_input("File Name: ")
    print ""

raise SystemExit
