# QTQ

### Commands to use:

      cd QTQ
   
      chmod +x ./*.sh
   
     ./qc-trim-qc.sh
   
Run:
I: Input path [String]

O: Output path [String]

L: Minimum length of reads to keep [Int]

T: fp (Fastp) or Tr (Trimmomatic)

      ./qc-trim-qc.sh -I  /path_to_input_data_directory/ -O /path_to_Output_directory/ -L 35 -T fp
