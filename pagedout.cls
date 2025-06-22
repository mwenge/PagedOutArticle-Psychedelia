%% This is file `pagedout.cls',
%% extended `extarticle.cls' by wiechu
%%
%% This file may be distributed under the terms of the Latex Project
%% public licence
%%
%% This system is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{pagedout}[
    2019-05-12 v0.1
 Paged Out! LaTeX document class]
%
\newdimen\@PaperHeight
\newdimen\@PaperWidth
\newdimen\@TextHeight
\newdimen\@TextWidth
\newdimen\@Topmargin
%
\setlength\@TextHeight {252mm}
\setlength\@TextWidth  {174mm}
\setlength\@Topmargin  {7mm}
%
\RequirePackage{color} % XXX dirty trick
\newcommand\@xptsize{}
\newif\if@landscape
\@landscapefalse
\DeclareOption{pagedoutpaper}
   {\setlength\@PaperHeight {11in}%
    \setlength\@PaperWidth  {210mm}}
\DeclareOption{a4paper}
   {\setlength\@PaperHeight {297mm}%
    \setlength\@PaperWidth  {210mm}%
    \setlength\@Topmargin  {16mm}}
\DeclareOption{letterpaper}
   {\setlength\@PaperHeight {11in}%
    \setlength\@PaperWidth  {8.5in}}
\DeclareOption{landscape}{\@landscapetrue}
\DeclareOption{maxwidth}{\setlength\@TextWidth {182mm}}
\DeclareOption{8pt}{\renewcommand\@xptsize{8pt}}
\DeclareOption{9pt}{\renewcommand\@xptsize{9pt}}
\DeclareOption{10pt}{\renewcommand\@xptsize{10pt}}
\DeclareOption{11pt}{\renewcommand\@xptsize{11pt}}
\DeclareOption{12pt}{\renewcommand\@xptsize{12pt}}
\DeclareOption{14pt}{\renewcommand\@xptsize{14pt}}
\DeclareOption{17pt}{\renewcommand\@xptsize{17pt}}
\DeclareOption{draft}{\setlength\overfullrule{5pt}}
\DeclareOption{final}{\setlength\overfullrule{0pt}}
\DeclareOption{onecolumn}{\@twocolumnfalse}
\DeclareOption{twocolumn}{\@twocolumntrue}
\DeclareOption{leqno}{\input{leqno.clo}}
\DeclareOption{fleqn}{\input{fleqn.clo}}
\ExecuteOptions{pagedoutpaper,10pt,onecolumn,final}
\ProcessOptions
\if@twocolumn
  \LoadClass[\@xptsize,twocolumn]{extarticle}
\else
  \LoadClass[\@xptsize,onecolumn]{extarticle}
\fi
\def\InitLayout{
  \setlength{\paperheight}{\@PaperHeight}
  \setlength{\paperwidth}{\@PaperWidth}
  \setlength{\headheight}{0pt}
  \setlength{\headsep}{0pt}
  \setlength{\footskip}{0pt}
  \if@landscape
    \setlength\@tempdima   {\paperheight}%
    \setlength\paperheight {\paperwidth}%
    \setlength\paperwidth  {\@tempdima}%
    \setlength\@tempdima   {\@TextHeight}%
    \setlength\@TextHeight {\@TextWidth}%
    \setlength\@TextWidth  {\@tempdima}
  \fi
  \setlength{\textwidth}{\@TextWidth}
  \setlength{\textheight}{\@TextHeight}
  \if@landscape
    \setlength\@tempdima {\paperwidth}
    \addtolength\@tempdima {-\textwidth}
    \addtolength\@tempdima {-\@Topmargin}
%    \setlength{\oddsidemargin}{\@tempdima}
%    \setlength{\evensidemargin}{\@Topmargin}
    \setlength{\evensidemargin}{\@tempdima}
    \setlength{\oddsidemargin}{\@Topmargin}
    \setlength\@tempdima {\paperheight}
    \addtolength\@tempdima {-\textheight}
    \setlength\@tempdima {.5\@tempdima}
    \setlength{\topmargin}{\@tempdima}
  \else
    \setlength\@tempdima {\paperwidth}
    \addtolength\@tempdima {-\textwidth}
    \setlength\@tempdima {.5\@tempdima}
    \setlength{\oddsidemargin}{\@tempdima}
    \setlength{\evensidemargin}{\@tempdima}
    \setlength{\topmargin}{\@Topmargin}
  \fi
  \addtolength{\oddsidemargin}{-1in}
  \addtolength{\evensidemargin}{-1in}
  \addtolength{\topmargin}{-1in}
}
%
\InitLayout
\pagestyle{empty}
%
\endinput%%
%% End of file `pagedout.cls'.
