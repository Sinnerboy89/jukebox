# install openmpi (needed by mpi4py) as user
gunzip -c openmpi-4.0.4.tar.gz | tar xf -
cd /home/chrisb/openmpi-4.0.4
./configure --prefix=/home/chrisb/openmpi-4.0.4
make all install

# add openmpi to paths
export PATH=$PATH:/home/chrisb/openmpi-4.0.4/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/chrisb/openmpi-4.0.4/lib

# pretrained models: 1b_lyrics, 5b, 5b_lyrics

# sample test (mpi)
model=1b_lyrics
outdir=out_$model
sample_length=20
total_sample_length=180
srate=44100
mpiexec -n 2 python3 jukebox/sample.py --model=$model --name=$outdir --levels=3 --sample_length_in_seconds=$sample_length --total_sample_length_in_seconds=$total_sample_length --sr=$srate --n_samples=6 --hop_fraction=0.5,0.5,0.125

# prompt with music
python jukebox/sample.py --model=5b_lyrics --name=sample_5b_prompted --levels=3 --mode=primed \
--audio_file=path/to/recording.wav,awesome-mix.wav,fav-song.wav,etc.wav --prompt_length_in_seconds=12 \
--sample_length_in_seconds=20 --total_sample_length_in_seconds=180 --sr=44100 --n_samples=6 --hop_fraction=0.5,0.5,0.125


# --------------------------------------
# ---------- Youtube scraping ----------
# --------------------------------------


# update youtube-dl
python3 -m pip install --upgrade --prefix=/share/tools/pip3 youtube_dl

# gather prompt dataset of 4 tracks
cd /home/chrisb/jukebox/data/muse_test
python3 -m youtube_dl --audio-format wav -x https://www.youtube.com/watch?v=3dm_5qWWDV8
python3 -m youtube_dl --audio-format wav -x https://www.youtube.com/watch?v=qhduQhDqtb4
python3 -m youtube_dl --audio-format wav -x https://www.youtube.com/watch?v=dbB-mICjkQM
python3 -m youtube_dl --audio-format wav -x https://www.youtube.com/watch?v=Pgum6OT_VH8

# isolate guitars
in=/home/chrisb/jukebox/data/muse_test/hysteria.wav
outdir=/home/chrisb/temp
python3 /home/chrisb/jukebox/spleeter_4stem.py $in $outdir


# ----------------------------------------
# ---------- GuitarSet training ----------
# ----------------------------------------


datadir=/home/chrisb/jukebox/data/guitarset/solo
gpus=2
mpiexec -n $gpus python jukebox/train.py --hps=small_vqvae --name=small_vqvae --sample_length=262144 --bs=4 --audio_files_dir=$datadir --labels=False --train --aug_shift --aug_blend