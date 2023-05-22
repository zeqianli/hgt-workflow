rule mobileog:
    input: 
        contig=os.path.join(config["DIR_assembly"],'{sample}'+config['SUFFIX_assembly'])
    output:
        prodigal=os.path.join(config["DIR_mobileog"],'{sample}.faa'),
        diamond=os.path.join(config["DIR_mobileog"],'{sample}.tsv'),
        mobileog=os.path.join(config["DIR_mobileog"],'{sample}.summary.csv')
    params:
        mobileog_exc=config['EXC_mobileog'],
        diamond_db=os.path.join(config['PATH_mobileog_db'],"mobileOG-db_beatrix-1.6.dmnd"),
        mobileog_meta=os.path.join(config['PATH_mobileog_db'],"mobileOG-db-beatrix-1.6-All.csv"),
        output_prefix=os.path.join(config["DIR_mobileog"],'{sample}')
    conda: "mobileog"
    threads: 1
    shell:
        """
        prodigal -i {input.contig} -p meta -a {output.prodigal}
        diamond blastp -q {output.prodigal} --db {params.diamond_db} --outfmt 6 stitle qtitle pident bitscore slen evalue qlen sstart send qstart qend -k 15 -o {output.diamond} -e 1e-20 --query-cover 90 --id 90
        python {params.mobileog_exc} --o {params.output_prefix} --i {output.diamond} -m {params.mobileog_meta}
        """