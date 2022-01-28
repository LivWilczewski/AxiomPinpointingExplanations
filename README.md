# AxiomPinpointingExplanations
realization of the axiom pinpointing algorithm for explanatory dialogs

The repository contains the following structure:
src
 + dl
   - PFC_DL.owl
 + pl
   - axiom_pinpointing.pl
   - input.pl
   - io.pl
   - main.pl

The dl directory contains the translation of the input.pl in form of an OWL/XML file.
This can be used to visualize the ontology in Protégé 
(https://protege.stanford.edu/products.php#desktop-protege).

The pl directory contains the code to run the axiom pinpointing in Prolog.
Therefore install SWI-Prolog (https://www.swi-prolog.org/) and 
start the main.pl from the directory it is stored in using the console:

?- swipl main.pl
