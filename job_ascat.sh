#!/bin/bash
#SBATCH --job-name=sarek_ascat
#SBATCH --partition=g128
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=7-00:00:00
#SBATCH --output=sarek_%j.log
#SBATCH --error=sarek_%j.err

set -euo pipefail

# Carregar módulos
module load nextflow
module load apptainer/1.4.4

# Diretório do projeto
ASCAT_DIR="/home/geovanemartins/projects_PatriciaPossik/hailstorms_acral/data/Brazilian_cohort/ASCAT"

cd "$ASCAT_DIR"

# Cache de imagens dos contêineres
export NXF_APPTAINER_CACHEDIR="/home/geovanemartins/singularity_cache"
mkdir -p "$NXF_APPTAINER_CACHEDIR"

# Configuração do Nextflow
export NXF_WORK="$ASCAT_DIR/work"

# Executar Sarek com ASCAT
nextflow run nf-core/sarek \
    -r 3.4.0 \
    -profile apptainer \
    -c "$ASCAT_DIR/cluster.config" \
    --max_cpus 8 \
    --max_memory '32.GB' \
    --max_time '168.h' \
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
