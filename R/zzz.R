.onAttach <- function( lib, pkg ) {
  packageStartupMessage(
    paste0( "\nPlease cite the 'usdampr' package as:\n",
            "Elliott J. Dennis and Bowen Chen (2020). ",
            "Introduction to the R-Package: usdampr. ",
            "Farm and Ranch Management News. University of Nebraska at Lincoln. ",
            "DOI: 10.13014/frm00016.\n\n",
            "If you have questions, suggestions, or comments ",
            "regarding the 'usdampr' package, ",
            "please send an email to Dr. Dennis (elliott.dennis@unl.edu) or Dr. Chen (bwchen0719@gmail.com)."),
    domain = NULL,  appendLF = TRUE )
}
