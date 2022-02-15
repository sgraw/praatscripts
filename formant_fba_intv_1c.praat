#this script measures formant values etc. in a given interval of an intervaltier
#the interval does also contain the vowel label
#another tier contains the lemma
#Textgrid and LongSound should have the same name

nocheck select all
nocheck Remove




############ SETTINGS ##########################################

# which tier are the vowel intervals in?
itier=3
# what is the lemma tier? 
ltier=1
# where is the context coded?
ptier= 5
# where is the vowel length labled?
dtier= 4
# what is the number of repetition tier?
rtier= 6 
# where are the textgrids?
#inputdir$="/Volumes/lingboard/Department Members/Natalia Aralova/Even/Sebjan/TextGrid_Sound_TPK/"
inputdir$="C:\NatAr\Phon\Kamchatka\TextGrid_Sound_VAC\TextGrids_Vowels_2010\"


# where are the sounds?
#lsinputdir$="/Volumes/lingboard/Department Members/Natalia Aralova/Even/Sebjan/TextGrid_Sound_TPK/"
lsinputdir$="C:\NatAr\Phon\Kamchatka\TextGrid_Sound_VAC\TextGrids_Vowels_2010\"

# where shall the textfile be written in?  
outputdir$="C:\NatAr\Phon\Kamchatka\TextGrid_Sound_VAC\TextGrids_Vowels_2010\"


# what's the name of the textfile?
filename$="formantEven_VAC.txt"


#what's the name of the error report file?
filename_err$="formantEven_VAC_errreport.txt"

### speaker gender/sex 2=fem; 1=mal
sex=1
#### Tracking of Back Vowels?
tracking= 0
# do you want to visually check the measurement?
check=1
# do want to seen the bandwidths drawn into the LPC?
draw_bandwidths=1


############################################################
############################################################

Create Strings as file list... fileList 'inputdir$'*.TextGrid
Sort
nstr=Get number of strings

for n from 1 to nstr
select Strings fileList

strnr$=Get string... n
strnr$=strnr$-".TextGrid"


Open long sound file... 'lsinputdir$''strnr$'.wav
Read from file... 'inputdir$''strnr$'.TextGrid
endfor

############


select all
numoftgs=numberOfSelected("TextGrid")
clearinfo
fileappend 'outputdir$''filename$' index'tab$'stp'tab$'edp'tab$'vowel'tab$'label'tab$'lemma'tab$'pos'tab$'num'tab$'f0'tab$'f0mn
...'tab$'f0sd'tab$'f1'tab$'f2'tab$'f3'tab$'f1B'tab$'f2B'tab$'f3B'tab$'duration'tab$'
...B1md'tab$'B2md'tab$'B3md'tab$'A1'tab$'A2'tab$'A3'tab$'file'newline$'

w=0

for t to numoftgs
select all
name$=selected$("TextGrid", 't')

select TextGrid 'name$'

nri=Get number of intervals... itier
#nrp=Get number of points... itier

for i to nri 

select TextGrid 'name$'
vowlab$=Get label of interval... itier i

if vowlab$!=""
w=w+1

vowlq$=left$(vowlab$,1)

stp =Get starting point... itier i
edp=Get end point... itier i

len=edp-stp



lemi=Get interval at time... ltier stp
lemma$=Get label of interval... ltier lemi

posi=Get interval at time... ptier stp
pos$=Get label of interval... ptier posi

numi=Get interval at time... rtier stp
num$=Get label of interval... rtier numi

duri=Get interval at time... dtier stp
di$=Get label of interval... dtier duri

printline 'vowlab$''tab$''lemi''tab$''lemma$''tab$''posi''tab$''pos$''tab$''numi''tab$''num$''tab$''duri''tab$''di$'

if di$==vowlab$
stpd=Get starting point... dtier duri
edpd=Get end point... dtier duri
dur=edpd-stpd
else
dur=0
endif

stpl=Get start point... ltier lemi
#stpl=pt-0.05
edpl=Get end point... ltier lemi
#edpl=pt+0.05
select LongSound 'name$'
Extract part... stpl edpl yes
Rename... 'name$'_w_'i'

