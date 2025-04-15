@echo off
REM open VS 2019 development Environment as administartor
echo REM ===== Full Setup: PyTorch AOTInductor + Zonos-TTS (CPU, Windows) =====

echo REM Step 0: Enable Visual Studio Build Environment
call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"

echo Step 1: Enable Git long paths (one-time)
git config --system core.longpaths true

echo Step 2: Clone PyTorch from source
cd C:\sn\zns
echo git clone --recursive https://github.com/pytorch/pytorch
git clone --recursive https://github.com/pytorch/pytorch
cd pytorch

echo Step 3: Install PyTorch build dependencies
pip install -r requirements.txt
pip install sympy==1.13.1 numpy ninja cmake typing_extensions

echo Step 4: Set build environment for AOTInductor
set USE_CUDA=0
set TORCHINDUCTOR_AOTIR=1
set CMAKE_GENERATOR=Ninja
set CFLAGS=/Zm2000 /wd4556 /wd4717
set CXXFLAGS=/Zm2000 /wd4556 /wd4717

echo Step 5: Build PyTorch from source
python setup.py develop

echo Step 6: Clone Zonos-TTS and set up environment
cd C:\SNN
echo git clone --recursive https://github.com/SNDOTAI/Zonos-for-windows.git
git clone --recursive https://github.com/SNdotAI/Zonos-for-windows.git
rename Zonos-for-windows ZNS
cd ZNS
echo rename Zonos-for-windows ZNS == done
echo Step 7: Create and activate virtual environment (optional)
python -m venv ZNvenv
call ZNvenv\Scripts\activate

echo Step 8: Install Zonos requirements
pip install -r all-requirements.txt
pip install sympy==1.13.1 numpy ninja cmake typing_extensions
pip install safetensors huggingface_hub transformers inflect kanjize phonemizer sudachipy sudachidict_full soundfile

echo Step 9: Optional: Install torch again to ensure linkage works with build
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

echo Step 10: Run Zonos to generate from input WAV
cd c:\SNN\zns
python zonosnew.py --input "C:\SN\VoiceSample\Sharmila.wav" --output "C:\SN\VoiceSample\Sharmila_Generated.wav"

echo Step 11: Save full environment for reproducibility
pip freeze > ..\requirements_zonos_full.txt

echo ✅ All done! Output file generated with AOT-enabled PyTorch.
