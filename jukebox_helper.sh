# install openmpi (needed by mpi4py) as user
gunzip -c openmpi-4.0.4.tar.gz | tar xf -
cd openmpi-4.0.4
./configure --prefix=/home/chrisb/openmpi-4.0.4
make all install

# add openmpi to paths
export PATH=$PATH:/home/chrisb/openmpi-4.0.4/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/chrisb/openmpi-4.0.4/lib

# sample test
python3 jukebox/sample.py --model=1b_lyrics --name=sample_1b_lyrics --levels=3 --sample_length_in_seconds=20 --total_sample_length_in_seconds=180 --sr=44100 --n_samples=6 --hop_fraction=0.5,0.5,0.125