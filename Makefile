LATEX       = pdflatex -interaction=nonstopmode -halt-on-error
LATEXMK     = latexmk -pvc -pdf
BASH        = bash -c
ECHO        = echo
RM          = rm -rf
TMP_SUFFS   = pdf aux bbl blg log dvi ps eps out brf
CHECK_RERUN =

NAME = main

.PHONY: latexmk

all: ${NAME}.pdf

gitstuff.tex: .git/logs/HEAD
	echo "%%% This file is generated by the Makefile." > gitstuff.tex
	git log -1 --date=short --format="format:\\newcommand{\\githash}{%h}\\newcommand{\\gitdate}{%ad}\\newcommand{\\gitauthor}{%an}" >> gitstuff.tex

${NAME}.pdf: ${NAME}.tex *.bib gitstuff.tex
	${LATEX} ${NAME}
	bibtex ${NAME}
	${LATEX} ${NAME}
	( grep "Rerun to get" ${NAME}.log && ${LATEX} ${NAME} ) || echo "Done."
	( grep "Rerun to get" ${NAME}.log && ${LATEX} ${NAME} ) || echo "Done."

latexmk: ${NAME}.tex *.bib gitstuff.tex
	${LATEXMK} ${NAME}.tex

clean:
	${RM} $(foreach suff, ${TMP_SUFFS}, ${NAME}.${suff})
	${RM} *.aux
	${RM} gitstuff.tex
	${RM} *Notes.bib
