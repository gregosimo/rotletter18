figdir = fig
latexfigures = Bruntt_comp.pdf   \
	       Pleiades_comp.pdf \
	       astero.pdf        \
	       cool_sample.pdf   \
	       astero_rot.pdf    \
	       cool_rot.pdf

Bruntt_comp.pdf: paperexport.py
	python paperexport.py Bruntt

Pleiades_comp.pdf: paperexport.py
	python paperexport.py SH

astero.pdf: paperexport.py
	python paperexport.py asterosamp

cool_samp.pdf: paperexport.py
	python paperexport.py coolsamp

astero_rot.pdf: paperexport.py
	python paperexport.py asterorot

cool_rot.pdf: paperexport.py
	python paperexport.py coolrot

figures: paperexport.py
	python paperexport.py all

tabledir = tables
tablelist := $(wildcard $(tabledir)/*)

mainfile = main
maintex = $(mainfile).tex

revision = main_mnras.tex

all: $(mainfile).pdf

mnras: mnras.tar.gz
	
mnras.tar.gz: $(mainfile).pdf $(latexfigures) $(tablelist)
	tar -zcf mnras.tar.gz $(maintex) main.bbl references.bib readme.mnras \
	    $(latexfigures) $(tablelist)

# Is there an automated way to add dependencies for tables and figures in here? 
# Ideally it should be read from the LaTeX file. Potentially stripped out, but
# that may be annoyingly difficult.
#
$(mainfile).pdf: $(maintex)
	latexmk -pdfdvi $(maintex)

$(mainfile).ps: $(maintex)
	latexmk -ps $(maintex)

$(mainfile).bbl: $(maintex)
	bibtex $(mainfile)

referee: diff.pdf
	
diff.pdf: $(revision) $(maintex)
	-rm diff.*
	latexdiff $(revision) $(maintex) > diff.tex
	latexmk -pdfdvi -interaction=nonstopmode diff.tex
	mv diff.tex diff.pdf referee_material

diff.ps: $(revision) $(maintex)
	-rm diff.*
	latexdiff $(revision) $(maintex) > diff.tex
	latexmk -ps -interaction=nonstopmode diff.tex
	mv diff.tex diff.pdf referee_material

arxiv: arxiv.tar.gz

arxiv.tar.gz: $(maintex) $(mainfile).bbl $(latexfigures) $(tablelist)
	tar -czf arxiv.tar.gz $(maintex) $(mainfile).bbl $(latexfigures) \
		$(tablelist) mnras.cls

.PHONY : clean
clean:
	-rm diff.*
	latexmk -C $(maintex)
