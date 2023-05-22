rule genomecov:
    input: 
        bam = None
        assembly = None
    output: 
        bed = None
    conda: 'bedtools'
    threads: 1
    shell:
    """
    bedtools genomecov -ibam {input.bam} -g {input.assembly} -d > {output.bed}
    """
    
#     bedtools genomecov -ibam /home/zeqianli/scratch-midway3/Mats/bam_sorted/OS60.bam -g /home/zeqianli/project/zeqian/Mats/data/metagenome/contigs/OS60.contigs.fa -d > /home/zeqianli/project/zeqian/Mats/data/metagenome/genomecov/OS60.genomecov.bed