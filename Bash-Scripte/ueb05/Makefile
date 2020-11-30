# author: Tobias Schrittenlacher, Timo Templin
#Makefile to convert tga and jpg files to png and zipping them in a tar archive
TGA		= $(wildcard *.tga)
JPEG 	= $(wildcard *.jpg)
PPMS    = $(wildcard *.ppm)

TGA2PPM		= $(TGA:.tga=.ppm)
JPEG2PPM 	= $(JPEG:.jpg=.ppm)

PPMTO_SCALED  = $(JPEG2PPM:.ppm=.scaled)
PPMTO_SCALED += $(TGA2PPM:.ppm=.scaled)
PPMTO_SCALED += $(PPMS:.ppm=.scaled) 

SCALEDTO_PNG = $(PPMTO_SCALED:.scaled=.png)

TARAR = png-files.tar.gz
#default size
SIZE = 100

#declare common phony targets
.PHONY: all clean tar png help
#file endings that are being used and/or changed during make
.SUFFIXES: .tga .jpg .ppm .scaled .png 

.SECONDARY:
# I KILL YOU
.SILENT: jpegtopnm
# default == all == tar 
default: all

all: tar
#use netnpnm function to change scaled to png
%.png : %.scaled 
	@pnmtopng $< > $@

#use netnpm function to change ppm scale to fit into 'SIZE'; ratio is kept
%.scaled : %.ppm
	@pnmscale -xysize $(SIZE) $(SIZE) $< > $@
#use netnpnm function to change tga and jpeg to ppm 
%.ppm : %.tga
	@tgatoppm $< > $@
%.ppm : %.jpg
	@jpegtopnm $< > $@


tar: png $(TARAR)
#zips selfmade PNGs into tarchive(TARAR)  
$(TARAR): $(SCALEDTO_PNG)
	@echo "Zipper"
	@tar zcvf $(TARAR) $^
	@echo "Zipper Done"


# dependency from TGA2PPM -> JPEG2PPM -> PPMTO_SCALED -> SCALEDTO_PNG
png: $(TGA2PPM) $(JPEG2PPM) $(PPMTO_SCALED) $(SCALEDTO_PNG)

#delete all created files
clean:
	@echo "Loeschen" 
	@rm -f $(TGA2PPM) $(JPEG2PPM) $(PPMTO_SCALED) $(SCALEDTO_PNG) $(TARAR)
	@echo "Loeschen Fertig"
#print the usage of this makefile
help:
	@echo "Makefile to scale and convert jpg, tga and ppm files to png."
	@echo ""
	@echo "VARIABLES"
	@echo "  SIZE  - specifies the largest image size (default=100)"
	@echo ""
	@echo "TARGETS"
	@echo "  all   - default target, does the same as tar target"
	@echo "  tar   - create tar archive"
	@echo "  png   - scale and convert all jpg and tga files to png"
	@echo "  help  - display this help and exit"
	@echo "  clean - remove all generated files"