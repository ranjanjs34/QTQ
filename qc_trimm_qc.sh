#! /usr/bin/bash

while getopts "I:O:L:T:" opt; do
  case $opt in
    I) I=$OPTARG;;
    O) O=$OPTARG;;
    L) L=$OPTARG;;
    T) T=$OPTARG;;
    \?) echo "Invalid option: -$OPTARG" >&2;;
    :) echo "Option -$OPTARG requires an argument." >&2;;
  esac
done
clear



echo -e "**************************************\n\n"
echo ""
echo "Input: $I"
echo "Output: $O"
echo "Minimum Length: $L"
echo -e "Tool (t-Trimmomatic fp-FASTP): $T\n\n"
echo -e "**************************************"
printf "If above arguments are correct, the press ENTER to proceed. Otherwise 'ctrl+c' to abort. : "
read Proceed_Check





mkdir $O/qc_trim_qc_OUTPUT
if [ $T == "t" ]
then
	cp -r  $T/Trimmomatic*/adapters $(pwd)/

elif [ $T == "fp" ]
then
	mkdir -p $O/qc_trim_qc_OUTPUT/fastp_report
fi




mkdir -p $O/Trimmed_No_Adapters
cln_read=$O/qc_trim_qc_OUTPUT/Trimmed_No_Adapters

mkdir -p $O/qc_trim_qc_OUTPUT/FASTQC_Before_Trimming
out1=$O/qc_trim_qc_OUTPUT/FASTQC_Before_Trimming

mkdir -p $O/qc_trim_qc_OUTPUT/FASTQC_After_Trimming
out2=$O/qc_trim_qc_OUTPUT/FASTQC_After_Trimming




tools=$HOME/Desktop/GenomicsApps


