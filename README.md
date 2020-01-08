# ProcessDesc
# Language: Perl
# Dependency: BioPerl
# Input: FASTA
# Output: TXT
# Tested with: PluMA 1.0,  Perl 5.18

PluMA plugin that takes a FASTA file as input and extracts information
from the description line, including:

Domain (i.e. Archaea, Bacteria)
Genus, Species, STrain, GenBank ID (if any) 

This information will be output in TXT format.

