import sounddevice as sd
from scipy.io.wavfile import read

fs, data = read("audio_capturado.wav")
sd.play(data, fs)
sd.wait()
