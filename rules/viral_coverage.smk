rule create_bed_file:
    input:
        virsorter_coverage=os.path.join(config['DIR_virsorter'],'{sample}','final-viral-boundry.tsv')
    output:
        bed = os.path.join(config['DIR_virsorter'],'{sample}','viral_boundry.bed')
    threads: 1
    run:
        df=pd.read_csv(input.virsorter_coverage,sep="\t")
        df['contig']=df['seqname'].apply(lambda x: '_'.join(x.split('_')[:-1]))
        df[['contig','trim_bp_start','trim_bp_end','seqname']].to_csv(output.bed,sep="\t",header=False,index=False)

rule viral_coverage:
    input:
        bam = os.path.join(config['DIR_bam'],'{sample}.bam'),
        bed = os.path.join(config['DIR_virsorter'],'{sample}','viral_boundry.bed')
    output:
        coverage = os.path.join(config['DIR_virsorter'],'{sample}','coverage.txt')
    threads: 1
    conda: 'bedtools'
    shell:
        """
        bedtools coverage -abam {input.bam} -b {input.bed} > {output.coverage}
        """
    