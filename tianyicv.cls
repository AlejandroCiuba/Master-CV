\NeedsTeXFormat{LaTeX2e}

\newcommand{\thispackage}{tianyicv}

\ProvidesClass{\thispackage}[2024/07/08 Tianyi's CV document class]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass{article}

\RequirePackage{adjustbox}
\RequirePackage[backend=biber, style=verbose, maxnames=99]{biblatex}
\RequirePackage[outline]{contour}
\RequirePackage[inline]{enumitem}
\RequirePackage{etoolbox}
\RequirePackage{fancyhdr}
\RequirePackage[margin=1in]{geometry}
\RequirePackage{lastpage}
\RequirePackage{microtype}
\RequirePackage{tabularx}
\RequirePackage{titlesec}
\RequirePackage[normalem]{ulem}
\RequirePackage[hidelinks]{hyperref}

\pagestyle{fancy}
\fancyhfoffset{0pt}
\fancyhead{}
\renewcommand{\headrule}{}
\fancyfoot[C]{Page \thepage\ of \pageref{LastPage}}
\fancypagestyle{plain}{}    % Redefine plain to be same as fancy

\setcounter{secnumdepth}{0}

\titleformat{\section}{\Large\bfseries}{}{}{}[\titlerule]
\titlespacing{\section}{0em}{1em}{1em}  % Change to 0em 0em 0.5em for Resumes

\g@addto@macro\bfseries{\boldmath}  % Make math bold in bold text

\setlist{nosep}
\setlist[itemize]{leftmargin=1.5em}     % Indentation for itemize bullet points
\setlist[enumerate]{leftmargin=1.5em}   % Indentation for enumerate numbers

\newcommand{\itemspace}{\medskipamount}

% See enumitem documentation, section 4, inline lists
\newlist{commalist}{description*}{20}
\setlist[commalist]{
    itemjoin={{, }},
    afterlabel={},      % Remove space after non-existent label
    mode=unboxed
}

\contourlength{0.075em}             % Contour width for links
\contournumber{256}                 % Countour count (fidelity) for links
\renewcommand{\ULdepth}{0.175em}     % Underline depth for links

\NewDocumentCommand{\link}{om}{\textcolor{blue}{\uline{\phantom{\IfValueTF{#1}{#1}{#2}}}\llap{\contour{white}{\href{#2}{\IfValueTF{#1}{#1}{#2}}}}}}

\NewDocumentCommand{\email}{m}{\gdef\@email{#1}}
\NewDocumentCommand{\@email}{}{\ClassWarning{\thispackage}{No \noexpand\email provided}}

\newbool{phonedefined}
\NewDocumentCommand{\phone}{m}{%
    \gdef\@phone{#1}%
    \booltrue{phonedefined}%
}

\newbool{datedefined}
\RenewDocumentCommand{\date}{m}{%
    \gdef\@date{#1}%
    \booltrue{datedefined}%
}

\newbool{homepagedefined}
\NewDocumentCommand{\homepage}{m}{%
    \gdef\@homepage{#1}%
    \booltrue{homepagedefined}%
}

\newbool{linkedindefined}
\NewDocumentCommand{\linkedin}{m}{%
    \gdef\@linkedin{#1}%
    \booltrue{linkedindefined}%
}

\newbool{githubdefined}
\NewDocumentCommand{\github}{m}{%
    \gdef\@github{#1}%
    \booltrue{githubdefined}%
}

\newbool{addressdefined}
\NewDocumentCommand{\address}{m}{%
    \gdef\@address{%
        \begin{adjustbox}{valign=t, stack=l}
            #1
        \end{adjustbox}
    }
    \booltrue{addressdefined}%
}


\newcommand{\separator}{~\textbullet~}
\RenewDocumentCommand{\maketitle}{}{%
    \ifbool{addressdefined}{%
        \begin{center}
            {\Huge\bfseries\@author}
        \end{center}

        \@address
    }{%
        \begin{adjustbox}{valign=t, stack=l}
            {\Huge\bfseries\@author}
        \end{adjustbox}
    }
    \hfill
    \begin{adjustbox}{valign=t, stack=l}
        Email: \link[\@email]{mailto:\@email}

        \ifbool{phonedefined}{%
            Phone: \@phone%
        }{}

        \ifbool{homepagedefined}{%
            Homepage: \link[\@homepage]{https://\@homepage}%
        }{}

        \ifbool{linkedindefined}{%
            LinkedIn: \link[\@linkedin]{https://\@linkedin}%
        }{}

        \ifbool{githubdefined}{%
            GitHub: \link[\@github]{https://\@github}%
        }{}

        \ifbool{datedefined}{%
            Last Updated: \@date%
        }{}
    \end{adjustbox}
    \bigskip  % For CVs
    % \medskipamount  % For resumes
}

% \NewDocumentCommand{\education}{mmmmmod()}{%
%     \textbf{#1} \hfill #4

%     \nopagebreak
%     \textit{#2} \hfill #3
%     % If listing minors and/or GPA
%     \IfNoValueTF{#6}{
%         \IfNoValueTF{#7}{\IfBlankF{#5}{\nopagebreak#5}}
%         % {
%         %     \begin{tabularx}{1\linewidth}{X{\raggedleft}l}
%         %         \IfBlankF{#5}{#5} &  \hfill GPA: #7 \\
%         %     \end{tabularx}
%         % }
%     }
%     {
%         \par\nopagebreak\textit{#6}\IfNoValueF{#7}{ \hfill GPA: #7}
%         \IfBlankF{#5}{\nopagebreak#5}
%     }
%     \par    % \addvspace only works in vertical mode: https://tex.stackexchange.com/a/14694
%     \addvspace{\itemspace}%
% }

% Custom PhD command for adding research focus and advisor information
% d represents any additional advisors or committee members, o is GPA
\NewDocumentCommand{\phd}{mmmmmmo}{%
    \textbf{#1} \hfill #4

    \nopagebreak
    \textit{#2} \hfill #3

    \begin{itemize}
        \item \textbf{Research:} #5 \IfNoValueF{#7}{\hfill GPA: #7}
    \end{itemize}
    #6
    \par    % \addvspace only works in vertical mode: https://tex.stackexchange.com/a/14694
    \addvspace{\itemspace}%
}

% For general bachelor's or master's; optional is minor and d is for GPA
\NewDocumentCommand{\education}{mmmmmmo}{%
    \textbf{#1} \hfill #4

    \nopagebreak
    \textit{#2} \hfill #3

    \IfBlankF{#5}{
        \nopagebreak\textit{#5}\IfNoValueF{#5}{ \hfill GPA: #7}

    }
    \IfBlankF{#6}{\nopagebreak#6}
    \par    % \addvspace only works in vertical mode: https://tex.stackexchange.com/a/14694
    \addvspace{\itemspace}%
}

\NewDocumentCommand{\experience}{mmmmm}{%
    \textbf{#1} \hfill #4

    \nopagebreak
    \textit{#2} \hfill #3

    \IfBlankF{#5}{\nopagebreak#5}
    \par    % \addvspace only works in vertical mode: https://tex.stackexchange.com/a/14694
    \addvspace{\itemspace}%
}

\NewDocumentEnvironment{ publications }{o+b}{%
    \IfNoValueF{#1}{\textbf{#1} \hfill}

    #2
}

\NewDocumentEnvironment{ publications* }{b}{%
    \textbf{Miscellaneous \hfill}

    #1
}

\NewDocumentCommand{\publication}{mo}{%
    #1

    \IfNoValueF{#2}{\nopagebreak\hspace{1.5em}\textit{#2}}
    \par    % \addvspace only works in vertical mode: https://tex.stackexchange.com/a/14694
    \addvspace{\itemspace}%
}

\NewDocumentCommand{\award}{mmo}{%
    \textbf{#1} \hfill #2

    \IfNoValueF{#3}{\nopagebreak\textit{#3}}
    \par    % \addvspace only works in vertical mode: https://tex.stackexchange.com/a/14694
    \addvspace{\itemspace}%
}

\NewDocumentCommand{\skill}{mo}{%
    \textbf{#1}

    \IfNoValueF{#2}{\nopagebreak#2}
    \par    % \addvspace only works in vertical mode: https://tex.stackexchange.com/a/14694
    \addvspace{\itemspace}%
}

\NewDocumentCommand{\entry}{mmmmm}{%
    \textbf{#1}\IfBlankF{#2}{\hfill #4}

    \IfBlankF{#2}{\nopagebreak\textit{#2}}\IfBlankF{#3}{\IfBlankT{#2}{\nopagebreak}\hfill #3}

    \IfBlankF{#5}{\nopagebreak#5}
    \par    % \addvspace only works in vertical mode: https://tex.stackexchange.com/a/14694
    \addvspace{\itemspace}
}

\raggedright