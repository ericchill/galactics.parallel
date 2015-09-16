#Makefile for particle generators of the combined df - June 8/94 - JJD
#
.f.o:
	$(F77) $(FFLAGS) -c $*.f

#GNU compiler flags
F77=gfortran
CC=gcc
CFLAGS = -fPIC -O3 -g -DASCII #- this flag will dump ASCII N-body output
FFLAGS = -fPIC -O3 -g -ffixed-line-length-0  -fno-backslash
LIBS = -lm

#Intel compiler flags
#F77=ifort
#CC=icc
#CFLAGS = -O # -DASCII - this flag will dump ASCII N-body output
#FFLAGS = -O -132
#LDFLAGS = -nofor_main
#LIBS = -lm

ALLFILES= genhalo genbulge gendisk diskdf getfreqs dbh vcirc orbit toascii makegalaxy 

all: $(ALLFILES)

makegalaxy: gendisk genbulge genhalo makegalaxy.o
	/bin/rm -f libgengalaxy.a
	ar qv libgengalaxy.a appdiskdens.o     dbhplot.o       diskdens.o      diskdf5ez.o     genbulge.o         genhalo.o        modstamp.o        polarhalodens.o     readdenspsihalo.o  simpson.o  velocityfactors.o \
		appdiskforce.o    dens.o          diskdensf.o     diskdf5intez.o  genbulge_main.o    getfreqs.o       omekap.o          pot.o               readdiskdf.o       splined.o \
		appdiskpot.o      dfbulge.o       diskdenspsi.o   erfcen.o        gendenspsibulge.o  golden.o         orbit.o           query.o             readharmfile.o     splintd.o \
		bulgedenspsi.o    dfcorrection.o  diskdf.o        etoeprime.o     gendenspsihalo.o   halodens.o       plgndr1.o         ran1.o              readmassrad.o      toascii.o \
		bulgepotential.o  dfhalo.o        diskdf3ez.o     fnamidden.o     gendisk.o          halodenspsi.o    polarbulgedens.o  rcirc.o             sigr2.o            totdens.o \
		dbh.o             dfmaximum.o     diskdf3intez.o  force.o         gendisk_main.o     halopotential.o  polardens.o       readdenspsibulge.o  sigz2.o            vcirc.o
	ranlib libgengalaxy.a
	g++ -o makegalaxy makegalaxy.cpp  -lrt -L./ -lgengalaxy -lgfortran

dbh: dbh.o dbhplot.o polardens.o bulgepotential.o totdens.o halopotential.o pot.o diskdens.o dens.o appdiskpot.o plgndr1.o bulgedenspsi.o halodenspsi.o gendenspsihalo.o gendenspsibulge.o polarbulgedens.o polarhalodens.o appdiskdens.o halodens.o dfhalo.o dfbulge.o etoeprime.o erfcen.o modstamp.o force.o appdiskforce.o
	$(F77) $(LDFLAGS) $(FLIBS) dbh.o dbhplot.o polardens.o bulgepotential.o totdens.o halopotential.o pot.o diskdens.o dens.o appdiskpot.o plgndr1.o bulgedenspsi.o halodenspsi.o gendenspsihalo.o gendenspsibulge.o polarbulgedens.o polarhalodens.o appdiskdens.o halodens.o dfhalo.o dfbulge.o etoeprime.o erfcen.o modstamp.o force.o appdiskforce.o -o dbh

genhalo: genhalo_main.o genhalo.o readmassrad.o dfcorrection.o dfmaximum.o query.o ran1.o readharmfile.o pot.o halodens.o dfhalo.o dfbulge.o etoeprime.o appdiskpot.o plgndr1.o halodenspsi.o readdenspsihalo.o erfcen.o
	$(F77) $(LDFLAGS) genhalo_main.o genhalo.o readmassrad.o dfcorrection.o dfmaximum.o query.o ran1.o readharmfile.o appdiskpot.o plgndr1.o halodenspsi.o readdenspsihalo.o pot.o halodens.o dfhalo.o dfbulge.o etoeprime.o erfcen.o -o genhalo

genbulge: genbulge.o genbulge_main.o readmassrad.o dfcorrection.o dfmaximum.o query.o ran1.o readharmfile.o pot.o dfhalo.o dfbulge.o etoeprime.o appdiskpot.o plgndr1.o readdenspsibulge.o bulgedenspsi.o bulgepotential.o polarbulgedens.o erfcen.o
	$(F77) $(LDFLAGS) genbulge.o genbulge_main.o readmassrad.o dfcorrection.o dfmaximum.o query.o ran1.o readharmfile.o pot.o dfhalo.o dfbulge.o etoeprime.o appdiskpot.o plgndr1.o readdenspsibulge.o bulgedenspsi.o bulgepotential.o polarbulgedens.o erfcen.o -o genbulge

gendisk: gendisk_main.o gendisk.o ran1.o query.o \
	appdiskforce.o force.o velocityfactors.o readdiskdf.o golden.o simpson.o diskdf5ez.o diskdensf.o readharmfile.o sigr2.o sigz2.o omekap.o diskdens.o splined.o splintd.o diskdf3ez.o diskdenspsi.o pot.o fnamidden.o appdiskpot.o plgndr1.o rcirc.o
	$(F77) $(LDFLAGS) gendisk.o gendisk_main.o ran1.o query.o appdiskforce.o force.o velocityfactors.o diskdf5ez.o diskdensf.o readharmfile.o sigr2.o sigz2.o omekap.o diskdens.o splined.o splintd.o diskdf3ez.o diskdenspsi.o pot.o fnamidden.o appdiskpot.o plgndr1.o rcirc.o \
	readdiskdf.o golden.o simpson.o -o gendisk

diskdf: diskdf.o diskdf5intez.o diskdensf.o splintd.o splined.o readharmfile.o sigr2.o sigz2.o omekap.o pot.o diskdf3intez.o appdiskpot.o plgndr1.o fnamidden.o rcirc.o diskdens.o modstamp.o
	$(F77) $(LDFLAGS)  $(FLIBS) diskdf.o diskdf5intez.o diskdf3intez.o appdiskpot.o plgndr1.o diskdensf.o splintd.o splined.o readharmfile.o sigr2.o sigz2.o fnamidden.o rcirc.o diskdens.o omekap.o pot.o modstamp.o  -o diskdf

getfreqs: getfreqs.o pot.o appdiskpot.o plgndr1.o erfcen.o
	$(F77) $(LDFLAGS)  $(FLIBS) getfreqs.o pot.o appdiskpot.o plgndr1.o erfcen.o -o getfreqs

toascii: toascii.o
	$(CC) $(LDFLAGS) toascii.o -o toascii -lm

vcirc: vcirc.o query.o readharmfile.o force.o appdiskforce.o appdiskpot.o plgndr1.o
	$(F77) $(LDFLAGS) vcirc.o query.o  readharmfile.o force.o appdiskforce.o appdiskpot.o plgndr1.o -o vcirc

orbit: orbit.o query.o readharmfile.o force.o appdiskforce.o appdiskpot.o plgndr1.o
	$(F77) $(LDFLAGS) orbit.o query.o  readharmfile.o force.o appdiskforce.o appdiskpot.o plgndr1.o -o orbit

clean:
	rm -f *.o $(ALLFILES)
	(cd ../bin; rm -f *.o $(ALLFILES))

install:
	cp -f $(ALLFILES) ../bin

