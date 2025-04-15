import os
print("os done")
import sys
print("sys done")
# Ensure current directory (or project root) is on PYTHONPATH
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
if BASE_DIR not in sys.path:
    sys.path.insert(0, BASE_DIR)
import torch
print("import torch done")
import torchaudio
print("import torchaudio done")
import torch._dynamo
print("import torch__dynamo done")
#torch._dynamo.config.suppress_errors = True
import abc
print("abc done")
import itertools
print("itertools done")
import re
print("re done")
from logging import Logger
from typing import Optional, List, Any, Dict, Tuple, Union, Pattern
import joblib
print("joblib done")
from phonemizer.logger import get_logger
from phonemizer.punctuation import Punctuation
from phonemizer.separator import Separator, default_separator
from phonemizer.utils import chunks

from phonemizer.backend import EspeakBackend

from zonos.model import Zonos
from zonos.conditioning import make_cond_dict
from zonos.utils import DEFAULT_DEVICE as device
#=====================
# model = Zonos.from_pretrained("Zyphra/Zonos-v0.1-hybrid", device=device)
print("start model")
model = Zonos.from_pretrained("Zyphra/Zonos-v0.1-transformer", device=device)
print("model done")

import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--input", type=str, required=True, help="Path to input .wav file")
parser.add_argument("--output", type=str, required=True, help="Path to save generated .wav file")
args = parser.parse_args()

input_path = args.input
output_path = args.output

uri = args.input
print("Arg pursing done")
assert os.path.isfile(uri), "File not found!"
wav, sampling_rate = torchaudio.load()
print("torchaudio.load done")
speaker = model.make_speaker_embedding(wav, sampling_rate)
print("make_speaker_embedding done")
cond_dict = make_cond_dict(text="I do not know what i am trying to do, but keep on trying. This is my life, you know!", speaker=speaker, language="en-us")
print("make_cond_dict done")
conditioning = model.prepare_conditioning(cond_dict)
print("prepare_conditioning done")
codes = model.generate(conditioning)
print("model.generate done")
wavs = model.autoencoder.decode(codes).cpu()
print("model.autoencoder.decode done")
torchaudio.save(args.output, wavs[0], model.autoencoder.sampling_rate)
print("torchaudio.save done")