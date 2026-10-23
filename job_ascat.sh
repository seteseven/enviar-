#!/bin/bash
#SBATCH --job-name=sarek_ascat
#SBATCH --partition=g128
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --output=sarek_%j.log

set -euo pipefail

module load java singularity nextflow

ASCAT_DIR="/home/geovanemartins/projects_PatriciaPossik/hailstorms_acral/data/Brazilian_cohort/ASCAT"

cd "$ASCAT_DIR"

export NXF_SINGULARITY_CACHEDIR="/home/geovanemartins/singularity_cache"
mkdir -p "$NXF_SINGULARITY_CACHEDIR"

nextflow run nf-core/sarek -r 3.4.0 \
  -profile singularity \
  -c "$ASCAT_DIR/cluster.config" \
  --max_cpus 8 \
  --max_memory '32.GB' \
  --max_time '720.h' \
  --input "$ASCAT_DIR/samplesheet_sarek_pares.csv" \
  --outdir "$ASCAT_DIR/results_sarek_ascat" \
  --step variant_calling \
  --tools ascat \
  --genome GATK.GRCh38 \
  --wes \
  --intervals "$ASCAT_DIR/Illumina_Exome_TargetedRegions_v1.2.hg38.bed" \
  --ascat_alleles "$ASCAT_DIR/G1000_alleles_WES_hg38.zip" \
  --ascat_loci "$ASCAT_DIR/G1000_loci_WES_hg38.zip" \
  --ascat_loci_gc "$ASCAT_DIR/GC_G1000_WES_hg38.zip" \
  --ascat_loci_rt "$ASCAT_DIR/RT_G1000_WES_hg38.zip" \
  -resume
