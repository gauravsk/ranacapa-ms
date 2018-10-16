---
title: ""
author: ""
date: ""
output:
  pdf_document: 
fontfamily: mathpazo
urlcolor: blue
geometry: top=0.5in
fontsize: 10pt
header-includes: 
  \usepackage{color} 
  \usepackage{float}
  \usepackage[table]{xcolor} 
  \usepackage{setspace}
  \usepackage{amsmath}
  \numberwithin{equation}{section} 
  \usepackage{parskip}
  \usepackage{tabularx}
  \setlength{\parindent}{0ex}
bibliography: bibliography.bib
csl: rendering-templates/ecology-letters.csl

---
\begin{tabularx}{\textwidth}{lXr}
\begin{tabular}[l]{@{}l@{}}\textbf{Editors of F1000 Research}\\  \textit{Software Tool Articles} Submission  \end{tabular} & & \begin{tabular}[r]{@{}r@{}}\textbf{Gaurav S. Kandlikar}\\ University of California, Los Angeles\\ gkandlikar@ucla.edu \\  \end{tabular}
\end{tabularx}

\vspace{1cm}

Dear editors of *F1000 Research*:
  
We are pleased to submit our paper "ranacapa: An R package and Shiny web app to explore environmental DNA data with exploratory statistics and interactive visualizations" for consideration as a Software Tool Article in your journal. Our paper should be of interest to your readers because it describes a tool designed to make community-wide taxonomy data generated in environmental DNA (eDNA) metabarcoding studies accessible to non-technical audiences. It is a timely contribution in light of recent developments in eDNA sample collection (e.g. @Thomas_2018) and taxonomy assignment [@Arulandhu_2017] techniques, as well as advances in public outreach programs that rely on eDNA metabarcoding to describe and monitor biodiversity. 

A growing number of education, biodiversity monitoring, and public outreach programs are using eDNA metabarcoding as a platform to engage community partners in primary research. Although it is relatively easy to train non-experts to collect samples in the field, it is difficult to train these partners to interact with other elements of eDNA research, which require considerable bioinformatics skills. This difficulty for community partners to fully engage with the raw results from these studies can limit the long term success of eDNA metabarcoding-based community science programs, as the success of such programs depends on community partners feeling empowered to engage in multiple parts of the research process, including data visualization and analyses [@Pandya_2012]. 

Our `R` package and Shiny web app `ranacapa` addresses this challenge by enabling users to easily visualize and perform simple community ecology analyses with results from eDNA metabarcoding projects. `ranacapa` can work with files in the widely used `BIOM` format or the files generated from the Anacapa sequence analysis toolkit, which is being used by the CALeDNA community science project (http://www.ucedna.com/).

For reviewers, we suggest Dr. Lucie Zinger (CNRS, France), Dr. Holly Bik (Univ. of California- Riverside), and Dr. Jim McNeil (George Mason University).

We confirm that all authors agree to the submission of this article, that this is a novel article, and that it is not currently submitted elsewhere for publication (or already published elsewhere).

Many thanks for your time.

Sincerely,  
Gaurav Kandlikar  
On behalf of my co-authors: Zachary Gold, Madeline Cowen, Rachel Meyer, Amanda Freise, Nathan Kraft, Jordan Moberg-Parker, Joshua Sprague, David Kushner, and Emily Curd

### References

\small