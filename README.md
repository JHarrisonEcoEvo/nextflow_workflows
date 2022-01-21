# nextflow_goodies
Nextflow workflows for various bioinformatics with associated Docker containers. 


WORKFLOWS:

se_demux_to_bam_bai_denovo - Takes single-end Illumina reads, makes a de novo reference, and aligns samples to those reads. Bam and bai files are output.
[Associated Docker repo](https://hub.docker.com/r/harrisonjg/nf_se_demux_to_bam_bai_denovo)

gbs_nextflow - In progress. This will be an all encompassing RADseq workflow. Currently determining if this makes sense versus using several smaller workflows.

![CircleCI status](https://app.circleci.com/pipelines/github/JHarrisonEcoEvo/nextflow_gbs?style=shield)

