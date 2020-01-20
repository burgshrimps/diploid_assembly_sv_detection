configfile: '/project/haplotyping/nico/scripts/diploid_assembly_sv_detection/config.yml'
workdir: '/project/haplotyping/nico/analysis/DiploidAssembly/'

rule compute_wtdbg_squashed_assembly_layout:
    input:
        fastq = 'input/fastq/pacbio/{sample}/{sample}_pacbio_subreads.fastq.gz',
    output:
        layout = 'assemblies/squashed/wtdbg2/{sample}/{sample}.ctg.lay.gz',
    log:
        'log/assemblies/squashed/wtdbg2/{sample}/{sample}.layout.log',
    benchmark:
        'run/assemblies/squashed/wtdbg2/{sample}/{sample}.layout.rsrc',
    threads:
        config['num_cpu'],
    resources:
        mem_per_cpu_mb = 5000,
        mem_total_mb = 160000,
    shell:
        'wtdbg2 -x sq -i {input.fastq} -g3g -t {threads} -o {output.layout} &> {log}'


rule compute_wtdbg_squashed_assembly_consensus:
    input:
        layout = 'assemblies/squashed/wtdbg2/{sample}/{sample}.ctg.lay.gz',
    output:
        squashed_assembly = 'assemblies/squashed/wtdbg2/{sample}/{sample}_sqa-wtdbg.fasta',
    log:
        'log/assemblies/squashed/wtdbg2/{sample}/{sample}_sqa-wtdbg.consensus.log',
    benchmark:
        'run/assemblies/squashed/wtdbg2/{sample}/{sample}_sqa-wtdbg.consensus.rsrc',
    threads:
        config['num_cpu'],
    resources:
        mem_per_cpu = 384,
        mem_total_mb = 122888,
    shell:
        'wtpoa-cns -t {threads} -i {input.layout} -o {output.squashed_assembly} &> {log}'
