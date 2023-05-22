import pandas as pd
import os 
configfile: "config/config.yml"

for key, value in config.items():
    if key.startswith('DIR') and key!='DIR_output' and '/' not in value:
        config[key] = os.path.join(config['DIR_output'], value)

for key,value in config.items():
    if key.startswith('DIR') and not os.path.exists(value):
        os.makedirs(value)

# read samples 
samples=None
if "FILE_sample_list" in config and bool(config['FILE_sample_list']):
    samples=pd.read_csv(config['FILE_sample_list'], sep='\t', header=None,dtype=str).values.flatten()
    if len(samples)==0:
        samples=None
    else:
        print("Samples: ",samples)

if samples is None:
    print("No sample list provided. Running all samples in the assembly directory.")
    samples=[ff.split('.')[0] for ff in os.listdir(config['DIR_assembly']) if ff.endswith(config['SUFFIX_assembly'])]

with open("output/samples.txt",'w') as f:
    f.write('\n'.join(samples))

rule all:
    input:
        expand(os.path.join(config['DIR_assembly'],"{sample}"+config['SUFFIX_assembly']),sample=samples), # assemblies
        expand(os.path.join(config['DIR_virsorter'],"{sample}","vs2_pass1"),sample=samples), # virsorter
        expand(os.path.join(config['DIR_virsorter'],"{sample}","checkv"),sample=samples),
        expand(os.path.join(config['DIR_virsorter'],"{sample}","vs2_pass2"),sample=samples),
        expand(os.path.join(config['DIR_virsorter'],"{sample}","dramv"),sample=samples),
#expand(os.path.join(config["DIR_mobileog"],'{sample}.summary.csv'),sample=samples)  # mobileog
include: "rules/virsorter.smk"
# #include: "rules/mobileog.smk"
