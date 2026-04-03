# TODO: change docs, diagrams, & this page to reflect CF usage.

## CF usage concept

1. Support CF cards which support legacy 8-bit mode (most of them)
2. Require cards of <= 2TB (should not be a limiting factor), so that LBA arithmetic can be handled with 32-bit arithmetic
3. Leverage GUID Partition Tables
4. Map specific partition UUID types onto supported CP/M filesystem layouts
5. First partition found with a supported UUID and bootable flag (bit 2) set will be used to load OS from system area
6. CP/M can mount all parititons with supported UUIDs (up to system limit of 16) 
7. Linux scripting to support using cpmtools to create/manage partitions and matching CP/M filesystems
8. Read CF identity data on boot, and error if CF card is larger than 2TB :)

Re-use the 512-byte LBA -> 128 byte sector logic/code from Z80-Retro. Eventually do the same with the cache, but also alter the cache code so that NMI can still be handled, regardless of selected page.

TODO: Consider whether the GUID/UUID -> dpb/dph mapping can be done in jettisonable code on cold boot, to save sapce.

To compile this document into a pdf file requires the use of LaTex.
Install LaTeX on Ubuntu or Raspberry Pi OS like this:

	sudo apt install texlive-latex-extra

To create a pdf file:

	make

To install a pdf file viewer, install evince like this:

	sudo apt install evince

To open the pdf file with evince:

	evince 2063-Z80-cpm.pdf