Filter (pass Hann band)... 50 16000 10
#Rename... 'name$'_band_w_'i'
To Pitch (ac)...  0 80 15 yes  0.03 0.40 0.01 0.35 0.14 600
#select Pitch 'name$'
f0md=Get quantile... stp edp 0.5 Hertz
f0mn=Get mean... stp edp Hertz
f0sd=Get standard deviation... stp edp Hertz


select Sound 'name$'_w_'i'_band
#pause ok?

if sex=1 
if (vowlq$!="u" or vowlq$!="U")
#if (vowlq$!="u")
To Formant (burg)... 0 5 4000 0.015 50
else
To Formant (burg)... 0 5 5000 0.015 50
endif
else
if (vowlq$!="u" or vowlq$!="U")
#if (vowlq$!="u")
To Formant (burg)... 0 5 4500 0.015 50
else
To Formant (burg)... 0 5 5500 0.015 50
endif
endif

Rename...  'name$'_w_'i'_band

if tracking = 1
if (vowlq$!="u" or vowlq$!="U")
Track... 3 550 1650 2750 3850 4950 1 1 1
Rename...  'name$'_v_'i'_band_tr
else
Track... 3 550 1650 2750 3850 4950 1 1 1
Rename...  'name$'_v_'i'_band_tr
endif
else
endif

#pause ok?

f1md=Get quantile... 1 stp edp Hertz 0.5
f1Bmd=Get quantile... 1 stp edp Bark 0.5
b1md=Get quantile of bandwidth... 1 stp edp Hertz 0.5
b1Bmd=Get quantile of bandwidth... 1 stp edp Bark 0.5
f1mn=Get mean... 1 stp edp Hertz
f1sd=Get standard deviation... 1 stp edp Hertz

f2md=Get quantile... 2 stp edp Hertz 0.5
f2Bmd=Get quantile... 2 stp edp Bark 0.5
b2md=Get quantile of bandwidth... 2 stp edp Hertz 0.5
b2Bmd=Get quantile of bandwidth... 2 stp edp Bark 0.5
f2mn=Get mean... 2 stp edp Hertz
f2sd=Get standard deviation... 2 stp edp Hertz

f3md=Get quantile... 3 stp edp Hertz 0.5
f3Bmd=Get quantile... 3 stp edp Bark 0.5
b3md=Get quantile of bandwidth... 3 stp edp Hertz 0.5
b3Bmd=Get quantile of bandwidth... 3 stp edp Bark 0.5
f3mn=Get mean... 3 stp edp Hertz
f3sd=Get standard deviation... 3 stp edp Hertz

f4md=Get quantile... 4 stp edp Hertz 0.5
f4Bmd=Get quantile... 4 stp edp Bark 0.5
b4md=Get quantile of bandwidth... 4 stp edp Hertz 0.5
b4Bmd=Get quantile of bandwidth... 4 stp edp Bark 0.5
f4mn=Get mean... 4 stp edp Hertz
f4sd=Get standard deviation... 4 stp edp Hertz


###
select LongSound 'name$'
if len > 0.030
Extract part... stp edp yes
elif len < 0.030 and len > 0.02
Extract part... stp-0.005 edp+0.005 yes
else
endif
if len > 0.02
Rename... 'name$'_v_'i'
#select Sound 'name$'_band
Filter (pass Hann band)... 50 16000 10
#select Sound 'name$'_v_'i'_band
Resample... 16000 50
To LPC (burg)...     16 0.015 0.005 50
To Spectrum (slice)... 0 20 0 50
To Ltas (1-to-1)
a1db=Get maximum... f1md-10 f1md+10 None
a2db=Get maximum... f2md-10 f2md+10 None
a3db=Get maximum... f3md-10 f3md+10 None
a4db=Get maximum... f4md-10 f4md+10 None

else
a1db=undefined
a2db=undefined
a3db=undefined
a4db=undefined
endif

if check=1
call checkit
else

