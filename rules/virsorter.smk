# Implementation of https://www.protocols.io/view/viral-sequence-identification-sop-with-virsorter2-5qpvoyqebg4o/v3 

DIR=os.path.join(config['DIR_virsorter'],'{sample}')


rule virsorter:
    input:
        contig=os.path.join(config["DIR_assembly"],'{sample}'+config['SUFFIX_assembly']),
    output:
        vs=directory(os.path.join(DIR, 'vs2_pass1')),
        vs_fa = os.path.join(DIR,'vs2_pass1','final-viral-combined.fa'),
    conda: 'vs2'
    threads: config['threads']
    params: min_length=config['min_length']
    shell:
        """
        virsorter run -w {output.vs} -j {threads} -i {input.contig} --min-length {params.min_length} --min-score 0.5 --include-groups dsDNAphage,NCLDV,RNA,ssDNA,lavidaviridae all
        """

rule checkv:
    input:
        vs_fa = os.path.join(DIR, 'vs2_pass1','final-viral-combined.fa')
    output:
        checkv= directory(os.path.join(DIR,'checkv'))
    params: 
        checkv_db = config['PATH_checkv_db']
    conda: 'checkv'
    threads: config['threads']
    shell:
        """
        checkv end_to_end {input.vs_fa} -t {threads} -d {params.checkv_db} {output.checkv} 
        """

rule virsorter_pass2:
    input:
        checkv=os.path.join(DIR,'checkv')
    output:
        vs_2=directory(os.path.join(DIR,'vs2_pass2')),
        vs_2_fa = os.path.join(DIR, 'vs2_pass2','for-dramv','final-viral-combined-for-dramv.fa'),
        vs_2_dramv = os.path.join(DIR, 'vs2_pass2','for-dramv','viral-affi-contigs-for-dramv.tab')
    conda: 'vs2'
    threads: config['threads']
    params: min_length=config['min_length']
    shell:
        """
        cat {input.checkv}/proviruses.fna {input.checkv}/viruses.fna > {input.checkv}/combined.fna
        virsorter run --seqname-suffix-off --viral-gene-enrich-off --provirus-off --prep-for-dramv -i {input.checkv}/combined.fna -w {output.vs_2} --include-groups dsDNAphage,NCLDV,RNA,ssDNA,lavidaviridae --min-length {params.min_length} --min-score 0.5 -j {threads} all
        """

rule DRAMv:
    input:
        vs_2_fa = os.path.join(DIR, 'vs2_pass2','for-dramv','final-viral-combined-for-dramv.fa'),
        vs_2_dramv = os.path.join(DIR, 'vs2_pass2','for-dramv','viral-affi-contigs-for-dramv.tab')
    output:
        dramv=directory(os.path.join(DIR,'dramv')),
        dramv_annotate = os.path.join(DIR,'dramv','annotations.tsv'),
        dramv_distill = directory(os.path.join(DIR,'dramv','distilled')),        
    conda: 'DRAM'
    threads: config['threads']
    shell:
        """
        rm -rf {output.dramv}
        rm -rf {output.dramv_distill}
        DRAM-v.py annotate -i {input.vs_2_fa} -v {input.vs_2_dramv} -o {output.dramv}  --threads {threads} 
        DRAM-v.py distill -i {output.dramv_annotate} -o {output.dramv_distill}
        """
