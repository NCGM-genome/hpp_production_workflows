version 1.0

import "../tasks/ntsm.wdl" as ntsm_check

workflow ont_qc_wf {
    input {
        File ont_reads
        Array[File] other_reads
        String file_id
    }

    parameter_meta {
        ont_reads: "Reads to QC. Should be single file. Can be .fq.gz, fastq.gz, or bam."
        other_reads: "Trusted reads to compare against to check for sample swaps. Can be fastq, fastq.gz, or bam."
        file_id: "Id to use for output naming."
    }

    meta {
        author: "Julian Lucas, Takeshi Fujino"
        email: "juklucas@ucsc.edu, fujino@edu.k.u-tokyo.ac.jp"
    }

    ## check for sample swaps
    call ntsm_check.ntsm_workflow as ntsm_wf {
        input:
            input_reads_1  = [ont_reads],
            input_reads_2  = other_reads,
            sample_id      = file_id,
            read_1_type    = "ont",
            read_2_type    = "other"
    }

    output {
        ## ntsm output (check for sample swaps)
        File ont_ntsm_counts      = ntsm_wf.ntsm_count_1
        File ext_ntsm_counts      = ntsm_wf.ntsm_count_2
        File ntsm_eval            = ntsm_wf.ntsm_eval_out
    }
}