fileappend 'outputdir$''filename$' 'w''tab$''stp:4''tab$''edp:4''tab$''vowlq$''tab$''vowlab$''tab$''lemma$''tab$''pos$''tab$''num$''tab$''f0md:1''tab$''f0mn:1''tab$'
...'f0sd:2''tab$''f1md:0''tab$''f2md:0''tab$''f3md:0''tab$''f1Bmd:3''tab$''f2Bmd:3''tab$''f3Bmd:3''tab$''dur:4''tab$'
...'b1md:0''tab$''b2md:0''tab$''b3md:0''tab$''a1db:1''tab$''a2db:1''tab$''a3db:1''tab$''name$''newline$'
endif

printline 'w''tab$''name$'

select Sound 'name$'_w_'i'
plus Sound 'name$'_w_'i'_band
plus Pitch 'name$'_w_'i'_band
plus Formant 'name$'_w_'i'_band
if tracking=1
plus Formant 'name$'_w_'i'_band_tr
endif
plus Sound 'name$'_v_'i'
plus Sound 'name$'_v_'i'_band
plus Sound 'name$'_v_'i'_band_16000
plus LPC 'name$'_v_'i'_band_16000
plus Spectrum 'name$'_v_'i'_band_16000
plus Ltas 'name$'_v_'i'_band_16000
if check=1
plus Spectrogram 'name$'_v_'i'_band
plus Spectrum 'name$'_v_'i'_band
endif
Remove

endif
endfor
endfor

################################


procedure checkit

Erase all
   Font size... 11
select Sound 'name$'_v_'i'_band
To Spectrogram... 0.005 5000 0.002 20 Hamming (raised sine-squared)
Viewport... 0 5 0 3
Paint... 0 0 0 0 100 yes 50 6 0 yes
Text top... no 'vowlq$' - 'pos$' - 'lemma$'- 'num$'
Marks left... 6 yes yes no

if tracking =1
select Formant 'name$'_w_'i'_band_tr
else
select Formant 'name$'_w_'i'_band
endif
White
Speckle... stp edp 5000 30 no
Black


select Ltas 'name$'_v_'i'_band_16000
ltasmin=Get minimum... 0 0 None
ltasmax=Get maximum...  0 0 None


Select outer viewport... 0 6.5 3 7
select Spectrum 'name$'_v_'i'_band_16000
####
if draw_bandwidths==1
Draw... 0 5000 0 0 no
bh1=b1md/2
bh2=b2md/2
bh3=b3md/2
#Paint rectangle... 0.2 'f1md:0'-'bh1:0' 'f1md:0'+'bh1:0' 'ltasmin:0' 'ltasmax:0'
#Paint rectangle... 0.5 'f2md:0'-'bh2:0' 'f2md:0'+'bh2:0' 'ltasmin:0' 'ltasmax:0'
#Paint rectangle... 0.7 'f3md:0'-'bh3:0' 'f3md:0'+'bh3:0' 'ltasmin:0' 'ltasmax:0'
Paint rectangle... Blue 'f1md:0'-'bh1:0' 'f1md:0'+'bh1:0' 'ltasmin:0' 'ltasmax:0'
Paint rectangle... Red 'f2md:0'-'bh2:0' 'f2md:0'+'bh2:0' 'ltasmin:0' 'ltasmax:0'-10
Paint rectangle... Green 'f3md:0'-'bh3:0' 'f3md:0'+'bh3:0' 'ltasmin:0' 'ltasmax:0'-20
endif
Draw... 0 5000 0 0 yes
One mark top... 'f1md:0' no yes yes  F1
One mark top... 'f2md:0' no yes yes  F2
One mark top... 'f3md:0' no yes yes  F3
One mark top... 'f4md:0' no yes yes  F4
#Marks bottom... 6 yes yes no
Marks bottom every... 1 500 yes yes no
if not (a1db=undefined or a2db=undefined or a3db=undefined)
One mark right... 'a1db:1' no yes yes A1
One mark right... 'a2db:1' no yes yes A2
One mark right... 'a3db:1' no yes yes A3
One mark right... 'a4db:1' no yes yes A4

#pause ok

#Text special... 5500 left 40 half Times 10 0 B1=100
Text... 6000 Left 40 Half B1='b1md:0' Hz
Text... 6000 Left 30 Half B2='b2md:0' Hz
Text... 6000 Left 20 Half B3='b3md:0' Hz
#######
#######

