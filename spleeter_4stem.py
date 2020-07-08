import sys

sys.path.append("/home/chrisb/spleeter")
from spleeter.separator import Separator

# Using embedded configuration
separator = Separator("spleeter:4stems")
separator.separate_to_file(sys.argv[1], sys.argv[2])
