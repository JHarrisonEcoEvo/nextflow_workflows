# nextflow_goodies
Nextflow workflows for various bioinformatics associated with genotyping-by-sequencing and RADseq style studies, with associated Docker containers. 

NOTE: most HPCs do not allow Docker be used because the Docker daemon requires root access. Singularity is used for containers instead. To pull a Docker container from DockerHub and convert it to Singularity use the following command (change the container name, of course):

singularity pull docker://harrisonjg/nf_se_demux_to_bam_bai_denovo:latest

Then modify the Nextflow config file to have these lines: 

process {
    singularity.enabled = true
    
    container = 'PATH_TO_YOUR_CONTAINER_IMAGE'
}
Or, run the nextflow using the 'with-singularity' flag and the path to the image.

WORKFLOWS:

se_demux_to_bam_bai_denovo - Takes single-end Illumina reads, makes a de novo reference, and aligns samples to those reads. Bam and bai files are output.
[Associated Docker repo](https://hub.docker.com/r/harrisonjg/nf_se_demux_to_bam_bai_denovo)

gbs_nextflow - In progress. This will be an all encompassing RADseq workflow. Currently determining if this makes sense versus using several smaller workflows.