select Sound 'name$'_v_'i'_band
To Spectrum (fft)
Viewport... 5 10 0 3
Draw... 0 5000 0 80 yes
Marks bottom... 6 yes yes no
One mark top... 'f1md:0' no yes yes  F1
One mark top... 'f2md:0' no yes yes  F2
One mark top... 'f3md:0' no yes yes  F3


#pause ok?
beginPause ("Passed?")
comment ("Are the formants o.k.?") 
comment ("F1: 'f1md:0'  F2: 'f2md:0'  F3: 'f3md:0'  F4: 'f4md:0'")
boolean ("F1ok", 1)
boolean ("F2ok", 1)
boolean ("F3ok", 1)
comment ("shift: unchecked will be replaced by next F-value")
comment ("correct: unchecked will appear as --undefined--")
comment ("no: write in error text file")
#boolean ("F4", 1)
passed = endPause ("yes or shift","correct","no",1)

if passed=2
if f1ok=0
f1md= undefined
f1Bmd=undefined
b1md=undefined
a1db=undefined
endif
if f2ok=0
#f2md=f3md
#f3md=undefined
f2md=undefined
f2Bmd=undefined
b2md=undefined
a2db=undefined
endif
if f3ok=0
f3md= undefined
f3Bmd=undefined
b3md=undefined
a3db=undefined
endif
fileappend 'outputdir$''filename$' 'w''tab$''stp:4''tab$''edp:4''tab$''vowlq$''tab$''vowlab$''tab$''lemma$''tab$''pos$''tab$''num$''tab$''f0md:1''tab$''f0mn:1''tab$'
...'f0sd:2''tab$''f1md:0''tab$''f2md:0''tab$''f3md:0''tab$''f1Bmd:3''tab$''f2Bmd:3''tab$''f3Bmd:3''tab$''dur:4''tab$'
...'b1md:0''tab$''b2md:0''tab$''b3md:0''tab$''a1db:1''tab$''a2db:1''tab$''a3db:1''tab$''name$''newline$'
elif passed = 1
if f1ok=1 and f2ok=0 and f3ok=1
#f1md=f1md
f2md=f3md
f3md=f4md
f2Bmd=f3Bmd
f3Bmd=f4Bmd
b2md=b3md
b3md=b4md
a2db=a3db
a3db=a4db
elif f1ok=1 and f2ok=1 and f3ok=0
#f1md=f1md
#f2md=f2md
f3md=f4md
f3Bmd=f4Bmd
b3md=b4md
a3db=a4db
endif
fileappend 'outputdir$''filename$' 'w''tab$''stp:4''tab$''edp:4''tab$''vowlq$''tab$''vowlab$''tab$''lemma$''tab$''pos$''tab$''num$''tab$''f0md:1''tab$''f0mn:1''tab$'
...'f0sd:2''tab$''f1md:0''tab$''f2md:0''tab$''f3md:0''tab$''f1Bmd:3''tab$''f2Bmd:3''tab$''f3Bmd:3''tab$''dur:4''tab$'
...'b1md:0''tab$''b2md:0''tab$''b3md:0''tab$''a1db:1''tab$''a2db:1''tab$''a3db:1''tab$''name$''newline$'
else
fileappend 'outputdir$''filename_err$' 'w''tab$''stp:4''tab$''edp:4''tab$''vowlq$''tab$''vowlab$''tab$''lemma$''tab$''pos$''tab$''num$''tab$''f0md:1''tab$''f0mn:1''tab$'
...'f0sd:2''tab$''f1md:0''tab$''f2md:0''tab$''f3md:0''tab$''f1Bmd:3''tab$''f2Bmd:3''tab$''f3Bmd:3''tab$''dur:4''tab$'
...'b1md:0''tab$''b2md:0''tab$''b3md:0''tab$''a1db:1''tab$''a2db:1''tab$''a3db:1''tab$''name$''newline$'
endif

endproc




################################Sven Grawunder, MPI EVA LEipzig, 2010-07-22, (c) Copyleft 2010 Sven Grawunder. ;-)

