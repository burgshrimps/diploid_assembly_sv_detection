configfile: '/project/haplotyping/nico/scripts/diploid_assembly_sv_detection/config.yml'
workdir: '/project/haplotyping/nico/analysis/DiploidAssembly/'

print(config)

rule compute_wtdbg_squashed_assembly_layout:
    input: 
        fastq = 'input/fastq/pacbio/{sample}/{sample}_pacbio_subreads.fastq.gz'
    output: 
        layout = 'assemblies/squashed/wtdbg2/{sample}/{sample}.ctg.lay.gz'
    threads:
        config['num_cpu']
    shell: 
        'wtdbg2 -x sq -i {input.fastq} -g3g -t {threads} -o {output.layout}'


rule compute_wtdbg_squashed_assembly_consensus:
    input:
        layout = 'assemblies/squashed/wtdbg2/{sample}/{sample}.ctg.lay.gz'
    output:
        squashed_assembly = 'assemblies/squashed/wtdbg2/{sample}/{sample}_sqa-wtdbg.fasta'
    threads:
        config['num_cpu']
    shell:
        'wtpoa-cns -t {threads} -i {input.layout} -o {output.squashed_assembly}'

