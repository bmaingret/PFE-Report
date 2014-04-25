#
# CITI Research Report
#
# 07/2012: Paul Ferrand - Initial Template
# 02/2013: Frederic Le Mouel - Makefile + new logo + restructure
#

#
# Variables
#

#
# Environment variables
#

CD    = cd
CHMOD = chmod
FIND  = find
LN    = ln
MV    = mv
RM    = rm

#
# Prog variables
#

LATEX       = latex
BIBTEX      = bibtex
XDVI        = xdvi
DVI2PS      = dvips
DVI2PDF     = dvipdf
TEX2HTML    = latex2html -no_navigation -split 0 -address "me@insa-lyon.fr (C)INSA Lyon 2013"

.SUFFIXES: .tex .bib .aux .bbl .dvi .eps .fig .ps .pdf .html

#
# LaTeX file variables
#

TXT_FILE1 = RR_CITI

LATEX_FILE1  = $(TXT_FILE1).tex
BIBTEX_FILE1 = $(TXT_FILE1).bib

AUX_FILE1 = $(TXT_FILE1).aux
BIB_FILE1 = $(TXT_FILE1).bbl
BLG_FILE1 = $(TXT_FILE1).blg
BRF_FILE1 = $(TXT_FILE1).brf
LOG_FILE1 = $(TXT_FILE1).log
LOT_FILE1 = $(TXT_FILE1).lot
LOF_FILE1 = $(TXT_FILE1).lof
OUT_FILE1 = $(TXT_FILE1).out
DVI_FILE1 = $(TXT_FILE1).dvi

#
# Figures variables
#

FIG_DIR = ./figures

#
# Outputs files variables
#

PS_FILE1  = $(TXT_FILE1).ps

PDF_FILE1 = $(TXT_FILE1).pdf

HTML_FILE1 = $(TXT_FILE1).html

#
# Make without dependencies : let's make tex
#

make_without_dependencies: tex

#
# Let's make all
#

all: tex ps pdf html view

#
# Let's make figures
#

fig:
	( $(CD) $(FIG_DIR); $(MAKE) $(MFLAGS) fig )

#
# Let's make LaTeX file
#

#tex: fig aux bib dvi
tex: aux bib dvi

.tex.aux:
	$(LATEX) $<
	$(CHMOD) g+r $(<:.tex=.log)
	$(CHMOD) g+r $@
	$(RM) $(<:%tex=%dvi)

aux: $(AUX_FILE1)

.tex.dvi: 
	$(LATEX) $<
	$(CHMOD) g+r $(<:.tex=.log)
	$(CHMOD) g+r $(<:.tex=.aux)
	$(CHMOD) g+r $@

dvi: bib $(DVI_FILE1)

#
# Bibliography file
#

%.bbl : %.bib %.tex
	$(BIBTEX) $(<:.bib=)
	$(CHMOD) g+r $(<:.bib=.blg)
	$(CHMOD) g+r $@
	$(LATEX) $(<:%bib=%tex)
	$(CHMOD) g+r $(<:.tex=.log)
	$(CHMOD) g+r $(<:.tex=.aux)
	$(RM) $(<:%bib=%dvi)

bib: aux $(BIB_FILE1)

#
# Let's see
#

view: tex
	$(XDVI) $(DVI_FILE1) &

#
# Let's make outputs
#

#
# Postscript
#

.dvi.ps:
	$(DVI2PS) $< -o $@
	$(CHMOD) g+r $@

ps: tex $(PS_FILE1)

#
# Pdf
#

.dvi.pdf:
	$(DVI2PDF) $< $@
	$(CHMOD) g+r $@

pdf: tex $(PDF_FILE1)

#
# HTML
#

.tex.html:
	$(TEX2HTML) $<
	$(FIND) $(<:.tex=) -type d -exec $(CHMOD) g+rx {} \; -ls
	$(FIND) $(<:.tex=) -type f -exec $(CHMOD) g+r {} \; -ls
	$(LN) -s -f $(<:.tex=)/$@ $@

html: tex $(HTML_FILE1)

#
# Clean of the directory
#

#clean: clean_fig clean_tex clean_bib clean_ps clean_pdf clean_html
clean: clean_tex clean_bib clean_ps clean_pdf clean_html

clean_fig:
	( $(CD) $(FIG_DIR) ; $(MAKE) $(MFLAGS) clean_fig )

clean_tex:
	$(RM) -f $(AUX_FILE1) $(LOG_FILE1) $(LOT_FILE1) $(LOF_FILE1) $(DVI_FILE1) $(OUT_FILE1) $(BRF_FILE1) $(TXT_FILE1).idx $(TXT_FILE1).toc

clean_bib:
	$(RM) -f $(BIB_FILE1) $(BLG_FILE1)

clean_ps:
	$(RM) -f $(PS_FILE1)

clean_pdf:
	$(RM) -f $(PDF_FILE1)

clean_html:
	$(RM) -rf $(TXT_FILE1) $(HTML_FILE1)

