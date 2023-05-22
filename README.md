# Detect horizontal gene transfer events from metagenome data

Zeqian Li

Last updated: May 21st, 2023

*This is a work in progress.* A Snakemake pipeline to detect different kinds of horizontal gene transfer (HGT) signatures. 

Currently includes:
- Detect mobile gene elements using mobileOG 
- Detect virus using VirSorter2 (follows [VirSorter2 SOP](https://www.protocols.io/view/viral-sequence-identification-sop-with-virsorter2-5qpvoyqebg4o/v3))
    - VirSorter2 pass 1
    - CheckV for quality control
    - VirSorter2 pass 2 to prepare annotation
    - Annotation using DRAMv

## Usage 

Install the following conda environments and packages:
- mobileog: mobileOG
- vs2: VirSorter2
- checkv: CheckV
- DRAM: DRAM

Run:
- Change configurations in `config/config.yml`. See commments in the file. 
- Dry run for testing: 
    ``` snakemake --cores all -n ```
- Actual run
``` snakemake --cores all --conda-frontend conda --use-conda -k```
- Use a custom config file: 
``` snakemake --cores all --configfile config/config_sag.yml --conda-frontend conda --use-conda -k```

## Future features:

Future features:
- [Tycheposons](https://www.cell.com/cell/fulltext/S0092-8674(22)01519-7#.Y7dGwMz7Nbw.twitter) detection 
- Better viral curation

Future improments:
- Automate database installation 
- Automate Conda installation using yaml configs