for dir in $I/*/
do
	dir=${dir%/}	
	
	if [ $T == "t" ]
	then
		
		mkdir -p $cln_read/${dir##*/}
		mkdir -p $O/qc_trim_qc_OUTPUT/trimmlog
		trimlog=$O/qc_trim_qc_OUTPUT/trimmlog
		mkdir -p $trimlog/${dir##*/}_unpaired
		mkdir -p $trimlog/${dir##*/}_unpaired	
		clear
		
		
		echo "Ranjan Jyoti Sarma"
		echo "Dept. of Biotechnology, Mizoram University, Aizawl."
		
		
		
		java -jar $tools/Trimmomatic*/trimmomatic*.jar PE -threads 40 -phred33 -trimlog $trimlog/${dir##*/}.trimm.log -summary $trimlog/${dir##*/}.summary_trimm.log -validatePairs $I${dir##*/}/*_R1.fastq.gz $I${dir##*/}/*_R2.fastq.gz $cln_read${dir##*/}/${dir##*/}_R1.fastq.gz $trimlog/${dir##*/}_unpaired/${dir##*/}_Unpaird_r1.fq.gz $cln_read${dir##*/}/${dir##*/}_R2.fastq.gz $trimlog/${dir##*/}_unpaired/${dir##*/}_Unpaird_r2.fq.gz ILLUMINACLIP:./adapters/TruSeq3-PE.fa:2:30:1 HEADCROP:15 LEADING:25 TRAILING:25 SLIDINGWINDOW:4:25  L:$L
		
		
		echo -e "java -jar $tools/Trimmomatic*/trimmomatic*.jar PE -threads 40 -phred33 -trimlog $trimlog/${dir##*/}.trimm.log -summary $trimlog/${dir##*/}.summary_trimm.log -validatePairs $I${dir##*/}/*_R1.fastq.gz $I${dir##*/}/*_R2.fastq.gz $cln_read${dir##*/}/${dir##*/}_R1.fastq.gz $trimlog/${dir##*/}_unpaired/${dir##*/}_Unpaird_r1.fq.gz $cln_read${dir##*/}/${dir##*/}_R2.fastq.gz $trimlog/${dir##*/}_unpaired/${dir##*/}_Unpaird_r2.fq.gz ILLUMINACLIP:./adapters/TruSeq3-PE.fa:2:30:1 HEADCROP:15 LEADING:25 TRAILING:25 SLIDINGWINDOW:4:25  L:$L\n\n">>$cln_read/${dir##*/}/${dir##*/}.trimmomatic.txt
		
		
		mkdir -p $out1/${dir##*/}
		fastqc -t 6 -q $I/${dir##*/}/*.fastq.gz -o $out1/${dir##*/}/
		mkdir -p $out2/${dir##*/}
		fastqc -t -q 6 $I/${dir##*/}/*.fastq.gz -o $out2/${dir##*/}/
				
			
	elif [ $T == "fp" ]
	
	then 
		clear
		echo "Developer: Ranjan Jyoti Sarma, M.Phil."
		echo -e "Dept. of Biotechnology, Mizoram University, Aizawl.\n\n"
		mkdir -p $cln_read/${dir##*/}
		
		echo -e "Runing FASTP Trimming for ${dir##*/}."
		printf "Trimming Criteria are: Start bases: 15,  End Bases: 15, Quality Score <25, PolyG (Min Length 6),  Zero N Bases.\n\n\n"
		
		
		$tools/fastp/fastp -w 16 -i $I/${dir##*/}/*_R1.fastq.gz -I $I/${dir##*/}/*_R2.fastq.gz -o $cln_read/${dir##*/}/${dir##*/}_R1.fastq.gz -O $cln_read/${dir##*/}/${dir##*/}_R2.fastq.gz --detect_adapter_for_pe -f 15 -t 10 -r 25 --trim_poly_g --poly_g_min_len 6 --n_base_limit 0 -l $L --html $O/qc_trim_qc_OUTPUT/fastp_report/"${dir##*/}.fastp.report.html"
		rm *.json
		
		
		echo -e "Complete FASTP Trimming for ${dir##*/}.\n"
		echo -e "$tools/fastp/fastp -w 16 -i $I/${dir##*/}/*_R1.fastq.gz -I $I/${dir##*/}/*_R2.fastq.gz -o $cln_read/${dir##*/}/${dir##*/}_R1.fastq.gz -O $cln_read/${dir##*/}/${dir##*/}_R2.fastq.gz --detect_adapter_for_pe -f 15 -t 15 --cut_mean_quality 25 --trim_poly_g --poly_g_min_len 6 --n_base_limit 0 -l $L --html $O/qc_trim_qc_OUTPUT/fastp_report/"${dir##*/}.report.html"\n\n">>$cln_read/${dir##*/}/${dir##*/}.fastp.txt
		
		
		mkdir -p $out1/${dir##*/}
		echo -e "Running FASTQC before Trimming by FASTP for ${dir##*/}."
		fastqc -t 6 -q $I/${dir##*/}/*.fastq.gz -o $out1/${dir##*/}/
		echo -e "Done!\n"
		mkdir -p $out2/${dir##*/}
		echo -e "Running FASTQC after Trimming by FASTP for ${dir##*/}."
		fastqc -t 6 -q $cln_read/${dir##*/}/*.fastq.gz -o $out2/${dir##*/}/
		echo "Done!"
		clear
	fi
done
if [ $T == "t" ]
then
	rm -r $(pwd)/adapters
fi
echo "QC Done!"

#OLD COMMAND:java -jar $tools/Trimmomatic*/trimmomatic*.jar PE -threads 16 -phred33 -trimlog $trimlog/${dir##*/}.trimm.log -summary $trimlog/${dir##*/}.summary_trimm.log -validatePairs $I/${dir##*/}/*_R1.fastq.gz $I/${dir##*/}/*_R2.fastq.gz $cln_read/${dir##*/}/${dir##*/}_R1.fastq.gz $trimlog/${dir##*/}_unpaired/${dir##*/}_Unpaird_r1.fq.gz $cln_read/${dir##*/}/${dir##*/}_R2.fastq.gz $trimlog/${dir##*/}_unpaired/${dir##*/}_Unpaird_r2.fq.gz ILLUMINACLIP:./adapters/TruSeq3-PE.fa:2:30:1  SLIDINGWINDOW:4:15  L:$L HEADCROP:20 LEADING:25 TRAILING:25 CROP:90
