# QTQ

### Commands to use:

      cd QTQ
   
      chmod +x ./*.sh
   
     ./qc-trim-qc.sh
   
      cd ~/Desktop

      mkdir GenopicsApps

      cd GenomicsApps

Download Fastp and Trimmomatic executables and keep inside GenomicsApps.
        
      get http://opengene.org/fastp/fastp

      chmod a+x ./fastp

or download specified version, i.e. fastp v0.23.4
      
      wget http://opengene.org/fastp/fastp.0.23.4
  
      mv fastp.0.23.4 fastp

      chmod a+x ./fastp

Download Trimmomatic
       
      wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip

      unzip Trimmomatic-0.39.zip

      rm Trimmomatic-0.39.zip

Run:
I: Input path [String]

O: Output path [String]

L: Minimum length of reads to keep [Int]

T: fp (Fastp) or Tr (Trimmomatic)

      ./qc-trim-qc.sh -I  /path_to_input_data_directory/ -O /path_to_Output_directory/ -L 35 -T fp
