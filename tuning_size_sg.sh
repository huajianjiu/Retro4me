CBDIR=../CB-SGwithPP
VECTORDIR=../word2vec/skipgram_vectors_1stline_removed
RETROVECTORDIR=./Vectors_retro_sg
RESULTDIR=./Result_retro_sg
GLOVEDIR=../GloveMe

mkdir -p "${RESULTDIR}"
mkdir -p "${RETROVECTORDIR}"

for i in $(seq 100 50 800); do
    echo "vector size: ${i}";
    
    sed -i "1d" "${VECTORDIR}"/t9_s${i}w8ns25_sg.bin.txt
    python retrofit.py -i "${VECTORDIR}"/t9_s${i}w8ns25_sg.bin.txt -l lexicons/ppdb-xl.txt -n 10 -o "${RETROVECTORDIR}"/retro_sg_t9_s${i}w8ns25.vec
    python "${CBDIR}"/compute-wordsim.py "${RETROVECTORDIR}"/retro_sg_t9_s${i}w8ns25.vec WS353.csv > "${RESULTDIR}"/353_retro_sg_t9_s${i}w8n25.txt;
    python "${CBDIR}"/compute-wordsim.py "${RETROVECTORDIR}"/retro_sg_t9_s${i}w8ns25.vec SimLex-999.csv > "${RESULTDIR}"/999_retro_sg_t9_s${i}w8n25.txt;
    python "${CBDIR}"/compute-wordsim.py "${RETROVECTORDIR}"/retro_sg_t9_s${i}w8ns25.vec rw.csv > "${RESULTDIR}"/rw_retro_sg_t9_s${i}w8n25.txt;
    python "${GLOVEDIR}"/eval/python/evaluate.py --vocab_file=vocab_text9.txt --vectors_file="${RETROVECTORDIR}"/retro_sg_t9_s${i}w8ns25.vec;
done
